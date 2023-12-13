//
//  MiniPlayerViewModel.swift
//  Halmap
//
//  Created by Kyubo Shim on 12/12/23.
//

import SwiftUI
import Combine

class MiniPlayerViewModel: ObservableObject {
    static let instance = MiniPlayerViewModel(song: SongInfo(id: "", team: "", type: false, title: "", lyrics: "", info: "", url: ""))
    
    private let audioManager = AudioManager.instance
    private let dataManager = DataManager.instance
    private let persistence = PersistenceController.shared
    
    @Published var song: SongInfo
    @Published var isScrolled = false
    @Published var isFavorite = false
    @Published var isPlaying = false
    
    private var cancellables = Set<AnyCancellable>()
    
    //미니 플레이어
    @Published var showPlayer = false
    
    @Published var offset: CGFloat = 0
    @Published var width: CGFloat = UIScreen.main.bounds.width
    @Published var height : CGFloat = 0
    @Published var isMiniPlayerActivate = false
    @Published var hideTabBar = false
    
    init(song: SongInfo) {
        self.song = song
        
        audioManager.$isPlaying
            .sink { [weak self] in self?.isPlaying = $0 }
            .store(in: &cancellables)
    }
    
    func handleLikeButtonTap(deleteSong: CollectedSong) {
        if isFavorite {
            persistence.deleteSongs(song: deleteSong)
        } else {
            persistence.saveSongs(song: song, playListTitle: "favorite")
        }
        isFavorite.toggle()
    }

    //AudioManager
    func removePlayer() {
        self.audioManager.removePlayer()
    }

    func setPlayer() {
        self.audioManager.AMset(song: song)
    }

    func handlePlayButtonTap() {
        if !audioManager.isPlaying {
            audioManager.AMplay()
        } else {
            audioManager.AMstop()
        }
    }

    func getAudioIsPlaying() -> Bool {
        audioManager.isPlaying
    }
    
    func addDefaultPlaylist(defaultPlaylistSongs: FetchedResults<CollectedSong>) {
        if let index = defaultPlaylistSongs.firstIndex(where: {$0.id == self.song.id}) {
            persistence.reorderSelectedSong(index: index, results: defaultPlaylistSongs)
        } else {
            persistence.saveSongs(song: song, playListTitle: "defaultPlaylist", order: Int64(defaultPlaylistSongs.count))
        }
    }
    
    func convertSongToSongInfo(song: CollectedSong) -> SongInfo {
        SongInfo(
            id: song.id ?? "",
            team: song.team ?? "",
            type: song.type,
            title: song.title ?? "",
            lyrics: song.lyrics ?? "",
            info: song.info ?? "",
            url: song.url ?? ""
        )
    }
    
    func convertSongToSongInfo(song: Song) -> SongInfo {
        SongInfo(
            id: song.id,
            team: UserDefaults.standard.string(forKey: "selectedTeam") ?? "",
            type: song.type,
            title: song.title,
            lyrics: song.lyrics,
            info: song.info,
            url: song.url
        )
    }

    // MARK: - initailize playlist view model
    func getAudioManager() -> AudioManager {
        self.audioManager
    }

    func getdataManager() -> DataManager {
        self.dataManager
    }

    func getSongInfo() -> SongInfo {
        self.song
    }
    
    func fetchImage() -> String {
        Utility.getAlbumImage(with: self.song, seasonSongs: dataManager.seasonSongs)
    }
    
    func getTeamNameKr() -> String {
        TeamName(rawValue: song.team)?.fetchTeamNameKr() ?? ""
    }
}

