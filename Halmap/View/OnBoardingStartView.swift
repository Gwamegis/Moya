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
    @StateObject var miniPlayerViewModel = MiniPlayerViewModel.instance
    @Namespace var animation
    let persistence = PersistenceController.shared
    
    var body: some View {
        if !isFirstLaunching {
            ZStack{
                ForEach(Array(TeamName.allCases.enumerated()), id: \.offset) { index, team in
                    if Themes.themes[index] == TeamName(rawValue: selectedTeam) {
                        MainTabView()
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
                        MiniPlayerView()
                            .transition(.move(edge: .bottom))
                            .offset(y: miniPlayerViewModel.offset)
                            .padding(.bottom, miniPlayerViewModel.hideTabBar ? 0 : 57)
                            .ignoresSafeArea(.keyboard)
                            .ignoresSafeArea()
                    }
                }
            }
            .environmentObject(miniPlayerViewModel)
            .ignoresSafeArea(.keyboard)
        } else {
            TeamSelectionView(viewModel: TeamSelectionViewModel(dataManager: dataManager), isShowing: $isFirstLaunching)
        }
    }
}
