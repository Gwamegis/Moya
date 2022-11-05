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
                        ForEach(dataManager.teamSongList, id: \.self) { team in
                            let music = Music(songTitle: team.songTitle, lyric: team.lyric)
                            
                            NavigationLink(destination: SongInformationView(music: music)) {
                                                            VStack {
                                                                Text(team.songTitle)
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
                        ForEach(dataManager.playerList, id: \.self) { player in
                            
                            let music = Music(songTitle: player.playerName, lyric: player.lyric)
                            
                            NavigationLink(destination: SongInformationView(music: music)) {
                                                            VStack {
                                                                Text(music.songTitle)
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
                                dataManager.setList(teamName: selectedTeam)
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
