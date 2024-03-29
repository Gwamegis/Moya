//
//  MiniPlayerView.swift
//  Halmap
//
//  Created by Kyubo Shim on 12/12/23.
//

import SwiftUI
import AVFoundation
import MediaPlayer

struct MiniPlayerView: View {
    @EnvironmentObject var miniPlayerViewModel: MiniPlayerViewModel
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @FetchRequest(
        entity: CollectedSong.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.order, ascending: true)],
        predicate: PlaylistFilter(filter: "defaultPlaylist").predicate,
        animation: .default) private var defaultPlaylistSongs: FetchedResults<CollectedSong>
    @FetchRequest(
        entity: CollectedSong.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.date, ascending: true)],
        predicate: PlaylistFilter(filter: "favorite").predicate,
        animation: .default) private var favoriteSongs: FetchedResults<CollectedSong>
    
    @AppStorage("currentSongId") var currentSongId: String = ""
    @State var isPlaylistView = false
    @State private var toast: Toast? = nil
    @GestureState var gestureOffset: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0){
            VStack(spacing:0){
                if miniPlayerViewModel.isMiniPlayerActivate {
                    Spacer()
                }
                HStack(spacing: 16){
                    if !miniPlayerViewModel.isMiniPlayerActivate {
                        Button(action: {
                            withAnimation{
                                miniPlayerViewModel.hideTabBar = false
                                miniPlayerViewModel.isMiniPlayerActivate = true
                            }
                            Utility.analyticsPlayNextSongMini()
                        }, label: {
                            Image(systemName: "chevron.down")
                                .font(.system(size: 24))
                                .foregroundColor(Color.white)
                            
                        })
                    }
                    if !miniPlayerViewModel.isMiniPlayerActivate {
                        Image(miniPlayerViewModel.fetchImage())
                            .resizable()
                            .cornerRadius(10)
                            .frame(width: 52, height: 52)
                            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                    }
                    
                    if defaultPlaylistSongs.count > 0 {
                        VStack(alignment: .leading, spacing: 4){
                            Text("\(miniPlayerViewModel.song.title)")
                                .font(Font.Halmap.CustomBodyBold)
                                .foregroundColor(Color.systemBackground)
                            Text(miniPlayerViewModel.getTeamNameKr())
                                .font(Font.Halmap.CustomCaptionMedium)
                                .foregroundColor(Color.customGray)
                        }
                    } else {
                        Text("재생 중인 곡이 없습니다.")
                            .foregroundStyle(Color.systemBackground.opacity(0.6))
                            .font(.Halmap.CustomBodyBold)
                    }
                    
                    Spacer()
                    
                    if miniPlayerViewModel.isMiniPlayerActivate {
                        HStack(spacing: 21) {
                            Button(action: {
                                miniPlayerViewModel.handlePlayButtonTap()
                                Utility.analyticsPlayPauseSongMini()
                            }, label: {
                                Image(systemName: miniPlayerViewModel.isPlaying ? "pause.fill" : "play.fill")
                                    .font(.system(size: 20, weight: .medium))
                            })
                            Button(action: {
                                if let index = defaultPlaylistSongs.firstIndex(where: {$0.id == miniPlayerViewModel.song.id}) {
                                    if index + 1 > defaultPlaylistSongs.count - 1 {
                                        miniPlayerViewModel.song = Utility.convertSongToSongInfo(song: defaultPlaylistSongs.first!)
                                    } else {
                                        miniPlayerViewModel.song = Utility.convertSongToSongInfo(song: defaultPlaylistSongs[index + 1])
                                    }
                                }
                            }, label: {
                                Image(systemName: "forward.end.fill")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundStyle(defaultPlaylistSongs.count > 1 ? Color.systemBackground : Color.systemBackground.opacity(0.2))
                            })
                            .disabled(defaultPlaylistSongs.count <= 1)
                        }
                        .disabled(defaultPlaylistSongs.count == 0)
                        .foregroundStyle(defaultPlaylistSongs.count > 0 ? Color.systemBackground : Color.systemBackground.opacity(0.2))
                    }
                    
                    if !miniPlayerViewModel.isMiniPlayerActivate {
                        Button {
                            miniPlayerViewModel.handleLikeButtonTap(deleteSong: findFavoriteSong())
                        } label: {
                            Image(systemName: miniPlayerViewModel.isFavorite ? "heart.fill" : "heart")
                                .foregroundStyle(miniPlayerViewModel.isFavorite ? Color("\(miniPlayerViewModel.song.team)Point") : Color.white)
                        }
                        .onAppear() {
                            if favoriteSongs.contains(where: {$0.id == miniPlayerViewModel.song.id}) {
                                miniPlayerViewModel.isFavorite = true
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                    MiniPlayerProgressBar(
                        song: $miniPlayerViewModel.song,
                        toast: $toast,
                        isThumbActive: true)
                    .opacity(miniPlayerViewModel.isMiniPlayerActivate ? 1 : 0)
                    .frame(height: miniPlayerViewModel.isMiniPlayerActivate ? 5 : 0)
                    .padding(.vertical, miniPlayerViewModel.isMiniPlayerActivate ? 8 : 0)
                
            }
            // .padding(.horizontal, 20)
            .frame(height: miniPlayerViewModel.isMiniPlayerActivate ? 65 : 80)
            .padding(.top, miniPlayerViewModel.isMiniPlayerActivate ? 0 : safeAreaInsets.top)
            .contentShape(Rectangle())
            .gesture(DragGesture().updating($gestureOffset, body: { (value, state, _) in
                state = value.translation.height
            })
                .onEnded(onEnd(value:)))
            .onChange(of: gestureOffset, perform: { value in
                onChanged()
            })
            .onTapGesture {
                if miniPlayerViewModel.isMiniPlayerActivate && defaultPlaylistSongs.count > 0 {
                    withAnimation{
                        miniPlayerViewModel.width = UIScreen.main.bounds.width
                        miniPlayerViewModel.isMiniPlayerActivate.toggle()
                        miniPlayerViewModel.hideTabBar = true
                    }
                }
            }
            
            GeometryReader{ reader in
                ZStack {
                    if isPlaylistView {
                        PlaylistView(
                            viewModel: PlaylistViewModel(viewModel: miniPlayerViewModel),
                            song: $miniPlayerViewModel.song,
                            isScrolled: $miniPlayerViewModel.isScrolled,
                            isPlaying: $miniPlayerViewModel.isPlaying,
                            toast: $toast)
                        .padding(.top, 10)
                        .padding(.bottom, 150)
                    } else {
                        Lyric(viewModel: miniPlayerViewModel)
                    }
                    
                    VStack(spacing: 0) {
                        gradientRectangle(isTop: true)
                        Spacer()
                        ZStack(alignment: .bottom) {
                            gradientRectangle(isTop: false)
                            playlistButton
                        }
                        .toastView(toast: $toast)
                        
                        PlayBar(viewModel: miniPlayerViewModel, toast: $toast)
                    }
                    .ignoresSafeArea()
                }
                .onChange(of: miniPlayerViewModel.song.id) { _ in
                    self.currentSongId = miniPlayerViewModel.song.id
                    if favoriteSongs.contains(where: {$0.id == miniPlayerViewModel.song.id}) {
                        miniPlayerViewModel.isFavorite = true
                    } else {
                        miniPlayerViewModel.isFavorite = false
                    }
                }
                .onChange(of: currentSongId) { _ in
                    if let index = defaultPlaylistSongs.firstIndex(where: { $0.id == miniPlayerViewModel.song.id }) {
                        self.miniPlayerViewModel.song = miniPlayerViewModel.convertSongToSongInfo(song: defaultPlaylistSongs[index])
                        self.miniPlayerViewModel.setPlayer()
                    }
                }
                .onAppear() {
                    setMediaPlayerNextTrack()
                }
                .onChange(of: defaultPlaylistSongs.count) { [oldValue = defaultPlaylistSongs.count] newValue in
                    if oldValue > newValue && newValue == 1 {
                        removeMediaPlayerNextTrack()
                    } else if oldValue < newValue && newValue == 2 {
                        setMediaPlayerNextTrack()
                    }
                    
                }
            }
            .background(Color("\(miniPlayerViewModel.song.team)Sub"))
            .ignoresSafeArea()
            .opacity(miniPlayerViewModel.isMiniPlayerActivate ? 0 : getOpacity())
            .frame(height: miniPlayerViewModel.isMiniPlayerActivate ? 0 : nil)
        }
        .background(
            Color("\(miniPlayerViewModel.song.team)Sub")
                .cornerRadius(8)
        )
        .onChange(of: miniPlayerViewModel.isMiniPlayerActivate) { newValue in
            if !newValue {
                Utility.analyticsScreenEvent(screenName: "응원가 재생하기", screenClass: "MiniPlayerView")
            }
        }
    }
    
    func onChanged(){
        if gestureOffset > 0 && !miniPlayerViewModel.isMiniPlayerActivate && miniPlayerViewModel.offset + 200 <= miniPlayerViewModel.height{
            miniPlayerViewModel.offset = gestureOffset
        }
    }
    
    
    func onEnd(value: DragGesture.Value){
        withAnimation(.smooth){
            
            if !miniPlayerViewModel.isMiniPlayerActivate{
                miniPlayerViewModel.offset = 0
                
                // Closing View...
                if value.translation.height > UIScreen.main.bounds.height / 3{
                    miniPlayerViewModel.hideTabBar = false
                    miniPlayerViewModel.isMiniPlayerActivate = true
                }
                else{
                    miniPlayerViewModel.hideTabBar = true
                    miniPlayerViewModel.isMiniPlayerActivate = false
                }
            }
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
            .background(isTop ? (miniPlayerViewModel.isScrolled ? Color.fetchTopGradient(color: Color("\(miniPlayerViewModel.song.team)Sub")) : nil ) : Color.fetchBottomGradient(color: Color("\(miniPlayerViewModel.song.team)Sub")))
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
                    Circle().foregroundColor(Color("\(miniPlayerViewModel.song.team)Background")).frame(width: 43, height: 43)
                    Image(systemName: isPlaylistView ? "quote.bubble.fill" : "list.bullet").foregroundColor(.white)
                    
                }
            })
        }.padding(20)
    }
    
    private func setMediaPlayerNextTrack() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.nextTrackCommand.addTarget { _ in
            if let index = defaultPlaylistSongs.firstIndex(where: {$0.id == miniPlayerViewModel.song.id}) {
                if index + 1 > defaultPlaylistSongs.count - 1 {
                    toast = Toast(team: defaultPlaylistSongs[0].safeTeam, message: "재생목록이 처음으로 돌아갑니다.")
                    miniPlayerViewModel.song = Utility.convertSongToSongInfo(song: defaultPlaylistSongs.first!)
                } else {
                    miniPlayerViewModel.song = Utility.convertSongToSongInfo(song: defaultPlaylistSongs[index + 1])
                }
            }
            return .success
        }
        commandCenter.previousTrackCommand.addTarget { _ in
            if let index = defaultPlaylistSongs.firstIndex(where: {$0.id == miniPlayerViewModel.song.id}) {
                if index - 1 < 0 {
                    miniPlayerViewModel.song = Utility.convertSongToSongInfo(song: defaultPlaylistSongs.last!)
                } else {
                    miniPlayerViewModel.song = Utility.convertSongToSongInfo(song: defaultPlaylistSongs[index - 1])
                }
            }
            return .success
        }
    }
    private func removeMediaPlayerNextTrack() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.nextTrackCommand.removeTarget(nil)
        commandCenter.previousTrackCommand.removeTarget(nil)
    }
    
    //좋아요 취소할때 CollectedSong형태로 반환
    private func findFavoriteSong() -> CollectedSong {
        if let index = favoriteSongs.firstIndex(where: {$0.id == miniPlayerViewModel.song.id}) {
            return favoriteSongs[index]
        } else {
            return CollectedSong()
        }
    }
}

private struct Lyric: View {
    
    @StateObject var viewModel: MiniPlayerViewModel
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            VStack {
                Text("\(viewModel.song.lyrics.replacingOccurrences(of: "\\n", with: "\n"))")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.Halmap.CustomHeadline)
                    .lineSpacing(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 40, leading: 40, bottom: 300, trailing: 40))
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
    
    @StateObject var viewModel: MiniPlayerViewModel
    @FetchRequest(
        entity: CollectedSong.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.order, ascending: true)],
        predicate: PlaylistFilter(filter: "defaultPlaylist").predicate,
        animation: .default) private var defaultPlaylistSongs: FetchedResults<CollectedSong>
    
    @Binding var toast: Toast?
    
    var body: some View {
        VStack(spacing: 0) {
            Progressbar(
                song: $viewModel.song,
                toast: $toast,
                isThumbActive: true)
            HStack(spacing: 52) {
                Button {
                    //이전곡 재생 기능
                    if let index = defaultPlaylistSongs.firstIndex(where: {$0.id == viewModel.song.id}) {
                        if index - 1 < 0 {
                            viewModel.song = Utility.convertSongToSongInfo(song: defaultPlaylistSongs.last!)
                        } else {
                            viewModel.song = Utility.convertSongToSongInfo(song: defaultPlaylistSongs[index - 1])
                        }
                    }
                } label: {
                    Image(systemName: "backward.end.fill")
                        .font(.system(size: 28, weight: .regular))
                        .foregroundColor(defaultPlaylistSongs.count > 1 ? .customGray : .customGray.opacity(0.4))
                }
                .disabled(defaultPlaylistSongs.count <= 1)
                
                Button {
                    viewModel.handlePlayButtonTap()
                } label: {
                    Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 60, weight: .medium))
                        .foregroundStyle(Color.customGray)
                }
                
                Button {
                    // - MARK: 다음곡 재생 기능
                    if let index = defaultPlaylistSongs.firstIndex(where: {$0.id == viewModel.song.id}) {
                        if index + 1 > defaultPlaylistSongs.count - 1 {
                            if defaultPlaylistSongs.count > 1 {
                                toast = Toast(team: defaultPlaylistSongs[0].safeTeam, message: "재생목록이 처음으로 돌아갑니다.")
                                viewModel.song = Utility.convertSongToSongInfo(song: defaultPlaylistSongs.first!)
                            }
                        } else {
                            viewModel.song = Utility.convertSongToSongInfo(song: defaultPlaylistSongs[index + 1])
                        }
                    }
                } label: {
                    Image(systemName: "forward.end.fill")
                        .font(.system(size: 28, weight: .regular))
                        .foregroundColor(defaultPlaylistSongs.count > 1 ? .customGray : .customGray.opacity(0.4))
                }
                .disabled( defaultPlaylistSongs.count <= 1)
            }
            .padding(.bottom, 54)
        }
        .padding(.horizontal, 40)
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
