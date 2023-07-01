//
//  PlayListView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2023/06/24.
//

import SwiftUI

struct PlayListView: View {
    
    
    @EnvironmentObject var audioManager: AudioManager
    @AppStorage("selectedTeam") var selectedTeam = "Hanwha"
    @EnvironmentObject var dataManager: DataManager
    @Binding var song: SongInfo
    
    let persistence = PersistenceController.shared
    @FetchRequest(entity: CollectedSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.order, ascending: true)], predicate: PlayListFilter(filter: "defaultPlayList").predicate, animation: .default) private var collectedSongs: FetchedResults<CollectedSong>
    
    @FetchRequest(entity: CollectedSong.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(keyPath: \CollectedSong.id, ascending: true)
                  ], animation: .default
    ) private var playListSongs: FetchedResults<CollectedSong>
    
    var body: some View {
            
            ZStack{
                if collectedSongs.count != 0 {
                    List {
                        ForEach(collectedSongs, id: \.self) { playListSong in
                            
                            let songInfo = SongInfo(
                                id: playListSong.id ?? "",
                                team: playListSong.team ?? "",
                                type: playListSong.type ,
                                title: playListSong.title ?? "" ,
                                lyrics: playListSong.lyrics ?? "",
                                info: playListSong.info ?? "",
                                url: playListSong.url ?? ""
                            )
                            
                            PlayListRow(songInfo: songInfo)
                                .onTapGesture {
                                self.song = songInfo
                                audioManager.removePlayer()
                                audioManager.AMset(song: songInfo, selectedTeam: selectedTeam)
                            }
                            
                            
                        }.onDelete { indexSet in
                            persistence.deleteSong(at: indexSet, from: collectedSongs)
                        }.onMove { indexSet, destination  in
                            persistence.moveDefaultPlayListSong(from: indexSet, to: destination, based: collectedSongs)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .modifier(ListBackgroundModifier())
                }
                
            }.background(Color("\(selectedTeam)Sub"))
    }

    func findPlayListSong(at offsets: IndexSet) -> CollectedSong {
        if let index = playListSongs.firstIndex(where: {song.id == $0.id}) {
            return playListSongs[index]
        } else {
            return CollectedSong()
        }
    }
}

struct ListBackgroundModifier: ViewModifier {

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}
