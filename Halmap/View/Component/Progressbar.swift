//
//  Progress.swift
//  Halmap
//
//  Created by JeonJimin on 11/24/23.
//
import SwiftUI
import AVFoundation

struct Progressbar: View {
    let player: AVPlayer
    @Binding var team: String
    @Binding var currentIndex: Int
    let isThumbActive: Bool
    
    init(player: AVPlayer, currentIndex: Binding<Int>, team: Binding<String>, isThumbActive: Bool) {
        self.player = player
        self.isThumbActive = isThumbActive
        self._currentIndex = currentIndex
        self._team = team
        let thumbImage = makeThumbView(isThumbActive: isThumbActive)
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
        UISlider.appearance().maximumTrackTintColor = UIColor(Color.customGray.opacity(0.2))
    }
    
    var body: some View {
        VStack {
            AudioPlayerControlsView(player: player,
                                    timeObserver: PlayerTimeObserver(player: player),
                                    durationObserver: PlayerDurationObserver(player: player),
                                    itemObserver: PlayerItemObserver(player: player), 
                                    currentIndex: $currentIndex, 
                                    isThumbActive: isThumbActive)
            
        }
        .tint(Color("\(team)Point"))
        .padding(.horizontal, isThumbActive ? 5 : 0)
        .onChange(of: team) { _ in
            print("Team: \(team)")
            let thumbImage = makeThumbView(isThumbActive: isThumbActive)
            UISlider.appearance().setThumbImage(thumbImage, for: .normal)
        }
        .onDisappear {
            self.player.replaceCurrentItem(with: nil)
        }
    }
    
    private func makeThumbView(isThumbActive: Bool) -> UIImage {
        lazy var thumbView: UIView = {
            let thumb = UIView()
            thumb.backgroundColor = UIColor(isThumbActive ? Color("\(team)Point") : Color.clear)
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
    @State private var currentTime: TimeInterval = 0
    @State private var currentDuration: TimeInterval = 0
    @State private var state = PlaybackState.pause
    
    @Binding var currentIndex: Int
    
    @FetchRequest(
        entity: CollectedSong.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.order, ascending: false)],
        predicate: PlaylistFilter(filter: "defaultPlaylist").predicate,
        animation: .default) private var defaultPlaylistSongs: FetchedResults<CollectedSong>
    
    let isThumbActive: Bool
    
    var body: some View {
        VStack {
            Slider(value: $currentTime,
                   in: 0...currentDuration,
                   onEditingChanged: sliderEditingChanged)
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
                
                if self.state == .pause {
                    if currentIndex + 1 < defaultPlaylistSongs.count {
                        currentIndex += 1
                    } else {
                        print("재생목록이 처음으로 돌아갑니다.")
                        currentIndex = 0
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
            }
        }
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
