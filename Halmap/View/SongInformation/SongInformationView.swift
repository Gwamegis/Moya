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
            
//            songContent
            SongContentView(music: $music)
                .frame(width: UIScreen.main.bounds.width)
                .background(.white)
            Spacer()
        }.ignoresSafeArea()
    }
    
    var songHeader: some View {
        ZStack{
            Image("lotteBackground")
                .resizable()
            
            HStack(spacing: 20){
                VStack(alignment: .leading, spacing: 10){
                    Spacer()
                    // TODO: - System Style to Custom Style
                    Text(music.songName)
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
            Text(music.lyric)
                .foregroundColor(.black)
                .font(.body)
            Spacer()
        }.padding([.horizontal, .top])

    }
}

struct SongInformationView_Previews: PreviewProvider {
    static var previews: some View {
        SongInformationView(music: Music(songName: "노래이름", lyric: "가사가사"))
    }
}
