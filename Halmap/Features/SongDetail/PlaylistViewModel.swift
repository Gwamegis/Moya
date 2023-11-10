//
//  PlaylistViewModel.swift
//  Halmap
//
//  Created by 이지원 on 2023/11/02.
//

import Foundation

final class PlaylistViewModel: ObservableObject {
    
    private let audioManager: AudioManager
    private let dataManager: DataManager
    
    private var song: SongInfo
    
    init(audioManager: AudioManager, dataManager: DataManager, song: SongInfo) {
        self.audioManager = audioManager
        self.dataManager = dataManager
        self.song = song
    }
    
    init(viewModel: SongDetailViewModel) {
        self.audioManager = viewModel.audioManager
        self.dataManager = viewModel.dataManager
        self.song = viewModel.song
    }
    
    func getAlbumImage(with song: CollectedSong) -> String {
        let song = convertSongToSongInfo(song: song)
        if dataManager.checkSeasonSong(data: song) {
            return "\(song.team)23"
        } else {
            return "\(song.team)\(song.type ? "Player" : "Album")"
        }
    }
    
    func getSongTitle(song: CollectedSong) -> String {
        song.title ?? ""
    }
    
    func getSongTeamName(with song: CollectedSong) -> String {
        let song = convertSongToSongInfo(song: song)
        return TeamName(rawValue: song.team)?.fetchTeamNameKr() ?? "."
    }
    
    func didTappedSongCell(song: CollectedSong) -> SongInfo {
        let song = convertSongToSongInfo(song: song)
        print(#function, song.title)
        self.song = song
        audioManager.removePlayer()
        audioManager.AMset(song: song)
        return song
    }
    
    private func convertSongToSongInfo(song: CollectedSong) -> SongInfo {
        return SongInfo(
            id: song.id ?? "",
            team: song.team ?? "",
            type: song.type,
            title: song.title ?? "" ,
            lyrics: song.lyrics ?? "",
            info: song.info ?? "",
            url: song.url ?? ""
        )
    }
}
