//
//  PlaylistView.swift
//  Halmap
//
//  Created by JeonJimin on 11/14/23.
//
import SwiftUI
import Lottie

struct PlaylistView: View {

    @AppStorage("currentSongId") var currentSongId: String = ""
    @StateObject var viewModel: PlaylistViewModel
    @Binding var song: SongInfo
    @Binding var isScrolled: Bool
    @Binding var currentIndex: Int
    @Binding var isPlaying: Bool

    let persistence = PersistenceController.shared
    @FetchRequest(entity: CollectedSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.order, ascending: true)], predicate: PlaylistFilter(filter: "defaultPlaylist").predicate, animation: .default) private var collectedSongs: FetchedResults<CollectedSong>

    var body: some View {
        ZStack{
            if !collectedSongs.isEmpty {
                List {
                    ForEach(collectedSongs, id: \.self) { playListSong in
                        getPlaylistRowView(song: playListSong)
                            .background(Color.white.opacity(0.001))
                            .onTapGesture {
                                self.song = viewModel.didTappedSongCell(song: playListSong)
                                self.currentIndex = Int(playListSong.order)
                            }
                    }.onDelete { indexSet in
                        for index in indexSet {
                            if collectedSongs.count - 1 == 0 {
                                // TODO: 메인화면으로 나가는 동작
                                print("메인화면으로")
                                viewModel.stopPlayer()
                            } else {
                                if let songIndex = collectedSongs.firstIndex(where: {$0.id == song.id}) {
                                    if collectedSongs[songIndex].order == index {
                                        if index + 1 < collectedSongs.count {
                                            currentIndex = Int(collectedSongs[songIndex].order)
                                        } else {
                                            currentIndex = 0
                                        }
                                    }
                                }
                            }
                        }
                        persistence.deleteSong(at: indexSet, from: collectedSongs)
                    }.onMove { indexSet, destination  in
                        persistence.moveDefaultPlaylistSong(from: indexSet,
                                                            to: destination,
                                                            based: collectedSongs)
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowBackground(Color("\(song.team)Sub"))
                    Color.clear.frame(height:70)
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
    private func getPlaylistRowView(song: CollectedSong) -> some View {
        HStack{
            if currentSongId == song.id {
                LottieView(animation: .named("waveform"))
                    .playing(loopMode: .loop)
                    .configure({ lottie in
                        if isPlaying {
                            lottie.loopMode = .loop
                            lottie.play()
                        } else {
                            lottie.stop()
                        }
                    })
                    .foregroundStyle(Color(viewModel.getSongTeamBackgroundColor(with: song)))
                    .frame(width: 40, height: 40)
            } else {
                Image(viewModel.getAlbumImage(with: song))
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(8)
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.getSongTitle(song: song))
                    .font(Font.Halmap.CustomBodyMedium)
                    .foregroundStyle(Color.white)
                Text(viewModel.getTeamNameKr(song: song))
                    .font(Font.Halmap.CustomCaptionMedium)
                    .foregroundStyle(Color.customGray)
            }.padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
            Image(systemName: "text.justify")
                .frame(width: 18, height: 18)
                .foregroundStyle(Color.customGray)
        }
        .padding(.horizontal, 40)
        .frame(height: 70)
        .background(currentSongId == song.id ? Color.white.opacity(0.2) : Color.clear)
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