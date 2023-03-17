//
//  SongDetailView.swift
//  Halmap
//
//  Created by 전지민 on 2023/03/08.
//

import SwiftUI
import AVFoundation

struct SongDetailView: View {
    @EnvironmentObject var dataManager: DataManager
    
    @State var isTeam: Bool
    @State var index: Int
    @State var song: Song
    
    var body: some View {
        ZStack {
            Color.HalmacSub
                .ignoresSafeArea()
            
            SongContentView(song: $song)
            
            VStack(spacing: 0) {
                Rectangle()
                    .frame(height: UIScreen.getHeight(108))
                    .foregroundColor(Color.HalmacSub)
                Rectangle()
                    .frame(height: 20)
                    .background(Color.fetchTopGradient())
                    .foregroundColor(Color(UIColor.clear))
                Spacer()
                Rectangle()
                    .frame(height: 40)
                    .background(Color.fetchBottomGradient())
                    .foregroundColor(Color(UIColor.clear))
                ZStack(alignment: .center) {
                    Rectangle()
                        .frame(height: UIScreen.getHeight(120))
                        .foregroundColor(Color.HalmacSub)
                    SongPlayerView(isTeam: $isTeam)
                }
            }
            .ignoresSafeArea()
        }
        .navigationTitle(song.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            dataManager.currentIndex = index
        }
        .onDisappear() {
            dataManager.stopSound()
        }
        .onChange(of: dataManager.currentIndex) { newValue in
            if isTeam {
                song = dataManager.teamSongs[newValue]
            } else {
                song = dataManager.playerSongs[newValue]
            }
        }
    }
}
