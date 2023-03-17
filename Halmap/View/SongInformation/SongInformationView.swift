//
//  SongInformationView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

struct SongInformationView: View {

    @State var song: Song
    
    var body: some View {

        VStack(alignment: .leading, spacing: 0) {
//            SongPlayerView(song: $song)
//            
//            SongContentView(song: $song)
//                .background(.white)

            Spacer()
        }
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text(song.title)
                    .font(Font.Halmap.CustomTitleBold)
                    .foregroundColor(.white)
                    .padding(.leading, -10)
            }
        }
        
    }
}

