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
    @State var teamName: String?
    
    @State var song: Song
    @State var isScrolled = false
    
    @State var isFavorite = false
    @State var index = -1
    
    let persistence = PersistenceController.shared
    
    @FetchRequest(entity: CollectedSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.id, ascending: true)], animation: .default) private var favoriteSongs: FetchedResults<CollectedSong>
    
    var body: some View {
        ZStack {
            Color("\(teamName ?? selectedTeam)Sub")
                .ignoresSafeArea()
            
            SongContentView(song: $song, isScrolled: $isScrolled)
            
            VStack(spacing: 0) {
                Rectangle()
                    .frame(height: UIScreen.getHeight(108))
                .foregroundColor(Color("\(teamName ?? selectedTeam)Sub"))
                if isScrolled {
                    Rectangle()
                        .frame(height: 120)
                        .background(Color.fetchTopGradient(color: Color("\(teamName ?? selectedTeam)Sub")))
                        .foregroundColor(Color(UIColor.clear))
                }
                Spacer()
                Rectangle()
                    .frame(height: 120)
                    .background(Color.fetchBottomGradient(color: Color("\(teamName ?? selectedTeam)Sub")))
                    .foregroundColor(Color(UIColor.clear))
                ZStack(alignment: .center) {
                    Rectangle()
                        .frame(height: UIScreen.getHeight(120))
                    .foregroundColor(Color("\(teamName ?? selectedTeam)Sub"))
                    SongPlayerView(teamName: $teamName, song: $song)
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
                        persistence.saveSongs(song: song)
                    }
                    isFavorite.toggle()
                } label: {
                    if isFavorite {
                        Image(systemName: "heart.fill")
                        .foregroundColor(Color("\(teamName ?? selectedTeam)Point"))
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
