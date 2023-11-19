//
//  PlaylistViewModel.swift
//  Halmap
//
//  Created by JeonJimin on 11/14/23.
//
import Foundation

final class PlaylistViewModel: ObservableObject {

    private let audioManager: AudioManager
    private let dataManager: DataManager
    private var song: SongInfo

    init(viewModel: SongDetailViewModel) {
        audioManager = viewModel.getAudioManager()
        dataManager = viewModel.getdataManager()
        song = viewModel.getSongInfo()
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
    
    func getTeamNameKr(song: CollectedSong) -> String {
        TeamName(rawValue: song.safeTeam)?.fetchTeamNameKr() ?? ""
    }
    
    func getSongTeamBackgroundColor(with song: CollectedSong) -> String {
        "\(convertSongToSongInfo(song: song).team)Background"
    }
    
    func getSongTeamName(with song: CollectedSong) -> String {
        let song = convertSongToSongInfo(song: song)
        return TeamName(rawValue: song.team)?.fetchTeamNameKr() ?? "."
    }

    func didTappedSongCell(song: CollectedSong) -> SongInfo {
        print("song: ", song.safeTitle, "order: ", song.order)
        let song = convertSongToSongInfo(song: song)
        print(#function, song.title)
        self.song = song
        audioManager.removePlayer()
        audioManager.AMset(song: song)
        return song
    }

    private func convertSongToSongInfo(song: CollectedSong) -> SongInfo {
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
}
