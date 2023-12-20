//
//  Progress.swift
//  Halmap
//
//  Created by JeonJimin on 11/24/23.
//
import SwiftUI
import AVFoundation
import SwiftUIIntrospect

struct Progressbar: View {
    @EnvironmentObject var audioManager: AudioManager
    
    @Binding var song: SongInfo
    @Binding var toast: Toast?
    
    let isThumbActive: Bool
    
    init(song: Binding<SongInfo>, toast: Binding<Toast?>, isThumbActive: Bool) {
        self.isThumbActive = isThumbActive
        self._song = song
        self._toast = toast
        UISlider.appearance().maximumTrackTintColor = UIColor(Color.customGray.opacity(0.2))
    }
    
    var body: some View {
        VStack {
            AudioPlayerControlsView(player: audioManager.player,
                                    timeObserver: PlayerTimeObserver(player: audioManager.player),
                                    durationObserver: PlayerDurationObserver(player: audioManager.player),
                                    itemObserver: PlayerItemObserver(player: audioManager.player),
                                    isThumbActive: isThumbActive,
                                    song: $song,
                                    toast: $toast)
            
        }
        .tint(Color("\(song.team)Point"))
        .padding(.horizontal, isThumbActive ? 5 : 0)
        .onDisappear {
            audioManager.AMstop()
        }
    }
}

struct AudioPlayerControlsView: View {
    private enum PlaybackState: Int {
        case pause
        case buffering
        case playing
    }
    
    let player: AVPlayer
    let timeObserver: PlayerTimeObserver
    let durationObserver: PlayerDurationObserver
    let itemObserver: PlayerItemObserver
    let isThumbActive: Bool
    @State private var currentTime: TimeInterval = 0
    @State private var currentDuration: TimeInterval = 0
    @State private var state = PlaybackState.pause
    
    @Binding var song: SongInfo
    @Binding var toast: Toast?
    
    @FetchRequest(
        entity: CollectedSong.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.order, ascending: true)],
        predicate: PlaylistFilter(filter: "defaultPlaylist").predicate,
        animation: .default) private var defaultPlaylistSongs: FetchedResults<CollectedSong>
    
    var body: some View {
        VStack {
            Slider(value: $currentTime,
                   in: 0...currentDuration,
                   onEditingChanged: sliderEditingChanged)
            .introspect(.slider, on: .iOS(.v15,.v16,.v17), customize: { slider in
                slider.setThumbImage(makeThumbView(isThumbActive: isThumbActive), for: .normal)
            })
            .disabled(state != .playing)
            .onReceive(timeObserver.publisher) { time in
                self.currentTime = time
                if time > 0 {
                    self.state = .playing
                }
            }
            .onReceive(durationObserver.publisher) { duration in
                // Update the local var
                self.currentDuration = duration
            }
            .onReceive(itemObserver.publisher) { hasItem in
                self.state = hasItem ? .buffering : .pause
                self.currentTime = 0
                self.currentDuration = 0
                
                // MARK: 노래 끝났을때 처리 로직
                if self.state == .pause {
                    if let index = defaultPlaylistSongs.firstIndex(where: {$0.id == song.id}) {
                        if index + 1 < defaultPlaylistSongs.count {
                            self.song = Utility.convertSongToSongInfo(song: defaultPlaylistSongs[Int(defaultPlaylistSongs[index].order + 1)])
                        } else {
                            if defaultPlaylistSongs.count > 1 {
                                toast = Toast(team: defaultPlaylistSongs[0].safeTeam, message: "재생목록이 처음으로 돌아갑니다.")
                                self.song =  Utility.convertSongToSongInfo(song: defaultPlaylistSongs[0])
                            }
                        }
                    }
                }
            }
            .onChange(of: self.state) { _ in
                print("State: \(state)")
            }
            
            if isThumbActive {
                HStack {
                    Text(Utility.formatSecondsToHMS(currentTime))
                    Spacer()
                    Text(Utility.formatSecondsToHMS(currentDuration))
                }
                .font(Font.Halmap.CustomCaptionMedium)
                .foregroundColor(.customGray)
            }
        }
    }
    
    // MARK: Private functions
    private func sliderEditingChanged(editingStarted: Bool) {
        if editingStarted {
            timeObserver.pause(true)
        }
        else {
            state = .buffering
            let targetTime = CMTime(seconds: currentTime,
                                    preferredTimescale: 600)
            player.seek(to: targetTime) { _ in
                self.timeObserver.pause(false)
                self.state = .playing
                AudioManager.instance.updateNowPlayingPlaybackRate()
            }
        }
    }
    private func makeThumbView(isThumbActive: Bool) -> UIImage {
        lazy var thumbView: UIView = {
            let thumb = UIView()
            thumb.backgroundColor = UIColor(isThumbActive ? Color("\(song.team)Point") : Color.clear)
            return thumb
        }()
        let radius:CGFloat = 10
        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        let image = renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
        
        return image
    }
}

import Combine
class PlayerTimeObserver {
    let publisher = PassthroughSubject<TimeInterval, Never>()
    private weak var player: AVPlayer?
    private var timeObservation: Any?
    private var paused = false
    
    init(player: AVPlayer) {
        self.player = player
        
        timeObservation = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: nil) { [weak self] time in
            guard let self = self else { return }
            guard !self.paused else { return }
            self.publisher.send(time.seconds)
        }
    }
    
    deinit {
        if let player = player,
            let observer = timeObservation {
            player.removeTimeObserver(observer)
        }
    }
    
    func pause(_ pause: Bool) {
        paused = pause
    }
}

class PlayerItemObserver {
    let publisher = PassthroughSubject<Bool, Never>()
    private var itemObservation: NSKeyValueObservation?
    
    init(player: AVPlayer) {
        // Observe the current item changing
        itemObservation = player.observe(\.currentItem) { [weak self] player, change in
            guard let self = self else { return }
            // Publish whether the player has an item or not
            self.publisher.send(player.currentItem != nil)
        }
    }
    
    deinit {
        if let observer = itemObservation {
            observer.invalidate()
        }
    }
}

class PlayerDurationObserver {
    let publisher = PassthroughSubject<TimeInterval, Never>()
    private var cancellable: AnyCancellable?
    
    init(player: AVPlayer) {
        let durationKeyPath: KeyPath<AVPlayer, CMTime?> = \.currentItem?.duration
        cancellable = player.publisher(for: durationKeyPath).sink { duration in
            guard let duration = duration else { return }
            guard duration.isNumeric else { return }
            self.publisher.send(duration.seconds)
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
}
