//
//  MainView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

struct MainView: View {
    @State var selectedTeam: String = (UserDefaults.standard.string(forKey: "selectedTeam") ?? "Hanwha")
    @ObservedObject var dataManager = DataManager()
    @State private var showingStadiumSheet: Bool = false
    @State private var showingTeamChaingView: Bool = false
    @State var index = 0

    // SongInformationView
    @State private var showingFullScreenCover = false
    
    init() {
        Color.setColor(selectedTeam)
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Image("\(selectedTeam)MainTop")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width + 3)
                    .ignoresSafeArea()
                
                TabView(selection: $index) {
                    List {
                        ForEach(dataManager.teamSongs) { song in
//                            let music = Music(songTitle: song.title, lyric: song.lyrics)
                            let music = Song(id: song.id,
                                             type: song.type,
                                             title: song.title,
                                             lyrics: song.lyrics,
                                             info: song.info,
                                             url: song.url)
                            
                            NavigationLink(destination: SongInformationView(song: music)) {
                                                            VStack {
                                                                Text(song.title)
                                                                    .font(Font.Halmap.CustomTitleMedium)
                                                            }
                                                            .padding(.horizontal, 20)
                                                            .frame(height: 45)
                                                        }
                                                        .listRowSeparator(.hidden)

                        }
                    }
                    
                    .listStyle(.plain)
                    .listRowSeparatorTint(Color.gray.opacity(0.2))
                    .tag(0)
                    
                    List {
                        ForEach(dataManager.playerSongs) { song in
                            
                            let music = Song(id: song.id,
                                             type: song.type,
                                             title: song.title,
                                             lyrics: song.lyrics,
                                             info: song.info,
                                             url: song.url)
                            
                            NavigationLink(destination: SongInformationView(song: music)) {
                                                            VStack {
                                                                Text(song.title)
                                                                    .font(Font.Halmap.CustomTitleMedium)
                                                            }
                                                            .padding(.horizontal, 20)
                                                            .frame(height: 45)
                                                        }
                                                        .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    .listRowSeparatorTint(Color.gray.opacity(0.2))
                    .tag(1)
                    
                }
                .padding(.top, 65)
                
                TabBarView(currentTab: $index)
                    .padding(.top, 28)
            }
            .navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItemGroup (placement: .navigationBarTrailing) {
                    Button {
                        self.showingTeamChaingView.toggle()
                    } label: {
                        Image(systemName: "square.grid.2x2.fill").foregroundColor(.white)
                    }
                    .sheet(isPresented: $showingTeamChaingView) {
                        TeamChangingView(changedTeam: $selectedTeam)
                            .onDisappear{
//                                dataManager.setList(teamName: selectedTeam)
                                dataManager.setSongList(team: selectedTeam)
                                Color.setColor(selectedTeam)
                            }
                    }

                    Button {
                        self.showingStadiumSheet.toggle()
                    } label: {
                        Image(systemName: "map.fill").foregroundColor(.white)
                    }
                    
                    NavigationLink(destination: SongSearchView()) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                    }
                    .sheet(isPresented: $showingStadiumSheet) {
                        StadiumListSheetView()
                    }
                }
            }
        }
        .accentColor(.white)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
