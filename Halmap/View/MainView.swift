//
//  MainView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var dataManager = DataManager()
    @State private var showingStadiumSheet: Bool = false
    @State var index = 0

    // SongInformationView
    @State private var showingFullScreenCover = false

    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Image("LotteMainTop")
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                
                TabView(selection: $index) {
                    List {
                        ForEach(dataManager.playerList, id: \.self) { player in
                            
                            let music = Music(songName: player.playerName, lyric: player.lyric)
                            
                            NavigationLink(destination: SongInformationView(music: music)) {
                                Text(player.playerName)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .listRowSeparatorTint(Color.gray.opacity(0.2))
                    .tag(0)
                    
                    
                    List {
                        ForEach(dataManager.teamSongList, id: \.self) { team in
                            let music = Music(songName: team.songName, lyric: team.lyric)
                            
                            NavigationLink(destination: SongInformationView(music: music)) {
                                Text(team.songName)
                            }

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
                ToolbarItemGroup (placement: .navigationBarLeading) {
                    Button {
                        print("button click")
                    } label: {
                        Image(systemName: "square.grid.2x2.fill").foregroundColor(.white)
                    }
                    .padding(.leading, 160)

                }
                
                ToolbarItemGroup (placement: .navigationBarTrailing) {
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
