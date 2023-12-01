//
//  Utility.swift
//  Halmap
//
//  Created by JeonJimin on 11/24/23.
//

import Foundation

class Utility: NSObject {
    
    private static var timeHMSFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()
    
    static func formatSecondsToHMS(_ seconds: Double) -> String {
        guard !seconds.isNaN,
            let text = timeHMSFormatter.string(from: seconds) else {
                return "00:00"
        }
         
        return text
    }
    
    static func convertSongToSongInfo(song: CollectedSong) -> SongInfo {
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
    
    static func getAlbumImage(with song: CollectedSong, seasonSongs: [[String]]) -> String {
        let song = Utility.convertSongToSongInfo(song: song)
        if seasonSongs[TeamName(rawValue: song.team)?.fetchTeamIndex() ?? 0].contains(song.title) {
            return "\(song.team)23"
        } else {
            return "\(song.team)\(song.type ? "Player" : "Album")"
        }
    }
    
}
