//
//  PlayListView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2023/06/24.
//

import SwiftUI


struct PlayListRow: View {
    @EnvironmentObject var dataManager: DataManager
    @State var songInfo: SongInfo
    
    var body: some View {
        HStack{
            Image(dataManager.checkSeasonSong(data: songInfo) ? "\(songInfo.team ?? "")23" : "\( songInfo.team ?? "NC")\(songInfo.type ? "Player" : "Album")")
                .resizable()
                .frame(width: 40, height: 40)
                .cornerRadius(8)
            VStack(alignment: .leading, spacing: 8) {
                Text(songInfo.title ?? "test ")
                    .font(Font.Halmap.CustomBodyMedium)
                    .foregroundColor(.white)
                Text(TeamName(rawValue: songInfo.team ?? "NC")?.fetchTeamNameKr() ?? ".")
                    .font(Font.Halmap.CustomCaptionMedium)
                    .foregroundColor(.customDarkGray)
            }.padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(1)
            Image(systemName: "text.justify")
                .frame(width: 18, height: 18)
                .foregroundStyle(.gray)
        }
        .padding(.horizontal, 20) // 40 -> 20 값 조정
        .frame(height: 50) // 70 -> 50값 조정
    }
}

struct PlayListView: View {
    
    @AppStorage("selectedTeam") var selectedTeam = "Hanwha"
    @EnvironmentObject var dataManager: DataManager
    @State var song: Song
    
    
    let persistence = PersistenceController.shared
    @FetchRequest(entity: CollectedSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.date, ascending: true)], predicate: PlayListFilter(filter: "defaultPlayList").predicate, animation: .default) private var collectedSongs: FetchedResults<CollectedSong>
    
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
                            
                            
                            PlayListRow(songInfo: songInfo)
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

//    func delete(at offsets: IndexSet) {
//        withAnimation {
//            persistence.deleteSongs(song: findPlayListSong(at: offsets))
//            playListSongs.nsSortDescriptors.remove(atOffsets: offsets)
//        }
//    }
    
//    func move(from source: IndexSet, to destination: Int) {
//
//        let reversedSource = source.sorted()
//
//        for index in reversedSource.reversed() {
//          users.insert(users.remove(at: index), at: destination)
////        }
//    }
    
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
