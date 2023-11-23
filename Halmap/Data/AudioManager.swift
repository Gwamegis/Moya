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
    
    @Published var progressValue: Float = 0 //player.seek 에서 사용
    {
        didSet {
            print("progressValue: ", progressValue)
        }
    }
    @Published var currentTime: Double = 0 //재생바 현재 시간 표시에서 사용
    {
        didSet {
            print("currentTime: ", currentTime)
        }
    }
    @Published var currentIndex: Int = 0 //현재 재생중인 곡 index
    
    var duration: Double {
        return player?.currentItem?.duration.seconds ?? 0
    }
    
    //progressbar
    var currentTimePublisher: PassthroughSubject<Double, Never> = .init()
    var currentProgressPublisher: PassthroughSubject<Float, Never> = .init()
    private var playerPeriodicObserver: Any?
    var acceptProgressUpdates = true
    
    private var playerItemContext = 0
    
    var song: SongInfo?
    var selectedTeam = ""
    
    
    // MARK: - AM Properties
    
    private var AMduration: Double {
        return player?.currentItem?.duration.seconds ?? 0
    }
    
    func AMset(song: SongInfo) {
        self.song = song
        self.progressValue = 0
        self.currentTime = 0
        let changedTitle = "\(self.selectedTeam) \(song.title)"
        
        // 로컬에 해당 노래가 이미 저장되어 있는지 확인

        if let localURL = getLocalFileURL(for: changedTitle, extension: URL(string: song.url)?.pathExtension ?? "mp3") {
            print("이미 저장되었습니다.")
            self.item = AVPlayerItem(url: localURL)
            setupPlayer()
        } else {
            print("다운로드를 시작합니다.")
            guard let remoteURL = URL(string: song.url) else { fatalError("url을 변환할 수 없습니다.") }
            downloadAndPlaySong(from: remoteURL, named: changedTitle)
        }
    }


    
    // 로컬 파일 경로 불러오기
    private func getLocalFileURL(for changedTitle: String, extension ext: String) -> URL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        if let applicationSupportURL = urls.first {
            let fileURL = applicationSupportURL.appendingPathComponent(changedTitle).appendingPathExtension(ext)
            if fileManager.fileExists(atPath: fileURL.path) {
                return fileURL
            }
        }
        return nil
    }

    // url로부터 노래 다운로드 후 노래 제목으로 저장
    private func downloadAndPlaySong(from remoteURL: URL, named changedTitle: String) {
        let fileExtension = remoteURL.pathExtension
        URLSession.shared.dataTask(with: remoteURL) { data, response, error in
            if let data = data {
                let fileManager = FileManager.default
                let urls = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
                if let applicationSupportURL = urls.first {
                    let fileURL = applicationSupportURL.appendingPathComponent(changedTitle).appendingPathExtension(fileExtension)
                    do {
                        try data.write(to: fileURL)
                        DispatchQueue.main.async {
                            self.item = AVPlayerItem(url: fileURL)
                            self.setupPlayer()
                        }
                    } catch {
                        print("Error saving file: \(error)")
                    }
                }
            }
        }.resume()
    }

    
    // 노래 재생
    private func setupPlayer() {
        self.item?.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.status),
                               options: [.old, .new],
                               context: &playerItemContext)
        
        player = AVPlayer(playerItem: item)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
        if let player = player {
            setupPeriodicObservation(for: player)
            AMplay()
        }
    }
    
    // MARK: - AM Functions
    
    func AMplay() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.AMplayEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        setupRemoteTransportControls()
        
        player?.play()
        isPlaying = true
        
        updateNowPlayingPlaybackRate()
    }

    
    func AMstop() {
        updateNowPlayingPlaybackRate()
        
        guard let player = player else {
            print("Instance of audio player not found")
            return
        }
        player.pause()
        isPlaying = false
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
    func removePlayer() {
        AMstop()
    }
    
    //MARK: - progressbar
    private func AMconvertFloatToCMTime(_ percentage: Float) -> CMTime {
        return CMTime(seconds: AMduration * Double(percentage), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    }
    
    private func AMcalculateProgress(currentTime: Double) -> Float {
        return Float(currentTime / AMduration)
    }
    
    private func calculateProgress(currentTime: Double) -> Float {
        return Float(currentTime / duration)
    }
    
    //재생바 이동 시
    func didSliderChanged(_ didChange: Bool) {
        acceptProgressUpdates = !didChange
        if didChange {
            self.AMstop()
        } else {
            self.AMseek(to: progressValue)
            self.AMplay()
        }
    }
    //재생바 설정
    private func setupPeriodicObservation(for player: AVPlayer) {
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
        
        playerPeriodicObserver = player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] (time) in
            guard let `self` = self else { return }
            self.currentTime = time.seconds
            let progress = self.calculateProgress(currentTime: time.seconds)
            self.progressValue = progress
            
            self.currentProgressPublisher.send(progress)
            self.currentTimePublisher.send(time.seconds)
            
            updateNowPlayingPlaybackRate()
        }
    }
    
    deinit {
        player = nil
        
        self.item?.removeObserver(self as NSObject,
                                  forKeyPath: #keyPath(AVPlayerItem.status),
                                  context: &playerItemContext)
    }
}

// MARK: - Media Player Setting..
extension AudioManager {
    
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
                player?.play()
                isPlaying = true
                
                updateNowPlayingPlaybackRate()
                
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
        
        commandCenter.changePlaybackPositionCommand.addTarget { [unowned self] event in
            if let positionTime = (event as? MPChangePlaybackPositionCommandEvent)?.positionTime {
                let seekTime = CMTime(value: Int64(positionTime), timescale: 1)
                self.currentTime = seekTime.seconds
                self.progressValue = self.calculateProgress(currentTime: seekTime.seconds)
                self.player?.seek(to: seekTime)
                //                AMseek(to: progressValue)
            }
            return .success
        }
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
                    if let playerItem = object as? AVPlayerItem {
                                        print("Player item error: \(String(describing: playerItem.error?.localizedDescription))")
                                    }
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
    
}
