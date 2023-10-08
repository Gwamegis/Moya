//
//  MainSongListTabView.swift
//  Halmap
//
//  Created by 전지민 on 2023/03/03.
//

import SwiftUI

struct MainSongListTabView: View {
    
    @AppStorage("selectedTeam") var selectedTeam = "Hanwha"
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var audioManager: AudioManager
    
    let persistence = PersistenceController.shared
    
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
                
                HStack() {
                    Text("총 \(index == 0 ? dataManager.teamSongs.count : dataManager.playerSongs.count)곡")
                        .font(Font.Halmap.CustomCaptionBold)
                        .foregroundColor(.customDarkGray)
                    Spacer()
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 15, trailing: 20))
                .padding(.top, UIScreen.getHeight(27))
                
                Divider()
                    .overlay(Color.customGray.opacity(0.6))
                    .padding(.horizontal, 20)
                
                TabView(selection: $index) {
                    List {
                        ForEach(dataManager.teamSongs) { song in
                            
                            let songInfo = SongInfo(id: song.id,
                                                    team: selectedTeam,
                                                    type: song.type,
                                                    title: song.title,
                                                    lyrics: song.lyrics,
                                                    info: song.info,
                                                    url: song.url)
                            
                            NavigationLink(destination: SongDetailView(viewModel: SongDetailViewModel(audioManager: audioManager, dataManager: dataManager, persistence: persistence, song: songInfo))) {
                                HStack(spacing: 16) {
                                    Image(dataManager.checkSeasonSong(data: songInfo) ? "\(selectedTeam)23" : "\(selectedTeam)Album")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .cornerRadius(8)
                                    VStack(alignment: .leading, spacing: 6){
                                        Text(song.title)
                                            .font(Font.Halmap.CustomBodyMedium)
                                        if !song.info.isEmpty {
                                            Text(song.info)
                                                .font(Font.Halmap.CustomCaptionMedium)
                                                .foregroundColor(.customDarkGray)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(1)
                                }
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                        .listRowBackground(Color.systemBackground)
                        .listRowSeparatorTint(Color.customGray)
                        RequestSongView(buttonColor: Color.HalmacPoint)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowBackground(Color.systemBackground)
                            .listRowSeparatorTint(Color.customGray)
                    }
                    .padding(.horizontal, 20)
                    .listStyle(.plain)
                    .tag(0)
                    
                    List {
                        ForEach(dataManager.playerSongs) { song in
                            
                            let songInfo = SongInfo(id: song.id,
                                                 team: selectedTeam,
                                                 type: song.type,
                                                 title: song.title,
                                                 lyrics: song.lyrics,
                                                 info: song.info,
                                                 url: song.url)
                            
                            
                            NavigationLink(destination: SongDetailView(viewModel: SongDetailViewModel(audioManager: audioManager, dataManager: dataManager, persistence: persistence, song: songInfo))) {
                                HStack(spacing: 16) {
                                    Image(dataManager.checkSeasonSong(data: songInfo) ? "\(selectedTeam)23" : "\(selectedTeam)Player")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .cornerRadius(8)
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(song.title)
                                            .font(Font.Halmap.CustomBodyMedium)
                                        if !song.info.isEmpty {
                                            Text(song.info)
                                                .font(Font.Halmap.CustomCaptionMedium)
                                                .foregroundColor(.customDarkGray)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(1)
                                }
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                        .listRowBackground(Color.systemBackground)
                        .listRowSeparatorTint(Color.customGray)
                        
                        RequestSongView(buttonColor: Color.HalmacPoint)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowBackground(Color.systemBackground)
                            .listRowSeparatorTint(Color.customGray)
                    }
                    .padding(.horizontal, 20)
                    .listStyle(.plain)
                    .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .edgesIgnoringSafeArea(.top)
            
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
