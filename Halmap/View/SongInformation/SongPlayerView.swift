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
    @AppStorage("selectedTeam") var selectedTeam = "Hanwha"
    @Binding var song: Song
    @Binding var team: String
    
    
    // Audio Properties
    let timer = Timer
        .publish(every: 0.3, on: .main, in: .common)
        .autoconnect()
    @State var value: Double = 0.0
    @State var isEditing: Bool = false
    @EnvironmentObject var audioManager: AudioManager
    @State var endTime: CMTime = CMTime(seconds: 6000, preferredTimescale: 1000000)
    
    
    // View Property
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            
            VStack(spacing: 5){
//                Slider(value: $value, in: 0...CMTimeGetSeconds(endTime)) { editing in
                //                    print("editing", editing)
                //                    isEditing = editing
                //                    if !editing {
                //                        player.status = value
                //                    }
                //                }
                //                .accentColor(.white)
                
                Progressbar(team: $team, isThumbActive: false)
                
            }
            
            // Buttons
            HStack(spacing: 52) {
//                Button {
//                    //이전곡 재생 기능
//                } label: {
//                    Image(systemName: "backward.end.fill")
//                        .font(.system(size: 28, weight: .regular))
//                        .foregroundColor(.customGray)
//                }

                Button {
                    if !audioManager.isPlaying {
                        audioManager.AMplay()
                    } else {
                        audioManager.AMstop()
                    }
                } label: {
                    Image(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 60, weight: .medium))
                        .foregroundColor(.customGray)
                }
                
//                Button {
//                    //다음곡 재생 기능
//                } label: {
//                    Image(systemName: "forward.end.fill")
//                        .font(.system(size: 28, weight: .regular))
//                        .foregroundColor(.customGray)
//                }
            }
            .padding(.bottom, 54)
            
        }
        .padding(.horizontal, 45)
        .frame(maxWidth: .infinity)
        .background(Color("\(team)Sub"))
        .onDisappear(){
            audioManager.removePlayer()
            audioManager.progressValue = 0
        }
        .onAppear(){
            audioManager.AMset(song: song, selectedTeam: team)
        }
    }
}
