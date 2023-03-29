//
//  SongHeaderView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI
import AVFoundation
import Combine

struct SongPlayerView: View {
    
    // Song Properties
    @State var selectedTeam: String = (UserDefaults.standard.string(forKey: "selectedTeam") ?? "test")
    @Binding var song: Song
    
    
    // Audio Properties
    let timer = Timer
        .publish(every: 0.3, on: .main, in: .common)
        .autoconnect()
    @State var isPlaying: Bool = true
    @State var value: Double = 0.0
    @State var isEditing: Bool = false
    @EnvironmentObject var audioManager: AudioManager
    @State var endTime: CMTime = CMTime(seconds: 6000, preferredTimescale: 1000000)
    
    
    // View Property
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            
            VStack(spacing: 5){
                
                // TODO: - Progress bar
                // Slider(value: $value)
//                Slider(value: $value, in: 0...CMTimeGetSeconds(endTime)) { editing in
//                    print("editing", editing)
//                    isEditing = editing
//                    if !editing {
//                        player.status = value
//                    }
//                }
//                .accentColor(.white)
                
                // TODO: - Time
                
            }
            
            // Buttons
            HStack(spacing: 52) {
                Button {
                    //이전곡 재생 기능
                } label: {
                    Image(systemName: "backward.end.fill")
                        .font(.system(size: 30, weight: .regular))
                        .foregroundColor(.customGray)
                }

                Button {
                    isPlaying.toggle()
                    if isPlaying {
                        AudioManager.instance.AMplay(song.url)
                    } else {
                        AudioManager.instance.AMstop()
                    }
                } label: {
                    Image(systemName: isPlaying ? "stop.circle.fill" : "play.circle.fill")
                        .font(.system(size: 50, weight: .medium))
                        .foregroundColor(.customGray)
                }
                
                Button {
                    //다음곡 재생 기능
                } label: {
                    Image(systemName: "forward.end.fill")
                        .font(.system(size: 30, weight: .regular))
                        .foregroundColor(.customGray)
                }
            }
            .padding(.bottom, 54)
            
        }
        .frame(maxWidth: .infinity)
        .background(Color.HalmacSub)
        .onDisappear(){
            AudioManager.instance.AMstop()
        }
        .onAppear(){
            AudioManager.instance.AMplay(song.url)
        }
        .onReceive(timer) { _ in
            guard let player = AudioManager.instance.player else { return }
            guard let item = AudioManager.instance.player?.currentItem else { return }
            if CMTimeGetSeconds(player.currentTime()) == item.duration.seconds {
                isPlaying = false
            }
            //              value = CMTimeGetSeconds(player.currentTime())
        }
    }
}
