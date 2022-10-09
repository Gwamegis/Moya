//
//  SongContentView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

struct SongContentView: View {
    
    @Binding var music: Music
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            Text("가사")
                .foregroundColor(Color("songLabel"))
                .bold()
            Text(music.lyric)
                .foregroundColor(Color.white)
                .font(.body)
            Spacer()
        }.padding([.horizontal, .top])
        
        
    }
}

struct SongContentView_Previews: PreviewProvider {
    static var previews: some View {
        SongContentView(music: .constant(Music(teamName: "롯데", songName: "유정인", lyric: "과메기즈가 간다", songInfo: "안녕하세요")))
    }
}
