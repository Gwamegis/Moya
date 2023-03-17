//
//  SongHeaderView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI
import AVFoundation

struct SongPlayerView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State var selectedTeam: String = (UserDefaults.standard.string(forKey: "selectedTeam") ?? "test")
    
    @Binding var isTeam: Bool
    
    @State var sound: Data?
    @State var isPlaying: Bool = false
    
    var body: some View {
        VStack {
            HStack(spacing: 52) {
                Button {
                    dataManager.playNextSong(isTeam: isTeam, isForward: false)
                } label: {
                    Image(systemName: "backward.end.fill")
                        .font(.system(size: 30, weight: .regular))
                        .foregroundColor(.customGray)
                }

                Button {
                    isPlaying.toggle()
                    if isPlaying {
                        dataManager.playSoundURL(isTeam: isTeam)
                    } else {
                        dataManager.stopSound()
                    }
                } label: {
                    Image(systemName: isPlaying ? "stop.circle.fill" : "play.circle.fill")
                        .font(.system(size: 50, weight: .medium))
                        .foregroundColor(.customGray)
                }
                
                Button {
                    dataManager.playNextSong(isTeam: isTeam, isForward: true)
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
    }
}
