//
//  PlayListView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2023/06/24.
//

import SwiftUI


struct PlayListRow: View {
//    @Environment(\.managedObjectContext) var managedObjectContext
//    let persistence = PersistenceController.shared
//    @ObservedObject var collectedSong: CollectedSong
    @State var songData: Song
//    @State var song: CollectedSong = CollectedSong()
//    var team: String
    
    var body: some View {
        
        Text("\(songData.title)")

    }
}

struct PlayListView: View {
    
    @AppStorage("selectedTeam") var selectedTeam = "Hanwha"
    @EnvironmentObject var dataManager: DataManager
    @State var song: Song
    
    
    let persistence = PersistenceController.shared
    @FetchRequest(entity: CollectedSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.date, ascending: true)], predicate: PlayListFilter(filter: "defaultPlayList").predicate, animation: .default) private var collectedSongs: FetchedResults<CollectedSong>
    @FetchRequest(entity: CollectedSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.id, ascending: true)], animation: .default) private var playListSongs: FetchedResults<CollectedSong>
    
    var body: some View {
            
            ZStack{
                
                if collectedSongs.count != 0 {
                    List {
                        ForEach(collectedSongs, id: \.self) { playListSong in
                            
                            let song = Song(
                                id: playListSong.id ?? "",
                                type: playListSong.type ,
                                title: playListSong.title ?? "" ,
                                lyrics: playListSong.lyrics ?? "",
                                info: playListSong.info ?? "",
                                url: playListSong.url ?? ""
                            )
                            
                            let songInfo = SongInfo(
                                id: playListSong.id ?? "",
                                team: playListSong.team ?? "",
                                type: playListSong.type ,
                                title: playListSong.title ?? "" ,
                                lyrics: playListSong.lyrics ?? "",
                                info: playListSong.info ?? "",
                                url: playListSong.url ?? ""
                            )
                            
                            
                            PlayListRow(songData: song)
                        }.onDelete { indexSet in
//                            persistence.deleteSongs(indexSet: indexSet)
                            persistence.deleteSongs(at: indexSet, from: collectedSongs)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .modifier(ListBackgroundModifier())
                }
                
            }.background(Color("\(selectedTeam)Sub"))
            
            
            //        .scrollContentBackground(.hidden)
            
        
    }

    func delete(at offsets: IndexSet) {
//        persistence.deleteSongs(song: collectedSongs)
        persistence.deleteSongs(song: findPlayListSong(at: offsets))
//        print(song)
        playListSongs.nsSortDescriptors.remove(atOffsets: offsets)
//        $playListSongs.remove(atOffsets: offsets)
    }
//
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
