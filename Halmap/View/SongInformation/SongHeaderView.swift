//
//  SongHeaderView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

struct SongHeaderView: View {
    
    @Binding var music: Music
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            HStack{
                Text(music.teamName)
                    .foregroundColor(Color("songLabel"))
                    .bold()
                Spacer()
                Button(action: {
                    
                }, label: {
                    Image("Close")
                })
            }
            HStack{
                VStack(alignment: .leading, spacing: 10){
                    Text(music.songName)
                        .font(.title)
                        .bold()
                    Text(music.songInfo)
                }
                
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Image("play")
                })
            }
        }.padding([.trailing, .leading])
    }
}

struct SongHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        
        SongHeaderView(music: .constant(Music(teamName: "롯데", songName: "유정인", lyric: "과메기즈가 간다", songInfo: "안녕하세요")))
    }
}
