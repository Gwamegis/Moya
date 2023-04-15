//
//  AudioManager.swift
//  Halmap
//
//  Created by Yeni Hwang on 2023/03/21.
//

import AVKit
import Foundation
import Combine

final class AudioManager: ObservableObject {
    static let instance = AudioManager()
    var player: AVPlayer?
https://github.com/Gwamegis/Moya/pull/112/conflict?name=Halmap%252FData%252FAudioManager.swift&ancestor_oid=27882f22f0779ce2b9d6c67691dd4b54ca2eacb2&base_oid=8c3ee2228315d5e03b07f8c5dcf05a4d7dc66b7b&head_oid=8a31c36ad4fe19389bf001f72a9d258e37a2d982
    @Published private(set) var isPlaying: Bool = false {
        didSet{
            print("isPlaying", isPlaying)
        }
    }
    
    var currentTimePublisher: PassthroughSubject<Double, Never> = .init()
    var currentProgressPublisher: PassthroughSubject<Float, Never> = .init()
    private var playerPeriodicObserver: Any?
    
    
    // MARK: - AM Properties
    
    private var AMduration: Double {
        return player?.currentItem?.duration.seconds ?? 0
    }
    
    func AMplay(song: Song?, selectedTeam: String) {
        let title = song?.title ?? "Unknow Title"
        let albumArt = UIImage(named: "\(selectedTeam)Album")
        setupNowPlayingInfo(title: title, albumArt: albumArt)
        guard let urlString = urlString else { fatalError("url을 받아올 수 없습니다.") }
        guard let url = URL(string: urlString) else { fatalError("url을 변환할 수 없습니다.") }
        let item = AVPlayerItem(url: url)
        
        player = AVPlayer(playerItem: item)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
        player?.play()
    }
    
    // MARK: - AM Functions
    
    func AMstop() {
        guard let player = player else {
            print("Instance of audio player not found")
            return
        }
        player.pause()
    }
    
    func AMseek(to time: CMTime){
        guard let player = player else { return }
        player.seek(to: time)
    }
    
    func AMseek(to percentage: Float) {
        guard let player = player else { return }
        let time = AMconvertFloatToCMTime(percentage)
        player.seek(to: time)
    }
    
    private func AMconvertFloatToCMTime(_ percentage: Float) -> CMTime {
        return CMTime(seconds: AMduration * Double(percentage), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    }
    
    private func AMcalculateProgress(currentTime: Double) -> Float {
            return Float(currentTime / AMduration)
        }
}
