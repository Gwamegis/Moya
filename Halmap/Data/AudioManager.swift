//
//  AudioManager.swift
//  Halmap
//
//  Created by Yeni Hwang on 2023/03/21.
//

import AVKit
import Foundation
import Combine
import MediaPlayer

final class AudioManager: NSObject, ObservableObject {
    static let instance = AudioManager()
    var player: AVPlayer?

    var item: AVPlayerItem?
    
    @Published private(set) var isPlaying: Bool = false {
        didSet{
            print("isPlaying", isPlaying)
        }
    }
    
    var currentTimePublisher: PassthroughSubject<Double, Never> = .init()
    var currentProgressPublisher: PassthroughSubject<Float, Never> = .init()
    private var playerPeriodicObserver: Any?
    
    private var playerItemContext = 0
    
    var song: SongInfo?
    var selectedTeam = ""

    // MARK: - Media Player Setting..
    
    private func setupNowPlayingInfo(title: String, albumArt: UIImage?) {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        
        if let albumArt = albumArt {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: albumArt.size) { _ in albumArt }
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentItem?.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player?.currentItem?.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func updateNowPlayingPlaybackRate() {
        if var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo {
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentItem?.currentTime().seconds
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
    }
    
    private func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.player?.rate == 0.0 {
                AMplay()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.player?.rate == 1.0 {
                AMstop()
                return .success
            }
            return .commandFailed
        }
    }
    
    // MARK: - AM Properties
    
    private var AMduration: Double {
        return player?.currentItem?.duration.seconds ?? 0
    }
    
    func AMset(song: SongInfo, selectedTeam: String) {
        
        self.song = song
        self.selectedTeam = selectedTeam
        
        guard let url = URL(string: song.url) else { fatalError("url을 변환할 수 없습니다.") }
        self.item = AVPlayerItem(url: url)
        
        self.item?.addObserver(self as NSObject,
                                   forKeyPath: #keyPath(AVPlayerItem.status),
                                   options: [.old, .new],
                                   context: &playerItemContext)
        
        player = AVPlayer(playerItem: item)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
        
        AMplay()
    }
    
    func AMplay() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.AMplayEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        setupRemoteTransportControls()
        
        player?.play()
        isPlaying = true
                
        updateNowPlayingPlaybackRate()
    }
    
    // MARK: - AM Functions
    
    func AMstop() {
        guard let player = player else {
            print("Instance of audio player not found")
            return
        }
        player.pause()
        isPlaying = false
        
        updateNowPlayingPlaybackRate()
    }
    
    @objc func AMplayEnd() {
        AMstop()
        player?.seek(to: .zero)
        NotificationCenter.default.removeObserver(self)
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
    
    //시작 상태 감지를 위한 observer -> 음원이 준비 된 경우 미디어 플레이어 셋팅
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {

        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }

        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }

            // Switch over status value
            switch status {
            case .readyToPlay:
                // Player item is ready to play.
                let title = song?.title ?? "unknown title"
                let albumArt = UIImage(named: "\(selectedTeam)Album")
                self.setupNowPlayingInfo(title: title, albumArt: albumArt)
                
                break
            case .failed:
                // Player item failed. See error.
                print("failed")
                break
            case .unknown:
                // Player item is not yet ready.
                print("unknown")
                break
            @unknown default:
                print("default")
                break
            }
        }
    }
    
    func removePlayer() {
        AMstop()
        player = nil
        
        self.item?.removeObserver(self as NSObject,
                                  forKeyPath: #keyPath(AVPlayerItem.status),
                                  context: &playerItemContext)
        
    }
}
