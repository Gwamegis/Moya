//
//  SongStorageViewModel.swift
//  Halmap
//
//  Created by JeonJimin on 2023/09/24.
//

import SwiftUI

final class SongStorageViewModel: ObservableObject {
    private let dataManager: DataManager
    private let persistence: PersistenceController
    private let topEdge: CGFloat
    let maxHeight: CGFloat = 216
    
    @Published var offset: CGFloat = 0
    @Published var isDraged = false
    
    init(dataManager: DataManager, persistence: PersistenceController, topEdge: CGFloat) {
        self.dataManager = dataManager
        self.persistence = persistence
        self.topEdge = topEdge
    }
    
    func deleteSong(favoriteSong: CollectedSong) {
        persistence.deleteSongs(song: favoriteSong)
    }
    
    func makeSong(favoriteSong: CollectedSong) -> SongInfo {
        SongInfo(
            id: favoriteSong.safeId,
            team: favoriteSong.safeTeam,
            type: favoriteSong.type ,
            title: favoriteSong.safeTitle ,
            lyrics: favoriteSong.safeLyrics,
            info: favoriteSong.safeInfo,
            url: favoriteSong.safeUrl
        )
    }
    private func makeSongInfo(favoriteSong: CollectedSong) -> SongInfo {
        SongInfo(
            id: favoriteSong.safeId,
            team: favoriteSong.safeTeam,
            type: favoriteSong.type ,
            title: favoriteSong.safeTitle ,
            lyrics: favoriteSong.safeLyrics,
            info: favoriteSong.safeInfo,
            url: favoriteSong.safeUrl
        )
    }
    
    func fetchSongImageName(favoriteSong: CollectedSong) -> String {
        dataManager.checkSeasonSong(data: makeSongInfo(favoriteSong: favoriteSong)) ? "\(favoriteSong.team ?? "")23" : "\( favoriteSong.team ?? "NC")\(favoriteSong.type ? "Player" : "Album")"
    }
    
    func handleOffsetChange(threshold: CGFloat) {
        if self.offset > threshold {
            withAnimation {
                self.isDraged = false
            }
        } else if self.offset < 0 {
            withAnimation {
                self.isDraged = true
            }
        }
    }
    
    func calculateOpacity(listCount: Int, isDefaultHeader: Bool, screenHeight: CGFloat) -> Double {
        if screenHeight - (59 + topEdge) - CGFloat(75 * listCount) <= 0 && isDraged {
            return isDefaultHeader ? 0 : 1
        } else {
            return isDefaultHeader ? 1 : 0
        }
    }
    
    func getHeaderHeight() -> CGFloat {
        isDraged ? (59 + topEdge) : maxHeight + offset
    }
    
}
