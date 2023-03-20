//
//  SongHeaderView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI
import AVFoundation

struct SongPlayerView: View {
    
    @State var selectedTeam: String = (UserDefaults.standard.string(forKey: "selectedTeam") ?? "test")
    @Binding var song: Song
    @State var sound: Data?
    @State var player = AVPlayer()
    @State var isPlaying: Bool = true
    @Environment(\.presentationMode) var presentationMode
    
    @State var value: Double = 0.0
    @EnvironmentObject var audioManager: AudioManager
    let timer = Timer
        .publish(every: 0.3, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
//        VStack{
            HStack {
                Button {
                    isPlaying.toggle()
                    if isPlaying {
//                        playSoundURL(song.url)
                        AudioManager.instance.playSound(song.url, player: &player)
                    } else {
//                        stopSound()
                        AudioManager.instance.stopSound(player: &player)
                    }
                } label: {
                    Image(systemName: isPlaying ? "stop.circle.fill" : "play.circle.fill")
                        .font(.system(size: 50, weight: .medium))
                        .foregroundColor(.customGray)
                        .padding(.bottom, 20)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.HalmacSub)
            .onDisappear(){
//                stopSound()
                AudioManager.instance.stopSound(player: &player)
            }
            .onAppear(){
//                playSoundURL(song.url)
                AudioManager.instance.playSound(song.url, player: &player)
            }
//        }.onReceive(timer) {
//            value = player.currentTime
//        }
    }
    
/*
    func playSoundURL(_ urlString : String?) {
        
        guard let urlString = urlString else { fatalError("url을 받아올 수 없습니다.") }
        
        guard let url = URL(string: urlString) else { fatalError("url을 변환할 수 없습니다.") }
        let item = AVPlayerItem(url: url)
        
        player = AVPlayer(playerItem: item)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
        player.play()
    }
    
    func stopSound(){
        player.pause()
    }
 */
}

final class AudioManager: ObservableObject {
    static let instance = AudioManager()
    var player: AVPlayer?
    
    @Published private(set) var isPlaying: Bool = false {
        didSet{
            print("isPlaying", isPlaying)
        }
    }
    
    
    func playSound(_ urlString : String?, player: inout AVPlayer) {
//        guard let url = Bundle.main.url(forResource: "Tada", withExtension: ".mp3") else {return}
//
//        do {
//        player = try AVAudioPlayer(contentsOf: url)
//            player?.play()
//        } catch let error {
//            print("Error playing sound. \(error.localizedDescription)")
//
//        }
        
        guard let urlString = urlString else { fatalError("url을 받아올 수 없습니다.") }
        guard let url = URL(string: urlString) else { fatalError("url을 변환할 수 없습니다.") }
        let item = AVPlayerItem(url: url)
        
        player = AVPlayer(playerItem: item)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
        player.play()
    }
    
    func stopSound(player: inout AVPlayer) {
        player.pause()
    }
}
