//
//  TeamSelectionView.swift
//  Halmap
//
//  Created by 유정인 on 2022/10/08.
//

import SwiftUI

struct OnBoardingStartView: View {
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    @AppStorage("selectedTeam") var selectedTeam = "Hanwha"
    @AppStorage("isShouldShowNotification") var isShouldShowNotification = false
    @AppStorage("isShouldShowTraffic") var isShouldShowTraffic = false
    @AppStorage("latestVersion") var latestVersion = "1.0.0"
    
    @EnvironmentObject var dataManager: DataManager
    @State var versionNotification: [Notification] = []
    
    @State var startButton: Bool = false
    
    var body: some View {
        if !isFirstLaunching {
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
        } else {
            TeamSelectionView(isFirstLaunching: $isFirstLaunching)
        }
    }
}

struct TeamSelectionView: View {
    @EnvironmentObject var dataManager: DataManager
    @AppStorage("selectedTeam") var finalSelectedTeam: String = ""
    @Binding var isFirstLaunching: Bool
    
    @State var buttonPressed: [Bool] = [Bool](repeating: false, count: 10)
    @State var selectedTeam: String? = nil
    
    var columns: [GridItem] = Array(repeating: .init(.adaptive(minimum: 200, maximum: .infinity), spacing: 20), count: 2)
    var teamLogo = TeamName.allCases
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("어느 팀을 응원하시나요?")
                .font(.Halmap.CustomTitleBold)
                .padding(.top, 20)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(teamLogo.indices, id: \.self) { idx in
                    Button {
                        withAnimation {
                            buttonPressed = [Bool](repeating: false, count: 10)

                            self.buttonPressed[idx].toggle()
                            self.selectedTeam = teamLogo[idx].rawValue

                        }
                    } label: {
                        ZStack {
                            Image(teamLogo[idx].rawValue)
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.getWidth(170), height: UIScreen.getHeight(108), alignment: .top)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            Image("teamSelect")
                                .resizable()
                                .frame(width: UIScreen.getWidth(170), height: UIScreen.getHeight(108))
                                .opacity(buttonPressed[idx] ? 1 : 0)
                        }
                    }
                }
            }
            .padding(.bottom, 24)
            Button {
                UserDefaults.standard.set(selectedTeam, forKey: "selectedTeam")
                withAnimation {
                    isFirstLaunching.toggle()
                    dataManager.setSongList(team: finalSelectedTeam)
                    finalSelectedTeam = selectedTeam ?? "error"
                }
                print("선택완료")
            } label: {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color.mainGreen)
                    .opacity(selectedTeam == nil ? 0.1 : 1)
                    .frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(62))
                    .overlay(
                        Text("응원하러 가기")
                            .font(.Halmap.CustomTitleBold)
                            .foregroundColor(.white)
                    )
            }
            .disabled(selectedTeam == nil)
        }
        .padding(.horizontal, 20)
    }
}
