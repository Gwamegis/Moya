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
    @FocusState private var isFocused: Bool

    var body: some View {

        VStack(spacing: 0) {

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
            .padding(.top, getSafeArea().top + 10)
            
            Divider()
                .foregroundColor(.customGray)
                .padding(.top, 22)

            resultView

        }
        .background(Color.systemBackground)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
        .onAppear {
            UIApplication.shared.hideKeyboard()
            viewModel.setup(dataManager: dataManager)
            isFocused = true
        }
    }

    // MARK: Search Bar
    var searchBar: some View {
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
                        self.viewModel.searchText = ""
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
                        NavigationLink {
                            SongDetailView(song: viewModel.convertSongInfoToSong(with: song), team: song.team)
                        } label: {
                            HStack {
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
                        }
                        .listRowBackground(Color(UIColor.clear))
                        .listRowInsets((EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)))
                        .listRowSeparatorTint(Color.customGray)
                    }
                }
                .padding(.horizontal, 20)
                .listStyle(.plain)
            }
        }
    }
}


// MARK: Previews
struct SongSearchView_Previews: PreviewProvider {
    static var previews: some View {
        SongSearchView()
    }
}
