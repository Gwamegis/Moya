//
//  MiniPlayerView.swift
//  Halmap
//
//  Created by Kyubo Shim on 11/19/23.
//

import SwiftUI

struct MiniPlayerView: View {
    
    @EnvironmentObject var miniPlayerViewModel: MiniPlayerViewModel
    @ObservedObject var viewModel: SongDetailViewModel
    @FetchRequest(
        entity: CollectedSong.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.order, ascending: false)],
        predicate: PlaylistFilter(filter: "defaultPlaylist").predicate,
        animation: .default) private var defaultPlaylistSongs: FetchedResults<CollectedSong>

    @State var isPlaylistView = false
    @State var currentIndex = 0

    var body: some View {
        
        VStack(spacing: 0){
            HStack(spacing: 11){
                if !miniPlayerViewModel.isMiniPlayerActivate {
                    Button(action: {
                        withAnimation{
                            miniPlayerViewModel.showPlayer = false
                            miniPlayerViewModel.hideTabBar = false
                            miniPlayerViewModel.isMiniPlayerActivate = true
                        }
                    }, label: {
                        Image(systemName: "chevron.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)
                            .foregroundColor(Color.white)
                        
                    })
                    
                }
                
                VStack(alignment: .leading){
                    Text("\(viewModel.song.title)")
                        .font(Font.Halmap.CustomBodyBold)
                        .foregroundColor(Color.white)
                    Text("\(viewModel.song.team)")
                        .font(Font.Halmap.CustomCaptionMedium)
                        .foregroundColor(Color.customGray)
                }
                Spacer()
                
                if miniPlayerViewModel.isMiniPlayerActivate {
                    HStack{
                        Button(action: {
                            viewModel.handlePlayButtonTap()
                        }, label: {
                            Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 30, weight: .medium))
                                .foregroundStyle(Color.white)
                        })
                    }
                }
                
                if !miniPlayerViewModel.isMiniPlayerActivate {
                    FavoriteButton(viewModel: viewModel)
                }
            }
            .padding(.horizontal, 20)
            .frame(height: 60)
            
            GeometryReader{ reader in
                ZStack{
                    if isPlaylistView {
                        VStack {
                            PlaylistView(viewModel: PlaylistViewModel(viewModel: viewModel), song: $viewModel.song, isScrolled: $viewModel.isScrolled)
                                .padding(.top, 10)
                                .padding(.bottom, 150)
                        }
                    } else {
                        Lyric(viewModel: viewModel)
                    }
                    
                    VStack(spacing: 0) {
                        Spacer()
                        ZStack(alignment: .bottom) {
                            gradientRectangle(isTop: false)
                            playlistButton
                        }

                        PlayBar(viewModel: viewModel, currentIndex: $currentIndex)
                    }
                    .ignoresSafeArea()
                }
                .onAppear() {
                    viewModel.addDefaultPlaylist(defaultPlaylistSongs: defaultPlaylistSongs)
                    miniPlayerViewModel.height = reader.frame(in: .global).height + 250
                }
                .onChange(of: self.currentIndex) { _ in
                    self.viewModel.song = viewModel.convertSongToSongInfo(song: defaultPlaylistSongs[currentIndex])
                    self.viewModel.getAudioManager().AMset(song: self.viewModel.song)
                }

            }
            .background(Color("\(viewModel.song.team)Sub"))
            .opacity(miniPlayerViewModel.isMiniPlayerActivate ? 0 : getOpacity())
            .frame(height: miniPlayerViewModel.isMiniPlayerActivate ? 0 : nil)
        }
        .background(
            Color("\(viewModel.song.team)Sub")
                .cornerRadius(8)
                .ignoresSafeArea(.all, edges: .all)
                .onTapGesture {
                    withAnimation{
                        miniPlayerViewModel.width = UIScreen.main.bounds.width
                        miniPlayerViewModel.isMiniPlayerActivate.toggle()
                        miniPlayerViewModel.hideTabBar = true
                    }
                }
                
        )
        .onAppear {
            print("\(viewModel.song.title)")
        }
    }
    
    
    func getOpacity()->Double{
        
        let progress = miniPlayerViewModel.offset / (miniPlayerViewModel.height)
        if progress <= 1{
            return Double(1 - progress)
        }
        return 1
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
        // PlayListButton
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

    @ObservedObject var viewModel: SongDetailViewModel

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
    
    @ObservedObject var viewModel: SongDetailViewModel
    @FetchRequest(
        entity: CollectedSong.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.order, ascending: false)],
        predicate: PlaylistFilter(filter: "defaultPlaylist").predicate,
        animation: .default) private var defaultPlaylistSongs: FetchedResults<CollectedSong>
    @Binding var currentIndex: Int
    var body: some View {
        VStack(spacing: 0) {
            Progressbar(
                player: viewModel.getAudioManager().player,
                currentIndex: $currentIndex ,
                team: $viewModel.song.team,
                isThumbActive: true)
            HStack(spacing: 52) {
                Button {
                    //이전곡 재생 기능
                    if let index = defaultPlaylistSongs.firstIndex(where: {$0.id == viewModel.song.id}) {
                        if index - 1 < 0 {
                            currentIndex = defaultPlaylistSongs.count - 1
                        } else {
                            currentIndex = index - 1
                        }
                        print(currentIndex)
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
                            currentIndex = 0
                        } else {
                            currentIndex = index + 1
                        }
                        print(currentIndex)
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
