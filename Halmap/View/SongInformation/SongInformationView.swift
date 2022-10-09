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
                       height: 170)
                .background(Color("songGrey"))
            SongContentView(music: $music)
                .frame(width: UIScreen.main.bounds.width)
                .background(Color("songContentBackground"))
            Spacer()
        }
    }
}

struct SongInformationView_Previews: PreviewProvider {
    static var previews: some View {
        SongInformationView(music: Music(teamName: "teamName", songName: "노래이름", lyric: "가사가사", songInfo: "노래정보"))
    }
}
