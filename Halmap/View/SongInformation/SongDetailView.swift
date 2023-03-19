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
    @State var isScrolled = false
    
    var body: some View {
        ZStack {
            Color.HalmacSub
                .ignoresSafeArea()
            
            SongContentView(song: $song, isScrolled: $isScrolled)
            
            VStack(spacing: 0) {
                Rectangle()
                    .frame(height: UIScreen.getHeight(108))
                    .foregroundColor(Color.HalmacSub)
                if isScrolled {
                    Rectangle()
                        .frame(height: 120)
                        .background(Color.fetchTopGradient())
                        .foregroundColor(Color(UIColor.clear))
                }
                Spacer()
                Rectangle()
                    .frame(height: 40)
                    .background(Color.fetchBottomGradient())
                    .foregroundColor(Color(UIColor.clear))
                ZStack(alignment: .center) {
                    Rectangle()
                        .frame(height: UIScreen.getHeight(120))
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
