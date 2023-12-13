//
//  OnBoardingStartView.swift
//  Halmap
//
//  Created by 이지원 on 2023/09/29.
//

import SwiftUI

struct OnBoardingStartView: View {
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    @AppStorage("selectedTeam") var selectedTeam = "Hanwha"
    @AppStorage("isShouldShowNotification") var isShouldShowNotification = false
    @AppStorage("isShouldShowTraffic") var isShouldShowTraffic = false
    @AppStorage("latestVersion") var latestVersion = "1.0.0"
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var dataManager: DataManager
    @StateObject var miniPlayerViewModel = MiniPlayerViewModel()
    @State var songInfo = SongInfo(id: "", team: "Lotte", type: true, title: "", lyrics: "", info: "", url: "")
    @GestureState var gestureOffset: CGFloat = 0
    @Namespace var animation
    let persistence = PersistenceController.shared
    
    var body: some View {
        if !isFirstLaunching {
            ZStack{
                ForEach(Array(TeamName.allCases.enumerated()), id: \.offset) { index, team in
                    if Themes.themes[index] == TeamName(rawValue: selectedTeam) {
                        MainTabView(songInfo: $songInfo)
                            .environmentObject(miniPlayerViewModel)
                            .sheet(isPresented: $isShouldShowTraffic) {
                                HalfSheet {
                                    NotificationView(type: .traffic)
                                }
                            }
                            .sheet(isPresented: $isShouldShowNotification) {
                                HalfSheet {
                                    NotificationView(type: .version)
                                }
                            }
                    }
                }
                VStack{
                    Spacer()
                    if miniPlayerViewModel.showPlayer {
                        MiniPlayerView(viewModel: SongDetailViewModel(audioManager: audioManager, dataManager: dataManager, persistence: persistence, song: songInfo), selectedSongInfo: $songInfo)
                            .transition(.move(edge: .bottom))
                            .offset(y: miniPlayerViewModel.offset)
                            .gesture(DragGesture().updating($gestureOffset, body: { (value, state, _) in
                                
                                state = value.translation.height
                            })
                                .onEnded(onEnd(value:)))
                            .padding(.bottom, miniPlayerViewModel.hideTabBar ? 0 : 57)
                            .ignoresSafeArea(.keyboard)
                            .ignoresSafeArea()
                    }
                }
            }
            .onChange(of: gestureOffset, perform: { value in
                onChanged()
            })
            .environmentObject(miniPlayerViewModel)
        } else {
            TeamSelectionView(viewModel: TeamSelectionViewModel(dataManager: dataManager), isShowing: $isFirstLaunching)
        }
    }
    
    func onChanged(){
        if gestureOffset > 0 && !miniPlayerViewModel.isMiniPlayerActivate && miniPlayerViewModel.offset + 200 <= miniPlayerViewModel.height{
            miniPlayerViewModel.offset = gestureOffset
        }
    }
    
    func onEnd(value: DragGesture.Value){
        withAnimation(.smooth){

            if !miniPlayerViewModel.isMiniPlayerActivate{
                miniPlayerViewModel.offset = 0
                
                // Closing View...
                if value.translation.height > UIScreen.main.bounds.height / 3{
                    miniPlayerViewModel.hideTabBar = false
                    miniPlayerViewModel.isMiniPlayerActivate = true
                }
                else{
                    miniPlayerViewModel.hideTabBar = true
                    miniPlayerViewModel.isMiniPlayerActivate = false
                }
            }
        }
    }
}
