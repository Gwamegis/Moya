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
    @State private var showingTeamChaingView: Bool = false
    @State var index = 0

    // SongInformationView
    @State private var showingFullScreenCover = false
    
    init() {
        Color.setColor(selectedTeam)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Rectangle()
                    .frame(height:UIScreen.getHeight(215))
                    .foregroundColor(Color.HalmacSub)
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
                            
                            NavigationLink(destination: SongDetailView(song: music)) {
                                VStack {
                                    Text(song.title)
                                        .font(Font.Halmap.CustomBodyMedium)
                                }
                                .frame(height: 45)
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        .listRowBackground(Color.systemBackground)
                        .listRowSeparatorTint(Color.customGray)
                    }
                    .padding(.horizontal, 20)
                    .listStyle(.plain)
                    .tag(0)
                    
                    List {
                        ForEach(dataManager.playerSongs) { song in
                            let music = Song(id: song.id,
                                             type: song.type,
                                             title: song.title,
                                             lyrics: song.lyrics,
                                             info: song.info,
                                             url: song.url)
                            
                            NavigationLink(destination: SongDetailView(song: music)) {
                                VStack {
                                    Text(song.title)
                                        .font(Font.Halmap.CustomBodyMedium)
                                }
                                .frame(height: 45)
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        .listRowBackground(Color.systemBackground)
                        .listRowSeparatorTint(Color.customGray)
                    }
                    .padding(.horizontal, 20)
                    .listStyle(.plain)
                    .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .padding(.top, -10)
            }
            
            //상단 탭바
            TabBarView(currentTab: $index)
                .padding(.top, 15)
            
            //팀 배너 이미지
            Button {
                showingTeamChaingView.toggle()
            } label: {
                ZStack(alignment: .bottomLeading) {
                    Image("\(selectedTeam)MainBanner")
                        .resizable()
                        .frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(126.9))
                        .cornerRadius(10)
                    Text("팀 바꾸기")
                        .font(Font.Halmap.CustomCaptionMedium)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .overlay(RoundedRectangle(cornerRadius: 12.5).stroke(Color.white.opacity(0.4), lineWidth: 1))
                        .foregroundColor(Color.white.opacity(0.6))
                        .padding([.leading, .bottom], 20)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12.5)
                    .fill(Color.HalmacSub)
            )
            .padding(.top, 70)
        }
        .background(Color.systemBackground)
        .sheet(isPresented: $showingTeamChaingView) {
            TeamChangingView(changedTeam: $selectedTeam)
                .onDisappear{
                    dataManager.setSongList(team: selectedTeam)
                    Color.setColor(selectedTeam)
                }
        }
        .navigationBarHidden(true)
    }
}

struct MainSongListTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainSongListTabView()
    }
}
