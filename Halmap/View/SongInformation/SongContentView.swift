//
//  SongContentView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

struct SongContentView: View {
    
    @State var selectedTeam: String = (UserDefaults.standard.string(forKey: "changedTeam") ?? "Hanwha")
    @Binding var music: Music
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            Text(selectedTeam)
                .foregroundColor(.black)
            Text("가사")
                .foregroundColor(Color("\(selectedTeam)Background"))
                .font(.caption)
                .bold()
            HStack{
                VStack{
                    Text(music.lyric)
                        .foregroundColor(.black)
                        .font(.body)
                    Spacer()
                }
                Spacer()
            }
        }.padding([.horizontal, .top])
        
        
    }
}

struct SongContentView_Previews: PreviewProvider {
    static var previews: some View {
        SongContentView(music: .constant(Music(songTitle: "유정인", lyric: "과메기즈가 간다")))
    }
}
