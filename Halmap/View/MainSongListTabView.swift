//
//  MainSongListTabView.swift
//  Halmap
//
//  Created by 전지민 on 2023/03/03.
//

import SwiftUI

struct MainSongListTabView: View {
    
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
        ZStack(alignment: .top) {
            VStack {
                Rectangle()
                    .frame(height:210)
                    .foregroundColor(Color.HalmacBackground)
                    .opacity(0.8)
                    .edgesIgnoringSafeArea(.all)
                TabView(selection: $index) {
                    List {
                        ForEach(dataManager.teamSongs) { song in
                            let music = Song(id: song.id,
                                             type: song.type,
                                             title: song.title,
                                             lyrics: song.lyrics,
                                             info: song.info,
                                             url: song.url)
                            
                            NavigationLink(destination: SongInformationView(song: music)) {
                                VStack {
                                    Text(song.title)
                                        .font(Font.Halmap.CustomBodyMedium)
                                }
                                .frame(height: 45)
                            }
                            .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        }
                    }
                    .padding(.horizontal, 20)
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
                                        .font(Font.Halmap.CustomBodyMedium)
                                }
                                .frame(height: 45)
                            }
                            .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                            
                        }
                    }
                    .padding(.horizontal, 20)
                    .listStyle(.plain)
                    .listRowSeparatorTint(Color.gray.opacity(0.2))
                    .tag(1)
                }
                .tabViewStyle(.page)
            }
            
            //상단 탭바
            TabBarView(currentTab: $index)
                .padding(.top, 15)
            
            //팀 배너 이미지
            Image("\(selectedTeam)MainBanner")
                .resizable()
                .frame(width: 350, height: 126.9)
                .cornerRadius(10)
                .padding(.top, 70)
        }
    }
}

struct MainSongListTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainSongListTabView()
    }
}
