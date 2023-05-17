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
    
    @State var song: Song
    @State var isScrolled = false
    
    @State var isFavorite = false
    @State var index = -1
    
    let persistence = PersistenceController.shared
    
    @FetchRequest(entity: FavoriteSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteSong.id, ascending: true)], animation: .default) private var favoriteSongs: FetchedResults<FavoriteSong>
    
    var body: some View {
        ZStack {
            Color.HalmacSub
                .ignoresSafeArea()
            
            SongContentView(song: $song, isScrolled: $isScrolled)
            
            VStack(spacing: 0) {
                Rectangle()
                    .frame(height: UIScreen.getHeight(108))
                    .foregroundColor(Color.HalmacSub)
                if isScrolled {
                    Rectangle()
                        .frame(height: 120)
                        .background(Color.fetchTopGradient())
                        .foregroundColor(Color(UIColor.clear))
                }
                Spacer()
                Rectangle()
                    .frame(height: 120)
                    .background(Color.fetchBottomGradient())
                    .foregroundColor(Color(UIColor.clear))
                ZStack(alignment: .center) {
                    Rectangle()
                        .frame(height: UIScreen.getHeight(120))
                        .foregroundColor(Color.HalmacSub)
                    SongPlayerView(song: $song)
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
                            .foregroundColor(.HalmacPoint)
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
    
    func findFavoriteSong() -> FavoriteSong {
        if let index = favoriteSongs.firstIndex(where: {song.id == $0.id}) {
            return favoriteSongs[index]
        } else {
            return FavoriteSong()
        }
    }
}
