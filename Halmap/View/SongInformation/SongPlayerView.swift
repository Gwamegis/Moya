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
    //    @State var player = AVPlayer()
    @State var isPlaying: Bool = true
    @Environment(\.presentationMode) var presentationMode
    
    @State var value: Double = 0.0
    @EnvironmentObject var audioManager: AudioManager
    let timer = Timer
        .publish(every: 0.3, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        HStack {
            Button {
                isPlaying.toggle()
                if isPlaying {
                    AudioManager.instance.playSound(song.url)
                } else {
                    AudioManager.instance.stopSound()
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
            AudioManager.instance.stopSound()
        }
        .onAppear(){
            AudioManager.instance.playSound(song.url)
        }
        .onReceive(timer) { _ in
            guard let player = AudioManager.instance.player else { return }
            guard let item = AudioManager.instance.player?.currentItem else { return }
            if CMTimeGetSeconds(player.currentTime()) == CMTimeGetSeconds(item.duration) {
                isPlaying = false
            }
            //              value = CMTimeGetSeconds(player.currentTime())
        }
    }
}

