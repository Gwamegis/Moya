//
//  SongSearchView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

struct SongSearchView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var audioManager: AudioManager
    let persistence = PersistenceController.shared
    @EnvironmentObject var miniPlayerViewModel: MiniPlayerViewModel
    @StateObject var viewModel: SongSearchViewModel
    @FocusState private var isFocused: Bool
    
    @FetchRequest(
        entity: CollectedSong.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.order, ascending: true)],
        predicate: PlaylistFilter(filter: "defaultPlaylist").predicate,
        animation: .default) private var defaultPlaylistSongs: FetchedResults<CollectedSong>

    var body: some View {

        VStack(spacing: 0) {

            searchBar
            
            Divider()
                .foregroundColor(.customGray)
                .padding(.top, 22)

            resultView
                .padding(.bottom, miniPlayerViewModel.showPlayer ? 50 : 0)

        }
        .background(Color.systemBackground)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            isFocused = true
        }
        .onTapGesture {
            hideKeyboard()
        }
    }

    // MARK: Search Bar
    var searchBar: some View {
        HStack(spacing: 17) {
            HStack {
                TextField("\(Image(systemName: "magnifyingglass")) 검색", text: $viewModel.searchText)
                    .accentColor(.black)
                    .disableAutocorrection(true)
                    .focused($isFocused)
                    .background(Color.customGray)
                
                if !viewModel.isEmptySearchText() {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.medium)
                        .padding(3)
                        .foregroundColor(Color(.systemGray2))
                        .onTapGesture {
                            viewModel.didTappedClearButton()
                        }
                }
            }
            .frame(height: 40)
            .padding(.horizontal, 20)
            .background(Color.customGray)
            .cornerRadius(30)
            
            if isFocused {
                Button {
                    isFocused = false
                } label: {
                    Text("취소")
                }
                .foregroundColor(Color.customDarkGray)
            }
        }
        .padding(.top)
        .padding(.horizontal, 20)
    }
    
    // MARK: Result View
    var resultView: some View {

        VStack(spacing: 0) {
            switch viewModel.getSearchViewMode() {
            case .initial:
                VStack(spacing: 0) {
                    Image("searchInfo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.getHeight(200))
                        .padding(.top, UIScreen.getHeight(60))
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            case .request:
                VStack {
                    Image("searchEmpty")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.getHeight(200))
                        .padding(.top, UIScreen.getHeight(60))
                    Spacer()
                    RequestSongView(buttonColor: Color.mainGreen)
                }
            case .result:
                List {
                    ForEach(viewModel.autoComplete, id: \.id) { song in
                        let songInfo = SongInfo(id: song.id,
                                                team: song.team,
                                                type: song.type,
                                                title: song.title,
                                                lyrics: song.lyrics,
                                                info: song.info,
                                                url: song.url)

                        Button(action: {
                            miniPlayerViewModel.removePlayer()
                            self.miniPlayerViewModel.song = song
                            miniPlayerViewModel.setPlayer()
                            withAnimation{
                                miniPlayerViewModel.showPlayer = true
                                miniPlayerViewModel.hideTabBar = true
                                miniPlayerViewModel.isMiniPlayerActivate = false
                            }
                            miniPlayerViewModel.addDefaultPlaylist(defaultPlaylistSongs: defaultPlaylistSongs)
                        }, label: {
                            HStack(spacing: 16) {
                                Image(viewModel.getAlbumImage(with: song))
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(8)
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(song.title)
                                        .font(Font.Halmap.CustomBodyMedium)
                                        .foregroundColor(.black)
                                    Text(viewModel.getTeamName(with: song))
                                        .font(Font.Halmap.CustomCaptionMedium)
                                        .foregroundColor(.customDarkGray)
                                }
                                .frame(height: 45)
                                .lineLimit(1)
                            }
                        })
                        .listRowBackground(Color(UIColor.clear))
                        .listRowInsets((EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)))
                        .listRowSeparatorTint(Color.customGray)
                    }
                }
                .padding(.horizontal, 20)
                .listStyle(.plain)
                .gesture(
                   DragGesture().onChanged { value in
                      if value.translation.height < 0 {
                          hideKeyboard()
                      }
                   }
                )
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
