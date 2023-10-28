//
//  PlaylistView.swift
//  Halmap
//
//  Created by JeonJimin on 10/28/23.
//

import SwiftUI

struct PlaylistView: View {
    
    @EnvironmentObject var audioManager: AudioManager
    @AppStorage("selectedTeam") var selectedTeam = "Hanwha"
    @EnvironmentObject var dataManager: DataManager
    @Binding var song: SongInfo
    @Binding var isScrolled: Bool
    
    
    let persistence = PersistenceController.shared
    @FetchRequest(entity: CollectedSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.order, ascending: true)], predicate: PlayListFilter(filter: "defaultPlaylist").predicate, animation: .default) private var collectedSongs: FetchedResults<CollectedSong>

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
                        
                        PlaylistRow(songInfo: songInfo)
                            .onTapGesture {
                                self.song = song
                                audioManager.removePlayer()
                                audioManager.AMset(song: songInfo)
                            }
                    }.onDelete { indexSet in
                        persistence.deleteSong(at: indexSet, from: collectedSongs)
                    }.onMove { indexSet, destination  in
                        persistence.moveDefaultPlaylistSong(from: indexSet, to: destination, based: collectedSongs)
                    }
                    .listRowBackground(Color.clear)
                    Rectangle().foregroundStyle(Color.clear).frame(height: 50)
                }
                .listStyle(.plain)
                .modifier(ListBackgroundModifier())
            }
            
        }
        .background(Color("\(selectedTeam)Sub"))
        .background(GeometryReader{
            Color.clear.preference(
                key: ViewOffsetKey.self,
                value: -$0.frame(in: .named("scroll")).origin.y)
        })
        .onPreferenceChange(ViewOffsetKey.self) {
            if $0 > 0 {
                withAnimation {
                    isScrolled = true
                }
            } else {
                withAnimation {
                    isScrolled = false
                }
            }
        }
    }
    private struct ViewOffsetKey: PreferenceKey {
        static var defaultValue = CGFloat.zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value += nextValue()
        }
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

private struct PlaylistRow: View {
    
    @EnvironmentObject var dataManager: DataManager
    @State var songInfo: SongInfo
    
    var body: some View {
        HStack{
            Image(dataManager.checkSeasonSong(data: songInfo) ? "\(songInfo.team)23" : "\( songInfo.team)\(songInfo.type ? "Player" : "Album")")
                .resizable()
                .frame(width: 40, height: 40)
                .cornerRadius(8)
            VStack(alignment: .leading, spacing: 8) {
                Text(songInfo.title)
                    .font(Font.Halmap.CustomBodyMedium)
                    .foregroundStyle(Color.white)
                Text(TeamName(rawValue: songInfo.team)?.fetchTeamNameKr() ?? ".")
                    .font(Font.Halmap.CustomCaptionMedium)
                    .foregroundStyle(Color.customGray)
            }.padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
            Image(systemName: "text.justify")
                .frame(width: 18, height: 18)
                .foregroundStyle(Color.customGray)
        }
        .padding(.horizontal, 20) // 40 -> 20 값 조정
        .frame(height: 50) // 70 -> 50값 조정
    }
}

#Preview {
    PlaylistView(song: .constant(SongInfo(id: "",team: "NC", type: false, title: "test", lyrics: "test", info: "test", url: "test")), isScrolled: .constant(false))
}
