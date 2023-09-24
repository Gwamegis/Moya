//
//  SongSearchView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

struct SongSearchView: View {
    
    @StateObject var viewModel = SongSearchViewModel()
    @EnvironmentObject var dataManager: DataManager
    @GestureState private var dragOffset = CGSize.zero
    @FocusState private var isFocused: Bool

    var body: some View {

        VStack(spacing: 0) {

            navigationView
                .padding(.top, 10)

            Divider()
                .foregroundColor(.customGray)
                .padding(.top, 22)

            resultView

        }
        .frame(maxWidth: .infinity)
        .background(Color.systemBackground)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.setup(dataManager: dataManager)
        }
    }

    // MARK: Search Bar
    var searchBar: some View {
        HStack {
            TextField("\(Image(systemName: "magnifyingglass")) 검색", text: $viewModel.searchText)
                .accentColor(.black)
                .disableAutocorrection(true)
                .onChange(of: viewModel.searchText) { _ in
                    // TODO: 수정 필요
                    viewModel.didChangedSearchText()
                }
                .focused($isFocused)
                .background(Color.customGray)
                .task {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isFocused = true
//                    }
                }

            if !viewModel.searchText.isEmpty {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.medium)
                    .padding(3)
                    .foregroundColor(Color(.systemGray2))
                    .onTapGesture {
//                        DispatchQueue.main.async {
                            self.viewModel.searchText = ""
//                        }
                    }
            }
        }
        .frame(height: 40)
        .padding(.horizontal, 20)
        .background(Color.customGray)
        .cornerRadius(30)
    }


    // MARK: Result View
    var resultView: some View {

        VStack(spacing: 0) {
            if viewModel.isEmptySearchText() {
                VStack(spacing: 0) {
                    Image("searchInfo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.getHeight(200))
                        .padding(.top, UIScreen.getHeight(60))

                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                if viewModel.isEmptySearchResultList() {
                    ZStack {
                        VStack(spacing: 0) {
                            Image("searchEmpty")
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.getHeight(200))
                                .padding(.top, UIScreen.getHeight(60))
                            Spacer()
                        }
                        VStack {
                            Spacer()
                            RequestSongView(buttonColor: Color.mainGreen)
                        }
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    
                    List {
                        ForEach(viewModel.autoComplete, id: \.id) { song in
                            NavigationLink {
                                SongDetailView(song: viewModel.convertSongInfoToSong(with: song), team: song.team)
                            } label: {
                                HStack {
                                    Image(viewModel.getAlbumImage(with: song))
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .cornerRadius(8)
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(song.title )
                                            .font(Font.Halmap.CustomBodyMedium)
                                            .foregroundColor(.black)
                                        Text("\(TeamName(rawValue: song.team)?.fetchTeamNameKr() ?? "두산 베어스")")
                                            .font(Font.Halmap.CustomCaptionMedium)
                                            .foregroundColor(.customDarkGray)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(1)
                                }
                                .font(Font.Halmap.CustomBodyMedium)
                                .foregroundColor(Color.black)
                                .frame(height: 45)
                            }
                            .listRowBackground(Color(UIColor.clear))
                            .listRowInsets((EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)))
                            .listRowSeparatorTint(Color.customGray)
                        }
                    }
                    .padding(.horizontal, 20)
                    .listStyle(.plain)
                    Spacer()
                }
            }
        }
        .background(Color.systemBackground)
    }

    var navigationView: some View {
        HStack(spacing: 17) {
            searchBar
            
            if isFocused {
                Button {
                    isFocused = false
                } label: {
                    Text("취소")
                }
                .foregroundColor(Color.customDarkGray)
            }
        }
        .padding(.horizontal, 20)
    }
}


// MARK: Previews
struct SongSearchView_Previews: PreviewProvider {
    static var previews: some View {
        SongSearchView()
    }
}
