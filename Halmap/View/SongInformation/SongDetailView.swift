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
            
            VStack{
                SongContentView(song: $song)
                
                SongPlayerView(song: $song)
            }
            .padding(.top, 30)
            
            VStack {
                Spacer()
                Rectangle()
                    .frame(height: 120)
                    .background(Color.fetchGradient())
                    .foregroundColor(Color(UIColor.clear))
                    .padding(.bottom, 80)
            }
        }
        .navigationTitle(song.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
