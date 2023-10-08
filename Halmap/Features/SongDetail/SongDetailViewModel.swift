//
//  SongDetailViewModel.swift
//  Halmap
//
//  Created by JeonJimin on 10/8/23.
//

import Foundation
import SwiftUI

final class SongDetailViewModel: ObservableObject {
    private let audioManager: AudioManager
    private let dataManager: DataManager
    private let persistence: PersistenceController
    
    @Published var song: Song
    @Published var team: String
    
    @Published var isScrolled = false
    @Published var isFavorite = false
    
    init(audioManager: AudioManager, dataManager: DataManager, persistence: PersistenceController, song: Song, team: String) {
        self.audioManager = audioManager
        self.dataManager = dataManager
        self.persistence = persistence
        self.song = song
        self.team = team
    }
    
    func handleLikeButtonTap(deleteSong: CollectedSong) {
        if isFavorite {
            persistence.deleteSongs(song: deleteSong)
        } else {
            let songInfo = SongInfo(id: song.id, team: team, type: song.type, title: song.title, lyrics: song.lyrics, info: song.info, url: song.url)
            persistence.saveSongs(song: songInfo, playListTitle: "favorite")
        }
        isFavorite.toggle()
    }
    
    //AudioManager
    func removePlayer() {
        self.audioManager.removePlayer()
    }
    
    func setPlayer() {
        self.audioManager.AMset(song: song, selectedTeam: team)
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
}
