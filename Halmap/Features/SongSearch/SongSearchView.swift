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
    
    @StateObject var viewModel: SongSearchViewModel
    @ObservedObject var miniPlayerViewModel: MiniPlayerViewModel
    @FocusState private var isFocused: Bool
    @Binding var songInfo: SongInfo
    @Binding var miniplayerPadding: CGFloat

    var body: some View {

        VStack(spacing: 0) {

            searchBar
            
            Divider()
                .foregroundColor(.customGray)
                .padding(.top, 22)

            resultView

        }
        .background(Color.systemBackground)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            UIApplication.shared.hideKeyboard()
            isFocused = true
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
                            .listRowBackground(Color(UIColor.clear))
                            .listRowInsets((EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)))
                            .listRowSeparatorTint(Color.customGray)
                        })
//                        NavigationLink {
//                            SongDetailView(viewModel: SongDetailViewModel(
//                                audioManager: audioManager,
//                                dataManager: dataManager,
//                                persistence: persistence,
//                                song: song))
//                        } label: {
//                            HStack {
//                                Image(viewModel.getAlbumImage(with: song))
//                                    .resizable()
//                                    .frame(width: 40, height: 40)
//                                    .cornerRadius(8)
//                                VStack(alignment: .leading, spacing: 8) {
//                                    Text(song.title)
//                                        .font(Font.Halmap.CustomBodyMedium)
//                                        .foregroundColor(.black)
//                                    Text(viewModel.getTeamName(with: song))
//                                        .font(Font.Halmap.CustomCaptionMedium)
//                                        .foregroundColor(.customDarkGray)
//                                }
//                                .frame(height: 45)
//                                .lineLimit(1)
//                            }
//                        }
//                        .listRowBackground(Color(UIColor.clear))
//                        .listRowInsets((EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)))
//                        .listRowSeparatorTint(Color.customGray)
                    }
                }
                .padding(.horizontal, 20)
                .listStyle(.plain)
            }
        }
    }
}


// MARK: Previews
//struct SongSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SongSearchView(viewModel: SongSearchViewModel(dataManager: DataManager()))
//    }
//}
