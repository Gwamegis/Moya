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

        VStack(alignment: .leading) {
            ZStack{
                SongHeaderView(song: $song)
                    .frame(width: UIScreen.main.bounds.width + 3,
                           height: 156)
                
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
                .frame(width: UIScreen.main.bounds.width + 3)
                .background(.white)

            Spacer()
        }
        .ignoresSafeArea()
        
    }
}

