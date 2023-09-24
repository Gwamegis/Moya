//
//  SongSearchViewModel.swift
//  Halmap
//
//  Created by 이지원 on 2023/09/22.
//

import SwiftUI

final class SongSearchViewModel: ObservableObject {
    
    @AppStorage("selectedTeam") var selectedTeam = "Hanwha"
    @Published var searchText: String = ""
    @Published var autoComplete: [SongInfo] = []
    var dataManager: DataManager?
    
    func setup(dataManager: DataManager) {
        self.dataManager = dataManager
        UIApplication.shared.hideKeyboard()
    }
    
    func isEmptySearchText() -> Bool {
        searchText.isEmpty
    }
    
    func isEmptySearchResultList() -> Bool {
        autoComplete.isEmpty
    }
    
    func didChangedSearchText() {
        guard let dataManager else { return }
        autoComplete = []

        dataManager.teamLists.forEach { teamName in
            for data in dataManager.playerSongsAll[teamName.fetchTeamIndex()] {
                if data.title.lowercased().contains(searchText.lowercased()) {
                    let music = SongInfo(id: data.id,team: teamName.rawValue, type: data.type, title: data.title, lyrics: data.lyrics, info: data.info, url: data.url)
                    autoComplete.append(music)
                }
            }
            for data in dataManager.teamSongsAll[teamName.fetchTeamIndex()] {
                if data.title.lowercased().contains(searchText.lowercased()) {
                    let music = SongInfo(id: data.id,team: teamName.rawValue, type: data.type, title: data.title, lyrics: data.lyrics, info: data.info, url: data.url)
                    autoComplete.append(music)
                }
            }
        }
    }
    
    func fetchSongList() -> [SongInfo] {
        didChangedSearchText()
        return autoComplete
    }
    
    func getAlbumImage(_ index: Int) -> String {
        guard let dataManager else { return "" }
        return dataManager.checkSeasonSong(data: autoComplete[index]) ? "\(autoComplete[index].team)23" : (autoComplete[index].type ? "\(autoComplete[index].team)Player" : "\(autoComplete[index].team)Album")
    }
    
    func getAlbumImage(with songInfo: SongInfo) -> String {
        guard let dataManager else { return "" }
        return dataManager.checkSeasonSong(data: songInfo) ? "\(songInfo.team)23" : (songInfo.type ? "\(songInfo.team)Player" : "\(songInfo.team)Album")
    }
    
    func convertSongInfoToSong(with songInfo: SongInfo) -> Song {
        return Song(id: songInfo.id, type: songInfo.type, title: songInfo.title, lyrics: songInfo.lyrics, info: songInfo.info, url: songInfo.url)
    }
    
    func setSong(data: SongInfo) -> Song {
        return Song(id: data.id, type: data.type, title: data.title, lyrics: data.lyrics, info: data.info, url: data.url)
    }
    
    /*
     Image(dataManager.checkSeasonSong(data: viewModel.autoComplete[index]) ? "\(viewModel.autoComplete[index].team)23" : (viewModel.autoComplete[index].type ? "\(viewModel.autoComplete[index].team)Player" : "\(viewModel.autoComplete[index].team)Album"))
     */
    
}
