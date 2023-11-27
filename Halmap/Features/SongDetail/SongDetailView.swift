//
//  SongDetailView.swift
//  Halmap
//
//  Created by JeonJimin on 10/8/23.
//
import SwiftUI
import AVFoundation

struct SongDetailView: View {

    @StateObject var viewModel: SongDetailViewModel
    @FetchRequest(
        entity: CollectedSong.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.order, ascending: true)],
        predicate: PlaylistFilter(filter: "defaultPlaylist").predicate,
        animation: .default) private var defaultPlaylistSongs: FetchedResults<CollectedSong>

    @State var isPlaylistView = false

    var body: some View {
        ZStack {
            Color("\(viewModel.song.team)Sub")
                .ignoresSafeArea()

            if isPlaylistView {
                VStack {
                    PlaylistView(viewModel: PlaylistViewModel(viewModel: viewModel), song: $viewModel.song, isScrolled: $viewModel.isScrolled, currentIndex: $viewModel.currentIndex)
                        .padding(.top, 10)
                        .padding(.bottom, 150)
                }
            } else {
                Lyric(viewModel: viewModel)
            }

            VStack(spacing: 0) {
                Rectangle()
                    .frame(height: UIScreen.getHeight(108))
                    .foregroundColor(Color("\(viewModel.song.team)Sub"))
                gradientRectangle(isTop: true)
                Spacer()
                ZStack(alignment: .bottom) {
                    gradientRectangle(isTop: false)
                    playlistButton
                }

                PlayBar(viewModel: viewModel)
            }
            .ignoresSafeArea()
        }
        .navigationTitle(viewModel.song.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                FavoriteButton(viewModel: viewModel)
            }
        }
        .onAppear() {
            viewModel.addDefaultPlaylist(defaultPlaylistSongs: defaultPlaylistSongs)
        }
        .onChange(of: self.viewModel.currentIndex) { _ in
            self.viewModel.song = viewModel.convertSongToSongInfo(song: defaultPlaylistSongs[self.viewModel.currentIndex])
            self.viewModel.getAudioManager().AMset(song: self.viewModel.song)
        }
    }
    
    @ViewBuilder
    private func gradientRectangle(isTop: Bool) -> some View {
        Rectangle()
            .frame(height: 120)
            .foregroundColor(Color(UIColor.clear))
            .background(isTop ? (viewModel.isScrolled ? Color.fetchTopGradient(color: Color("\(viewModel.song.team)Sub")) : nil ) : Color.fetchBottomGradient(color: Color("\(viewModel.song.team)Sub")))
            .allowsHitTesting(false)
    }

    var playlistButton: some View {
        // PlaylistButton
        HStack(){
            Spacer()
            Button(action: {
                isPlaylistView.toggle()
            }, label: {
                ZStack {
                    Circle().foregroundColor(Color("\(viewModel.song.team)Background")).frame(width: 43, height: 43)
                    Image(systemName: isPlaylistView ? "quote.bubble.fill" : "list.bullet").foregroundColor(.white)

                }
            })
        }.padding(20)
    }
}

private struct Lyric: View {

    @StateObject var viewModel: SongDetailViewModel

    var body: some View {
        ScrollView(showsIndicators: true) {
            VStack {
                Text("\(viewModel.song.lyrics.replacingOccurrences(of: "\\n", with: "\n"))")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.Halmap.CustomHeadline)
                    .lineSpacing(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 40, leading: 40, bottom: 230, trailing: 40))
            }
            .background(GeometryReader{
                Color.clear.preference(
                    key: ViewOffsetKey.self,
                    value: -$0.frame(in: .named("scroll")).origin.y)
            })
            .onPreferenceChange(ViewOffsetKey.self) {
                if $0 > 0 {
                    withAnimation {
                        viewModel.isScrolled = true
                    }
                } else {
                    withAnimation {
                        viewModel.isScrolled = false
                    }
                }
            }
        }
        .coordinateSpace(name: "scroll")
    }
    private struct ViewOffsetKey: PreferenceKey {
        static var defaultValue = CGFloat.zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value += nextValue()
        }
    }
}

private struct PlayBar: View {

    @StateObject var viewModel: SongDetailViewModel
    @FetchRequest(
        entity: CollectedSong.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.order, ascending: true)],
        predicate: PlaylistFilter(filter: "defaultPlaylist").predicate,
        animation: .default) private var defaultPlaylistSongs: FetchedResults<CollectedSong>
    var body: some View {
        VStack(spacing: 0) {
            Progressbar(
                player: viewModel.getAudioManager().player, 
                currentIndex: $viewModel.currentIndex, 
                song: $viewModel.song,
                isThumbActive: true)
            HStack(spacing: 52) {
                Button {
                    //이전곡 재생 기능
                    if let index = defaultPlaylistSongs.firstIndex(where: {$0.id == viewModel.song.id}) {
                        if index - 1 < 0 {
                            viewModel.currentIndex = defaultPlaylistSongs.count - 1
                        } else {
                            viewModel.currentIndex = index - 1
                        }
                    }
                } label: {
                    Image(systemName: "backward.end.fill")
                        .font(.system(size: 28, weight: .regular))
                        .foregroundColor(.customGray)
                }
                    Button {
                        viewModel.handlePlayButtonTap()
                    } label: {
                        Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 60, weight: .medium))
                            .foregroundStyle(Color.customGray)
                    }
                Button {
                    //다음곡 재생 기능
                    if let index = defaultPlaylistSongs.firstIndex(where: {$0.id == viewModel.song.id}) {
                        if index + 1 > defaultPlaylistSongs.count - 1 {
                            print("재생목록이 처음으로 돌아갑니다.")
                            viewModel.currentIndex = 0
                        } else {
                            viewModel.currentIndex = index + 1
                        }
                    }
                } label: {
                    Image(systemName: "forward.end.fill")
                        .font(.system(size: 28, weight: .regular))
                        .foregroundColor(.customGray)
                }
            }
            .padding(.bottom, 54)
        }
        .padding(.horizontal, 45)
        .frame(maxWidth: .infinity)
        .background(Color("\(viewModel.song.team)Sub"))
        .onDisappear(){
            viewModel.removePlayer()
        }
        .onAppear(){
            viewModel.setPlayer()
        }
    }
}

private struct FavoriteButton: View {

    @StateObject var viewModel: SongDetailViewModel
    @FetchRequest(
        entity: CollectedSong.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.date, ascending: true)],
        predicate: PlaylistFilter(filter: "favorite").predicate,
        animation: .default) private var favoriteSongs: FetchedResults<CollectedSong>
    @AppStorage("currentSongId") var currentSongId: String = ""

    var body: some View {
        Button {
            viewModel.handleLikeButtonTap(deleteSong: findFavoriteSong())
        } label: {
            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                .foregroundStyle(viewModel.isFavorite ? Color("\(viewModel.song.team)Point") : Color.white)
        }
        .onAppear() {
            currentSongId = viewModel.song.id
            if favoriteSongs.contains(where: {$0.id == viewModel.song.id}) {
                viewModel.isFavorite = true
            }
        }
        .onChange(of: viewModel.song.id) { _ in
            currentSongId = viewModel.song.id
            if favoriteSongs.contains(where: {$0.id == viewModel.song.id}) {
                viewModel.isFavorite = true
            } else {
                viewModel.isFavorite = false
            }
        }
    }

    private func findFavoriteSong() -> CollectedSong {
        if let index = favoriteSongs.firstIndex(where: {$0.id == viewModel.song.id}) {
            return favoriteSongs[index]
        } else {
            return CollectedSong()
        }
    }
}
