//
//  MainSongListTabView.swift
//  Halmap
//
//  Created by 전지민 on 2023/03/03.
//

import SwiftUI

struct MainSongListTabView: View {
    
    @AppStorage("selectedTeam") var selectedTeam: String = "Hanwha"
    @AppStorage("currentSongId") var currentSongId: String = ""
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var audioManager: AudioManager
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var viewModel = MainSongListTabViewModel()
    @EnvironmentObject var miniPlayerViewModel: MiniPlayerViewModel
    
    @State private var isShowingHalfSheet: Bool = false
    @State private var selectedSong: SongInfo?
    @State var collectedSong: CollectedSong?
    
    @FetchRequest(
        entity: CollectedSong.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.order, ascending: true)],
        predicate: PlaylistFilter(filter: "defaultPlaylist").predicate,
        animation: .default) private var defaultPlaylistSongs: FetchedResults<CollectedSong>
    
    let persistence = PersistenceController.shared

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Rectangle()
                    .frame(height:UIScreen.getHeight(215))
                    .foregroundColor(Color.HalmacSub)
                
                HStack() {
                    Text("총 \(viewModel.index == 0 ? dataManager.teamSongs.count : dataManager.playerSongs.count)곡")
                        .font(Font.Halmap.CustomCaptionBold)
                        .foregroundColor(.customDarkGray)
                    Spacer()
                    Button {
                        let currentSongs = viewModel.index == 0 ? dataManager.teamSongs : dataManager.playerSongs
                        persistence.fetchPlaylistAllMain(newSongs: currentSongs)
                        miniPlayerViewModel.removePlayer()
                        self.miniPlayerViewModel.song = miniPlayerViewModel.convertSongToSongInfo(song: currentSongs[0])
                        miniPlayerViewModel.setPlayer()
                        withAnimation{
                            miniPlayerViewModel.showPlayer = true
                            miniPlayerViewModel.hideTabBar = true
                            miniPlayerViewModel.isMiniPlayerActivate = false
                        }
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "play.circle.fill")
                                .foregroundColor(.HalmacPoint)
                                .font(.system(size: 20))
                            Text("전체 재생하기")
                                .font(Font.Halmap.CustomCaptionBold)
                                .foregroundColor(.HalmacPoint)
                        }
                    }
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20))
                .padding(.top, UIScreen.getHeight(24))
                
                Divider()
                    .overlay(Color.customGray.opacity(0.6))
                    .padding(.horizontal, 20)
                
                TabView(selection: $viewModel.index) {
                    List {
                        ForEach(dataManager.teamSongs) { song in
                            let songInfo = SongInfo(id: song.id,
                                                    team: selectedTeam,
                                                    type: song.type,
                                                    title: song.title,
                                                    lyrics: song.lyrics,
                                                    info: song.info,
                                                    url: song.url)
                            
                            HStack(spacing: 16) {
                                Image(viewModel.getSongImage(for: songInfo))
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(8)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(song.title)
                                        .font(Font.Halmap.CustomBodyMedium)
                                    
                                    if !song.info.isEmpty {
                                        Text(song.info)
                                            .font(Font.Halmap.CustomCaptionMedium)
                                            .foregroundColor(.customDarkGray)
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                .lineLimit(1)
                                Spacer()

                                Image(systemName: "ellipsis")
                                    .foregroundColor(.customDarkGray)
                                    .frame(maxWidth: 35, maxHeight: .infinity)
                                    .background(Color.white.opacity(0.001))
                                    .onTapGesture {
                                        collectedSong = persistence.createCollectedSong(song: songInfo, playListTitle: "bufferPlayList")
                                        selectedSong = songInfo
                                        isShowingHalfSheet.toggle()
                                    }
                            }
                            .listRowInsets(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                            .listRowBackground(Color.systemBackground)
                            .listRowSeparatorTint(Color.customGray)
                            .background(Color.systemBackground)
                            .onTapGesture {
                                self.miniPlayerViewModel.song = songInfo
                                withAnimation{
                                    miniPlayerViewModel.showPlayer = true
                                    miniPlayerViewModel.hideTabBar = true
                                    miniPlayerViewModel.isMiniPlayerActivate = false
                                    selectedSong = songInfo
                                }
                                miniPlayerViewModel.addDefaultPlaylist(defaultPlaylistSongs: defaultPlaylistSongs)
                            }
                        }
                        RequestSongView(buttonColor: Color.HalmacPoint)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowBackground(Color.systemBackground)
                            .listRowSeparatorTint(Color.customGray)
                            .padding(.bottom, 80)
                    }
                    .sheet(isPresented: Binding(
                        get: { isShowingHalfSheet },
                        set: { isShowingHalfSheet = $0 }
                    )) {
                        if let collectedSong {
                            HalfSheet{
                                HalfSheetView(collectedSongData: collectedSong, showSheet: $isShowingHalfSheet)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .listStyle(.plain)
                    .tag(0)
                    
                    List {
                        ForEach(dataManager.playerSongs) { song in
                            let songInfo = SongInfo(id: song.id,
                                                    team: selectedTeam,
                                                    type: song.type,
                                                    title: song.title,
                                                    lyrics: song.lyrics,
                                                    info: song.info,
                                                    url: song.url)
                            
                            HStack(spacing: 16) {
                                Image(viewModel.getPlayerImage(for: songInfo))
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(8)
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(song.title)
                                        .font(Font.Halmap.CustomBodyMedium)
                                    if !song.info.isEmpty {
                                        Text(song.info)
                                            .font(Font.Halmap.CustomCaptionMedium)
                                            .foregroundColor(.customDarkGray)
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                .background(Color.white.opacity(0.0001))
                                .lineLimit(1)
                                Spacer()

                                Image(systemName: "ellipsis")
                                    .foregroundColor(.customDarkGray)
                                    .frame(maxWidth: 35, maxHeight: .infinity)
                                    .background(Color.white.opacity(0.001))
                                    .onTapGesture {
                                        collectedSong = persistence.createCollectedSong(song: songInfo, playListTitle: "bufferPlayList")
                                        selectedSong = songInfo
                                        isShowingHalfSheet.toggle()
                                    }
                            }
                            .onTapGesture {
                                miniPlayerViewModel.removePlayer()
                                self.miniPlayerViewModel.song = songInfo
                                miniPlayerViewModel.setPlayer()
                                withAnimation{
                                    miniPlayerViewModel.showPlayer = true
                                    miniPlayerViewModel.hideTabBar = true
                                    miniPlayerViewModel.isMiniPlayerActivate = false
                                    selectedSong = songInfo
                                }
                                miniPlayerViewModel.addDefaultPlaylist(defaultPlaylistSongs: defaultPlaylistSongs)
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                        .listRowBackground(Color.systemBackground)
                        .listRowSeparatorTint(Color.customGray)
                        
                        RequestSongView(buttonColor: Color.HalmacPoint)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowBackground(Color.systemBackground)
                            .listRowSeparatorTint(Color.customGray)
                            .padding(.bottom, 80)
                    }
                    .padding(.horizontal, 20)
                    .listStyle(.plain)
                    .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .edgesIgnoringSafeArea(.top)
            
            //상단 탭바
            TabBarView(currentTab: $viewModel.index)
                .padding(.top, 15)
            
            //팀 배너 이미지
            Button(action: viewModel.toggleTeamChangingView) {
                ZStack(alignment: .bottomLeading) {
                    Image("\(selectedTeam)MainBanner")
                        .resizable()
                        .frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(126.9))
                        .cornerRadius(10)
                    Text("팀 바꾸기")
                        .font(Font.Halmap.CustomCaptionMedium)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .overlay(RoundedRectangle(cornerRadius: 12.5).stroke(Color.white.opacity(0.4), lineWidth: 1))
                        .foregroundColor(Color.white.opacity(0.6))
                        .padding([.leading, .bottom], 20)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12.5)
                    .fill(Color.HalmacSub)
            )
            .padding(.top, 70)
        }
        .background(Color.systemBackground)
        .sheet(isPresented: $viewModel.showingTeamChangingView) {
            TeamSelectionView(viewModel: TeamSelectionViewModel(dataManager: dataManager), isShowing: $viewModel.showingTeamChangingView)
        }
        .navigationBarHidden(true)
        .onAppear() {
            Utility.analyticsScreenEvent(screenName: "팀 응원가 / 선수 응원가", screenClass: "MainSongListTabView")
        }
    }
}

struct MainSongListTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainSongListTabView()
    }
}
