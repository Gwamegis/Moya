//
//  TeamSelectionView.swift
//  Halmap
//
//  Created by 유정인 on 2022/10/08.
//

import SwiftUI

struct TeamSelectionView: View {
    @EnvironmentObject var dataManager: DataManager
    @AppStorage("selectedTeam") var selectedTeamName: String = ""
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    @StateObject var viewModel: TeamSelectionViewModel
    @Binding var isShowing: Bool
    
    private let columns: [GridItem] = Array(repeating: .init(.adaptive(minimum: 200, maximum: .infinity), spacing: 20), count: 2)
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("어느 팀을 응원하시나요?")
                .font(.Halmap.CustomTitleBold)
                .padding(.top, 20)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(TeamName.allCases, id: \.self) { teamName in
                    Button {
                        viewModel.didSelectedTeam(with: teamName)
                    } label: {
                        ZStack {
                            Image(teamName.rawValue)
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.getWidth(170), height: UIScreen.getHeight(108), alignment: .top)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            Image("teamSelect")
                                .resizable()
                                .frame(width: UIScreen.getWidth(170), height: UIScreen.getHeight(108))
                                .opacity(viewModel.isSelectedTeam(with: teamName) ? 1 : 0)
                        }
                    }
                }
            }
            .padding(.bottom, 24)
            
            Button {
                withAnimation {
                    isShowing = viewModel.didTappedStartButton()
                    selectedTeamName = viewModel.getSelectedTeamName()
                }
                if !isFirstLaunching {
                    Utility.analyticsChangeTeam()
                }
            } label: {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color.mainGreen)
                    .opacity(viewModel.isChangedSelectedTeam() ? 1 : 0.1)
                    .frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(62))
                    .overlay(
                        Text("응원하러 가기")
                            .font(.Halmap.CustomTitleBold)
                            .foregroundColor(.white)
                    )
            }
            .disabled(!viewModel.isChangedSelectedTeam())
        }
        .padding(.horizontal, 20)
        .onDisappear{
            Color.setColor(selectedTeamName)
        }
        .onAppear() {
            Utility.analyticsScreenEvent(screenName: "팀 선택", screenClass: "TeamSelectionView")
        }
    }
}
