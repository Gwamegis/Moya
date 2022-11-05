//
//  SongInformationView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

struct SongInformationView: View {

    @State var music: Music
    
    var body: some View {
        VStack{
            SongHeaderView(music: $music)
                .frame(width: UIScreen.main.bounds.width,
                       height: 156)
                .background(Color("songGrey"))
            
            SongContentView(music: $music)
                .frame(width: UIScreen.main.bounds.width)
                .background(.white)
            Spacer()
            Spacer()

        }.ignoresSafeArea()
    }
}

