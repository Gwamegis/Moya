//
//  MiniPlayerProgressBar.swift
//  Halmap
//
//  Created by Kyubo Shim on 1/20/24.
//

import SwiftUI
import AVFoundation
import SwiftUIIntrospect

struct MiniPlayerProgressBar: View {
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
            MiniPlayerAudioControlsView(player: audioManager.player,
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

struct MiniPlayerAudioControlsView: View {
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
            }
            .onChange(of: self.state) { _ in
                print("State: \(state)")
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
            thumb.backgroundColor = UIColor.clear
            return thumb
        }()
        let radius: CGFloat = 1
        thumbView.frame = CGRect(x: 0, y: 0, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        let image = renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
        
        return image
    }

}
