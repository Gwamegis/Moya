//
//  SongInformationView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

struct SongInformationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var music = Music(teamName: "", songName: "", lyric: "")
    @State var player: Player?
    @State var teamSong: TeamSong?
    
    var body: some View {
        VStack{
//            SongHeaderView(music: $music)
            songHeader
                .frame(width: UIScreen.main.bounds.width,
                       height: 156)
                .background(Color("songGrey"))
//            SongContentView(music: $music)
            songContent
                .frame(width: UIScreen.main.bounds.width)
                .background(.white)
            Spacer()
        }.ignoresSafeArea()
            .onAppear {
                if let player {
                    music = Music(teamName: "", songName: player.playerName, lyric: player.lyric)
                }
            }
//            .onAppear {
//                if let player {
//                    music = Music(teamName: "", songName: player.playerName, lyric: player.lyric, songInfo: player.songInfo)
//                }
//                if let teamSong {
//                    music = Music(teamName: "", songName: teamSong.songName, lyric: teamSong.lyric, songInfo: teamSong.songInfo)
//                }
//            }
    }
    
    var songHeader: some View {
        ZStack{
            Image("lotteBackground")
                .resizable()
            
            HStack(spacing: 20){
                VStack(alignment: .leading, spacing: 10){
                    Spacer()
                    // TODO: - System Style to Custom Style
                    Text(player?.playerName ?? teamSong?.songName ?? "nil")
                        .font(.caption)
                        .foregroundColor(Color("songLabel"))
                        .bold()
                    // TODO: - System Style to Custom Style
                    Text(music.songName)
                        .font(.title2)
                        .foregroundColor(.white)
                        .bold()
                }.padding(EdgeInsets(top: 0, leading: 20, bottom: 25, trailing: 20))
                
                Spacer()
                VStack(alignment: .trailing, spacing: 10){
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                            .foregroundColor(Color("sheetCloseButtonBlack"))
                    })
                    
                    Button(action: {
                        // TODO
                    }, label: {
                        ZStack{
                            Rectangle()
                                .foregroundColor(Color("LotteBackground"))
                                .cornerRadius(20)
                                .frame(width: 83, height: 44)
                            
                            Text("재생").foregroundColor(.white)
                                .bold()
                        }
                        
                    })
                }.padding(EdgeInsets(top: 0, leading: 20, bottom: 17, trailing: 17))
            }
        }
    }
    
    var songContent: some View {
        VStack(alignment: .leading, spacing: 20){
            Text("가사")
                .foregroundColor(Color("LotteBackground"))
                .font(.caption)
                .bold()
            Text(music.lyric)
                .foregroundColor(.black)
                .font(.body)
            Spacer()
        }.padding([.horizontal, .top])

    }
}

struct SongInformationView_Previews: PreviewProvider {
    static var previews: some View {
        SongInformationView(music: Music(teamName: "teamName", songName: "노래이름", lyric: "가사가사"))
    }
}
