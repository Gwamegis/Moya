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
    @State var audioPlayer: AVPlayer!
    @State var isPlaying: Bool = true
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            Button {
                isPlaying.toggle()
                if isPlaying {
                    playSoundURL(song.url)
                } else {
                    stopSound()
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
            stopSound()
        }
    }
    
    func playSoundURL(_ urlString : String?) {
        
        guard let urlString = urlString else { fatalError("url을 받아올 수 없습니다.") }
        
        guard let url = URL(string: urlString) else { fatalError("url을 변환할 수 없습니다.") }
        let item = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: item)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
        audioPlayer.play()
    }
    
    func stopSound(){
        guard let player = audioPlayer else {
            return
        }
        player.pause()
    }
}
