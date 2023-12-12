//
//  MainTabView.swift
//  Halmap
//
//  Created by 전지민 on 2023/03/03.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var dataManager: DataManager
    @AppStorage("selectedTeam") var selectedTeam = "Hanwha"
    @StateObject var viewModel = MainTabViewModel()
    @Binding var songInfo: SongInfo
    
    init(songInfo: Binding<SongInfo>) {
        self._songInfo = songInfo
        Color.setColor(selectedTeam)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                switch viewModel.state {
                case .home:
                    MainSongListTabView(songInfo: $songInfo)
                case .search:
                    SongSearchView(viewModel: SongSearchViewModel(dataManager: dataManager))
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
                .padding(.vertical, 10)
                .padding(.horizontal, 47)
                .background(Color.tabBarGray)
                .shadow(color: Color.customGray, radius: 1)
            }
            .ignoresSafeArea(.keyboard)
        }
        .navigationViewStyle(.stack)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(songInfo: .constant(SongInfo(id: "", team: "Lotte", type: true, title: "", lyrics: "", info: "", url: "")))
    }
}
