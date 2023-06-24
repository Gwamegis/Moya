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
        
        Text("\(songData.title) Test")
//        Text("Test")
        
        /*
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Image("\(team)SongListImage")
                    .frame(width: 52, height: 52)
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                VStack(alignment: .leading, spacing: 6) {
                    Text(/*songData.title */ "Test" )
                        .font(Font.Halmap.CustomBodyBold)
                        .foregroundColor(.customBlack)
                    Text(TeamName(rawValue: team )?.fetchTeamNameKr() ?? ".")
                        .font(Font.Halmap.CustomCaptionMedium)
                        .foregroundColor(.customDarkGray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 20)
            .padding(.top, 27)
            .onAppear() {
//                print("****\(songData)")
            }
        }*/
    }
}

struct PlayListView: View {
    
    @AppStorage("selectedTeam") var selectedTeam = "Hanwha"
    @EnvironmentObject var dataManager: DataManager
    @State var song: Song
    
    
    let persistence = PersistenceController.shared
    @FetchRequest(entity: CollectedSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.date, ascending: true)], predicate: PlayListFilter(filter: "playList").predicate, animation: .default) private var collectedSongs: FetchedResults<CollectedSong>
    @FetchRequest(entity: CollectedSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.id, ascending: true)], animation: .default) private var playListSongs: FetchedResults<CollectedSong>
    

    
//    @ObservedObject var collectedSong: CollectedSong
//    @State var songData: Song
//    @State var song: CollectedSong = CollectedSong()
    
    var body: some View {
            
            ZStack{
                
                if collectedSongs.count != 0 {
                    List {
                        ForEach(collectedSongs) { song in
                            
                            let music = Song(id: song.id ?? "",
                                             type: song.type,
                                             title: song.title ?? "",
                                             lyrics: song.lyrics ?? "",
                                             info: song.info ?? "",
                                             url: song.url ?? "")
                            
                            let songInfo = SongInfo(id: song.id ?? "",
                                                    team: selectedTeam ?? "",
                                                    type: song.type,
                                                    title: song.title ?? "",
                                                    lyrics: song.lyrics ?? "",
                                                    info: song.info ?? "",
                                                    url: song.url ?? "")
                            
                            PlayListRow(songData: music)
                        }
                        .onDelete(perform: delete)
//                        .onDelete(perform: /*persistence.deleteSongs(song: */findPlayListSong/*(at: ))*/)
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
