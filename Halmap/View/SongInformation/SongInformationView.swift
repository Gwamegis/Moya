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

            SongHeaderView(song: $song)
                .frame(width: UIScreen.main.bounds.width + 3,
                       height: 156)
                .background(Color("songGrey"))
            
            SongContentView(song: $song)
                .frame(width: UIScreen.main.bounds.width + 3)
                .background(.white)

            Spacer()
        }
        .ignoresSafeArea()
    }
}

