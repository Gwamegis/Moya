//
//  ScalingHeaderView.swift
//  Halmap
//
//  Created by 전지민 on 2023/04/13.
//

import SwiftUI

struct ScalingHeaderView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var audioManager: AudioManager
    let persistence = PersistenceController.shared
    
    @FetchRequest(entity: CollectedSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.date, ascending: true)], predicate: PlaylistFilter(filter: "favorite").predicate, animation: .default) private var collectedSongs: FetchedResults<CollectedSong>
    
    @StateObject var viewModel: SongStorageViewModel
    @ObservedObject var miniPlayerViewModel: MiniPlayerViewModel
    @Binding var songInfo: SongInfo
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                GeometryReader { proxy in
                    VStack(spacing: 0) {
                        defaultHeader
                            .frame(maxWidth: .infinity)
                            .frame(height: viewModel.getHeaderHeight(), alignment: .bottom)
                            .overlay(
                                scrolledHeader
                                    .opacity(viewModel.calculateOpacity(listCount: collectedSongs.count, isDefaultHeader: false, screenHeight: UIScreen.screenHeight))
                            )
                        HStack() {
                            Text("총 \(collectedSongs.count)곡")
                                .font(Font.Halmap.CustomCaptionBold)
                                .foregroundColor(.customDarkGray)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, UIScreen.getHeight(17))
                        Divider()
                            .overlay(Color.customGray.opacity(0.6))
                            .padding(.horizontal, 20)
                    }
                    .background(Color.systemBackground)
                }
                .frame(height: viewModel.maxHeight + UIScreen.getHeight(48))
                .offset(y: -viewModel.offset)
                .zIndex(1)
                
                LazyVStack(spacing: 0) {
                    if collectedSongs.isEmpty {
                        Image("storageEmpty")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding(.top, 60)
                    } else {
                        ForEach(collectedSongs) { favoriteSong in
                            let song = viewModel.makeSong(favoriteSong: favoriteSong)
                            
                            VStack(spacing: 0) {
                                let songInfo = SongInfo(id: song.id,
                                                        team: song.team,
                                                        type: song.type,
                                                        title: song.title,
                                                        lyrics: song.lyrics,
                                                        info: song.info,
                                                        url: song.url)
                                Button(action: {
                                    SongDetailViewModel(audioManager: audioManager, dataManager: dataManager, persistence: persistence, song: self.songInfo).removePlayer()
                                    self.songInfo = songInfo
                                    SongDetailViewModel(audioManager: audioManager, dataManager: dataManager, persistence: persistence, song: self.songInfo).setPlayer()
                                    withAnimation{
                                        miniPlayerViewModel.showPlayer = true
                                        miniPlayerViewModel.hideTabBar = true
                                        miniPlayerViewModel.isMiniPlayerActivate = false
                                    }
                                }, label: {
                                    HStack(spacing: 16) {
                                        Image(viewModel.fetchSongImageName(favoriteSong: favoriteSong))
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .cornerRadius(8)
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(favoriteSong.safeTitle)
                                                .font(Font.Halmap.CustomBodyMedium)
                                                .foregroundColor(.black)
                                            Text(TeamName(rawValue: favoriteSong.safeTeam)?.fetchTeamNameKr() ?? ".")
                                                .font(Font.Halmap.CustomCaptionMedium)
                                                .foregroundColor(.customDarkGray)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .lineLimit(1)

                                        Button {
                                            viewModel.deleteSong(favoriteSong: favoriteSong)
                                        } label: {
                                            Image(systemName: "heart.fill")
                                                .foregroundColor(.mainGreen)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                })
//                                NavigationLink {
//                                    SongDetailView(
//                                        viewModel: SongDetailViewModel(
//                                            audioManager: audioManager,
//                                            dataManager: dataManager,
//                                            persistence: persistence,
//                                            song: song
//                                        ))
//                                } label: {
//                                    HStack(spacing: 16) {
//                                        Image(viewModel.fetchSongImageName(favoriteSong: favoriteSong))
//                                            .resizable()
//                                            .frame(width: 40, height: 40)
//                                            .cornerRadius(8)
//                                        VStack(alignment: .leading, spacing: 8) {
//                                            Text(favoriteSong.safeTitle)
//                                                .font(Font.Halmap.CustomBodyMedium)
//                                                .foregroundColor(.black)
//                                            Text(TeamName(rawValue: favoriteSong.safeTeam)?.fetchTeamNameKr() ?? ".")
//                                                .font(Font.Halmap.CustomCaptionMedium)
//                                                .foregroundColor(.customDarkGray)
//                                        }
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                        .lineLimit(1)
//                                        
//                                        Button {
//                                            viewModel.deleteSong(favoriteSong: favoriteSong)
//                                        } label: {
//                                            Image(systemName: "heart.fill")
//                                                .foregroundColor(.mainGreen)
//                                        }
//                                    }
//                                    .padding(.horizontal, 20)
//                                    .padding(.vertical, 10)
//                                }
                            }
                            .background(Color.systemBackground)
                        }
                    }
                }
            }
            .modifier(OffsetModifier(offset: $viewModel.offset))
            .onChange(of: viewModel.offset) { _ in
                viewModel.handleOffsetChange(threshold: -UIScreen.getHeight(90))
            }
        }
        .coordinateSpace(name: "StorageScroll")
        .background(Color.systemBackground)
    }
    
    var defaultHeader: some View {
        ZStack(alignment: .bottom) {
            Image("storageTop")
                .resizable()
            HStack {
                Text("보관함")
                    .font(Font.Halmap.CustomLargeTitle)
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
        }
        .opacity(viewModel.calculateOpacity(listCount: collectedSongs.count, isDefaultHeader: true, screenHeight: UIScreen.screenHeight))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .background(Color.systemBackground)
    }
    
    var scrolledHeader: some View {
        VStack{
            HStack {
                Spacer()
                Text("보관함")
                    .font(Font.Halmap.CustomTitleBold)
                Spacer()
            }
            .padding(.top, 40)
            
        }
    }
}

//struct ScalingHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        StorageContentView()
//    }
//}
