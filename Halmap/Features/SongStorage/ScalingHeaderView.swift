//
//  ScalingHeaderView.swift
//  Halmap
//
//  Created by 전지민 on 2023/04/13.
//

import SwiftUI

struct ScalingHeaderView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var audioManager: AudioManager
    let persistence = PersistenceController.shared
    
    @FetchRequest(entity: CollectedSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.date, ascending: true)], predicate: PlaylistFilter(filter: "favorite").predicate, animation: .default) private var collectedSongs: FetchedResults<CollectedSong>
    
    @StateObject var viewModel: SongStorageViewModel
    @State var collectedSongData: CollectedSong?
    @State var isShowSheet = false
    
    @AppStorage("currentSongId") var currentSongId: String = ""
    
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
                            if collectedSongs.count > 0 {
                                Button {
                                    persistence.fetchPlaylistAll()
                                    currentSongId = collectedSongs.first!.safeId
                                } label: {
                                    HStack(spacing: 5) {
                                        Image(systemName: "play.circle.fill")
                                            .foregroundColor(.mainGreen)
                                            .font(.system(size: 20))
                                        Text("전체 재생하기")
                                            .font(Font.Halmap.CustomCaptionBold)
                                            .foregroundColor(.mainGreen)
                                    }
                                    .opacity(viewModel.checkScrollRequirement(listCount: collectedSongs.count))
                                }
                            }
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
                                NavigationLink {
                                    SongDetailView(
                                        viewModel: SongDetailViewModel(
                                            audioManager: audioManager,
                                            dataManager: dataManager,
                                            persistence: persistence,
                                            song: song
                                        ))
                                } label: {
                                    HStack(spacing: 16) {
                                        Image(viewModel.fetchSongImageName(favoriteSong: favoriteSong))
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .cornerRadius(8)
                                        VStack(alignment: .leading, spacing: 6) {
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
                                            self.collectedSongData = favoriteSong
                                            isShowSheet.toggle()
                                        } label: {
                                            Image(systemName: "ellipsis")
                                                .foregroundColor(.customDarkGray)
                                                .frame(maxWidth: 35, maxHeight: .infinity)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 15)
                                }
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
        .sheet(isPresented: $isShowSheet) {
            if let collectedSongData {
                HalfSheet {
                    HalfSheetView(collectedSongData: collectedSongData, showSheet: $isShowSheet)
                }
            }
        }
    }
    
    var defaultHeader: some View {
        ZStack(alignment: .bottom) {
            Image("storageTop")
                .resizable()
            HStack {
                Text("보관함")
                    .font(Font.Halmap.CustomLargeTitle)
                Spacer()
                if collectedSongs.count > 0 {
                    Button {
                        //TODO: 첫번째 곡 재생 -> SongDetailView song
                        persistence.fetchPlaylistAll()
                        self.currentSongId = collectedSongs.first!.safeId
                    } label: {
                        Image(systemName: "play.circle.fill")
                            .foregroundColor(.mainGreen)
                            .font(.system(size: 50))
                    }
                }
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

struct ScalingHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        StorageContentView()
    }
}
