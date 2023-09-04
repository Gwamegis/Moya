//
//  MainTabView.swift
//  Halmap
//
//  Created by 전지민 on 2023/03/03.
//

import SwiftUI

struct MainTabView: View {
    
    @AppStorage("selectedTeam") var selectedTeam = "Hanwha"
    @StateObject var viewModel = MainTabViewModel()
    
    init() {
        Color.setColor(selectedTeam)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                switch viewModel.state {
                case .home:
                    MainSongListTabView()
                case .search:
                    SongSearchView()
                case .storage:
                    StorageContentView()
                }

                HStack {
                    ForEach(Array(MainTabViewModel.State.allCases.enumerated()), id: \.1.rawValue) { index, state in
                        Button {
                            viewModel.state = state
                        } label: {
                            VStack(spacing: 4) {
                                Image(state.rawValue)
                                Text(state.title)
                            }
                            .foregroundColor(viewModel.state == state ? Color.HalmacPoint : Color.customDarkGray)
                        }
                        if index < MainTabViewModel.State.allCases.count - 1 {
                            Spacer()
                        }
                    }
                }
                .font(.Halmap.CustomCaptionMedium)
                .padding(.top, 10)
                .padding(.horizontal, 47)
                .padding(.bottom, 32)
                .frame(height: 90)
                .frame(alignment: .top)
                .background(Color.tabBarGray)
                .shadow(color: Color.customGray, radius: 1)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .navigationViewStyle(.stack)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
