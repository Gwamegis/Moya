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
            ZStack {
                SongHeaderView(song: $song)
                
                HStack{
                    Text(song.title)
                        .font(.title2)
                        .foregroundColor(.white)
                        .bold()
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(.leading, 43)
                .padding(.trailing, 20)
                .padding(.top, -20)
            }
            
            SongContentView(song: $song)
                .background(.white)

            Spacer()
        }
        .ignoresSafeArea()
        
    }
}

