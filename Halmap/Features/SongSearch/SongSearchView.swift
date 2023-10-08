//
//  SongSearchView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI
import Firebase

struct SongSearchView: View {
    
    @AppStorage("selectedTeam") var selectedTeam = "Hanwha"
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var audioManager: AudioManager
    
    let persistence = PersistenceController.shared
    
    @GestureState private var dragOffset = CGSize.zero
    @FocusState private var isFocused: Bool
    @State private var isKeyboardFocused = false
    
    @State private var searchText = ""
    @State private var autoComplete = [SongInfo]()
    
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
        .onAppear { UIApplication.shared.hideKeyboard() }
        .onChange(of: isFocused) { newValue in
            withAnimation {
                isKeyboardFocused = newValue
            }
            
        }
    }
    
    
    // MARK: Search Bar
    var searchBar: some View {
        HStack {
            TextField("\(Image(systemName: "magnifyingglass")) 검색", text: $searchText)
                .accentColor(.black)
                .disableAutocorrection(true)
                .onChange(of: searchText) { _ in
                    // TODO: 수정 필요
                    didChangedSearchText()
                }
                .focused($isFocused)
                .background(Color.customGray)
                .task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isFocused = true
                    }
                }
            
            if !searchText.isEmpty {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.medium)
                    .padding(3)
                    .foregroundColor(Color(.systemGray2))
                    .onTapGesture {
                        self.searchText = ""
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
            if searchText.isEmpty {
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
                
                if autoComplete.isEmpty {
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
                        ForEach(autoComplete.indices, id: \.self) { index in
                            NavigationLink(destination:
                                           SongDetailView(
                                            viewModel: SongDetailViewModel(
                                                audioManager: audioManager,
                                                dataManager: dataManager,
                                                persistence: persistence,
                                                song: autoComplete[index]))
                            ) {
                                HStack {
                                    Image(dataManager.checkSeasonSong(data: autoComplete[index]) ? "\(autoComplete[index].team)23" : (autoComplete[index].type ? "\(autoComplete[index].team)Player" : "\(autoComplete[index].team)Album"))
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .cornerRadius(8)
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(autoComplete[index].title )
                                            .font(Font.Halmap.CustomBodyMedium)
                                            .foregroundColor(.black)
                                        Text("\(TeamName(rawValue: autoComplete[index].team)?.fetchTeamNameKr() ?? "두산 베어스")")
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
            
            if isKeyboardFocused == true {
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
    
    private func didChangedSearchText() {
        
        autoComplete = []

        dataManager.teamLists.forEach { teamName in
            for data in dataManager.playerSongsAll[teamName.fetchTeamIndex()] {
                if data.title.lowercased().contains(searchText.lowercased()) {
                    let music = SongInfo(id: data.id,team: teamName.rawValue, type: data.type, title: data.title, lyrics: data.lyrics, info: data.info, url: data.url)
                    autoComplete.append(music)
                }
            }
            for data in dataManager.teamSongsAll[teamName.fetchTeamIndex()] {
                if data.title.lowercased().contains(searchText.lowercased()) {
                    let music = SongInfo(id: data.id,team: teamName.rawValue, type: data.type, title: data.title, lyrics: data.lyrics, info: data.info, url: data.url)
                    autoComplete.append(music)
                }
            }
        }
    }
    private func setSong(data: SongInfo) -> Song {
        Song(id: data.id, type: data.type, title: data.title, lyrics: data.lyrics, info: data.info, url: data.url)
    }
}


// MARK: Previews
struct SongSearchView_Previews: PreviewProvider {
    static var previews: some View {
        SongSearchView()
    }
}
