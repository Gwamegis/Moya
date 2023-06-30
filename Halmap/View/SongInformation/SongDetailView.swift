//
//  SongDetailView.swift
//  Halmap
//
//  Created by 전지민 on 2023/03/08.
//

import SwiftUI
import AVFoundation

struct SongDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @AppStorage("selectedTeam") var selectedTeam = "Hanwha"
    
    @State var song: SongInfo
    @State var team: String
    
    @State var isPlayListView = false
    @State var isScrolled = false
    
    @State var isFavorite = false
    @State var index = -1
    
    let persistence = PersistenceController.shared
    
    @FetchRequest(entity: CollectedSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.id, ascending: true)], animation: .default) private var favoriteSongs: FetchedResults<CollectedSong>
    
    var body: some View {
        ZStack {
            Color("\(team)Sub")
                .ignoresSafeArea()
            
            if isPlayListView {
                VStack{
                    Rectangle().foregroundColor(.clear).frame(height: 10)
                    PlayListView(song: $song)
                }
            } else {
                SongContentView(song: $song, team: $team, isScrolled: $isScrolled)
            }
            
            VStack(spacing: 0) {
                Rectangle()
                    .frame(height: UIScreen.getHeight(108))
                    .foregroundColor(Color("\(team)Sub"))
                if isScrolled {
                    Rectangle()
                        .frame(height: 120)
                        .background(Color.fetchTopGradient(color: Color("\(team)Sub")))
                        .foregroundColor(Color(UIColor.clear))
                }
                Spacer()
                
                ZStack{
                    Rectangle()
                        .frame(height: 120)
                        .background(Color.fetchBottomGradient(color: Color("\(team)Sub")))
                        .foregroundColor(Color(UIColor.clear))
                    
                    // PlayListButton
                    HStack(){
                        Spacer()
                        Button(action: {
                            isPlayListView.toggle()
                        }, label: {
                            ZStack {
                                Circle().foregroundColor(Color("\(team)Background")).frame(width: 43, height: 43)
                                Image(systemName: isPlayListView ? "quote.bubble.fill" : "list.bullet").foregroundColor(.white)
                                
                            }
                        })
                    }.padding(20)
                }
                
                ZStack(alignment: .center) {
                    Rectangle()
                        .frame(height: UIScreen.getHeight(120))
                        .foregroundColor(Color("\(team)Sub"))
                    SongPlayerView(song: $song, team: $team)
                }
            }
            .ignoresSafeArea()
        }
        .navigationTitle(song.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if isFavorite {
                        persistence.deleteSongs(song: findFavoriteSong())
                    } else {
                        let songInfo = SongInfo(id: song.id, team: team, type: song.type, title: song.title, lyrics: song.lyrics, info: song.info, url: song.url)
                        persistence.saveSongs(song: songInfo, playListTitle: "favorite", menuType: .cancelLiked, collectedSongs: favoriteSongs)
                    }
                    isFavorite.toggle()
                } label: {
                    if isFavorite {
                        Image(systemName: "heart.fill")
                            .foregroundColor(Color("\(team)Point"))
                    } else {
                        Image(systemName: "heart")
                            .foregroundColor(.white)
                    }
                    
                }

            }
        }
        .onAppear() {
            if let index = favoriteSongs.firstIndex(where: {$0.id == song.id}) {
                isFavorite = true
                self.index = index
            }
        }
    }
    
    func findFavoriteSong() -> CollectedSong {
        if let index = favoriteSongs.firstIndex(where: {song.id == $0.id}) {
            return favoriteSongs[index]
        } else {
            return CollectedSong()
        }
    }
}
