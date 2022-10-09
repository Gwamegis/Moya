//
//  SongInformationView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

struct SongInformationView: View {
    
    @State var selectedTeam: String = (UserDefaults.standard.string(forKey: "selectedTeam") ?? "Hanwha")
    @State var music: Music
    
    var body: some View {
        VStack{
            SongHeaderView(music: $music)
                .frame(width: UIScreen.main.bounds.width + 3,
                       height: 156)
                .background(Color("songGrey"))
            
            SongContentView(music: $music)
                .frame(width: UIScreen.main.bounds.width + 3)
                .background(.white)
            Spacer()
        }.ignoresSafeArea()
    }
}

struct SongInformationView_Previews: PreviewProvider {
    static var previews: some View {
        SongInformationView(music: Music(songTitle: "노래이름", lyric: "가사가사"))
    }
}
