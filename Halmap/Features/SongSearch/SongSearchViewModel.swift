//
//  SongSearchViewModel.swift
//  Halmap
//
//  Created by 이지원 on 2023/09/22.
//

import SwiftUI


final class SongSearchViewModel: ObservableObject {
    
    enum SearchViewMode {
        case initial        // 초기화면
        case result         // 검색결과 없음
        case request        // 검색결과 있음
    }
    
    @Published var autoComplete: [SongInfo] = []
    @Published var searchText: String = "" {
        didSet {
            fetchSearchResult()
        }
    }
    var dataManager: DataManager?
    private var searchViewMode: SearchViewMode = .initial
    
    // MARK: public function
    func setup(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func getSearchViewMode() -> SearchViewMode {
        if searchText.isEmpty {
            return .initial
        } else if autoComplete.isEmpty {
            return .request
        } else {
            return .result
        }
    }
    
    func isEmptySearchText() -> Bool {
        searchText.isEmpty
    }
    
    func getAlbumImage(with songInfo: SongInfo) -> String {
        guard let dataManager else { return "" }
        return dataManager.checkSeasonSong(data: songInfo) ? "\(songInfo.team)23" : (songInfo.type ? "\(songInfo.team)Player" : "\(songInfo.team)Album")
    }
    
    func getTeamName(with songInfo: SongInfo) -> String {
        TeamName(rawValue: songInfo.team)?.fetchTeamNameKr() ?? "두산 베어스"
    }
    
    func convertSongInfoToSong(with songInfo: SongInfo) -> Song {
        Song(id: songInfo.id, type: songInfo.type, title: songInfo.title, lyrics: songInfo.lyrics, info: songInfo.info, url: songInfo.url)
    }
    
    // MARK: - Private functions
    
    private func fetchSearchResult() {
        guard let dataManager else { return }
        var searchResult: [SongInfo] = []
        
        dataManager.teamLists.forEach { team in
            let songList = dataManager.playerSongsAll[team.fetchTeamIndex()] + dataManager.teamSongsAll[team.fetchTeamIndex()]
            songList.forEach { song in
                if song.title.localizedStandardContains(searchText) {
                    let music = SongInfo(id: song.id,team: team.rawValue, type: song.type, title: song.title, lyrics: song.lyrics, info: song.info, url: song.url)
                    searchResult.append(music)
                }
            }
        }
        autoComplete = searchResult
    }
}
