//
//  SongDetailViewModel.swift
//  Halmap
//
//  Created by JeonJimin on 10/8/23.
//
import SwiftUI
import Combine

final class SongDetailViewModel: ObservableObject {
    @ObservedObject private var audioManager: AudioManager
    private let dataManager: DataManager
    private let persistence: PersistenceController

    @Published var song: SongInfo
    @Published var isScrolled = false
    @Published var isFavorite = false
    @Published var isPlaying = false

    private var cancellables = Set<AnyCancellable>()

    init(audioManager: AudioManager, dataManager: DataManager, persistence: PersistenceController, song: SongInfo) {
        self.audioManager = audioManager
        self.dataManager = dataManager
        self.persistence = persistence
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
        if !defaultPlaylistSongs.contains(where: {$0.id == self.song.id}) {
            //추후 하프모달 사용 시 다시 이용
//            let collectedSong = persistence.createCollectedSong(song: song, playListTitle: "bufferPlaylist")
//            persistence.resetBufferList(song: collectedSong)
            persistence.saveSongs(song: song, playListTitle: "defaultPlaylist", order: Int64(defaultPlaylistSongs.count))
        }
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
}
