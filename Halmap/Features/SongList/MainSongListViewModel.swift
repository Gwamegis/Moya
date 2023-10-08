//
//  MainSongListViewModel.swift
//  Halmap
//
//  Created by Kyubo Shim on 2023/10/08.
//

import SwiftUI

class MainSongListTabViewModel: ObservableObject {
    @Published var showingTeamChangingView: Bool = false
    @Published var index: Int = 0

    let dataManager: DataManager = DataManager()

    func setSongList(for team: String) {
        dataManager.setSongList(team: team)
        Color.setColor(team)
    }
    
    func getSongImage(for songInfo: SongInfo) -> String {
        if dataManager.checkSeasonSong(data: songInfo) {
            return "\(songInfo.team)23"
        } else {
            return "\(songInfo.team)Album"
        }
    }
    
    func getPlayerImage(for songInfo: SongInfo) -> String {
        if dataManager.checkSeasonSong(data: songInfo) {
            return "\(songInfo.team)23"
        } else {
            return "\(songInfo.team)Player"
        }
    }
    
    func toggleTeamChangingView() {
        showingTeamChangingView.toggle()
    }
}

