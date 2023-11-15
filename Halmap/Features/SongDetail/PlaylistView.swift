//
//  PlaylistView.swift
//  Halmap
//
//  Created by JeonJimin on 11/14/23.
//
import SwiftUI

struct PlaylistView: View {

    @StateObject var viewModel: PlaylistViewModel
    @Binding var song: SongInfo
    @Binding var isScrolled: Bool

    let persistence = PersistenceController.shared
    @FetchRequest(entity: CollectedSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.order, ascending: true)], predicate: PlayListFilter(filter: "defaultPlaylist").predicate, animation: .default) private var collectedSongs: FetchedResults<CollectedSong>

    var body: some View {
        ZStack{
            if !collectedSongs.isEmpty {
                List {
                    ForEach(collectedSongs, id: \.self) { playListSong in
                        getPlayListRowView(song: playListSong)
                            .onTapGesture {
                                self.song = viewModel.didTappedSongCell(song: playListSong)
                            }
                    }.onDelete { indexSet in
                        persistence.deleteSong(at: indexSet, from: collectedSongs)
                    }.onMove { indexSet, destination  in
                        persistence.moveDefaultPlaylistSong(from: indexSet,
                                                            to: destination,
                                                            based: collectedSongs)
                    }
                    .listRowBackground(Color.clear)
                    Color.clear.frame(height:50)
                           .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .modifier(ListBackgroundModifier())
            }

        }
        .background(Color("\(song.team)Sub"))
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

    @ViewBuilder
    private func getPlayListRowView(song: CollectedSong) -> some View {
        HStack{
            Image(viewModel.getAlbumImage(with: song))
                .resizable()
                .frame(width: 40, height: 40)
                .cornerRadius(8)
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.getSongTitle(song: song))
                    .font(Font.Halmap.CustomBodyMedium)
                    .foregroundStyle(Color.white)
                Text(viewModel.getSongTitle(song: song))
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

    private struct ViewOffsetKey: PreferenceKey {
        static var defaultValue = CGFloat.zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value += nextValue()
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

//#Preview {
//    PlaylistView(song: .constant(SongInfo(id: "",team: "NC", type: false, title: "test", lyrics: "test", info: "test", url: "test")), isScrolled: .constant(false))
//}
