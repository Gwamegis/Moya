//
//  SongDetailView.swift
//  Halmap
//
//  Created by 전지민 on 2023/03/08.
//

import SwiftUI
import AVFoundation

struct SongDetailView: View {
    
    @State var song: Song
    
    var body: some View {
        ZStack {
            Color.HalmacSub
                .ignoresSafeArea()
            
            SongContentView(song: $song)
            
            VStack(spacing: 0) {
                Rectangle()
                    .frame(height: 108)
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
                ZStack {
                    Rectangle()
                        .frame(height: 120)
                        .foregroundColor(Color.HalmacSub)
                    SongPlayerView(song: $song)
                }
            }
            .ignoresSafeArea()
        }
        .navigationTitle(song.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
