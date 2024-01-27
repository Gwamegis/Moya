//
//  Utility.swift
//  Halmap
//
//  Created by JeonJimin on 11/24/23.
//

import Foundation
import FirebaseAnalytics

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
    static func getAlbumImage(with song: SongInfo, seasonSongs: [[String]]) -> String {
        if seasonSongs[TeamName(rawValue: song.team)?.fetchTeamIndex() ?? 0].contains(song.title) {
            return "\(song.team)23"
        } else {
            return "\(song.team)\(song.type ? "Player" : "Album")"
        }
    }
    static func analyticsPlaySong(song: SongInfo, event: String) {
        let event = "PlaySong"
        let parameters = [
            "id": song.id,
            "team": song.team,
            "title": song.title,
            "event": event
        ]
        Analytics.logEvent(event, parameters: parameters)
    }
    static func analyticsPlayAllSong(index: Int) {
        let event = "PlayAllSong"
        let parameters = [
            "위치": index == 0 ? "TeamTab" : "PlayerTab",
            "event": "PlayAll"
        ]
        Analytics.logEvent(event, parameters: parameters)
    }
    static func analyticsPlayNextSongMini() {
        let event = "PlayNextSongMini"
        let parameters = [
            "event": "NextSong_Mini"
        ]
        Analytics.logEvent(event, parameters: parameters)
    }
    static func analyticsPlayPauseSongMini() {
        let event = "PlayPauseSongMini"
        let parameters = [
            "event": "PauseSong_Mini"
        ]
        Analytics.logEvent(event, parameters: parameters)
    }
    static func analyticsLikeSong() {
    }
    static func analyticsChangeTeam() {
        let event = "ChangeTeam"
        let parameters = [
            "event": "event occur"
        ]
        Analytics.logEvent(event, parameters: parameters)
    }
    static func analyticsAddSongFirst() {
        let event = "AddSongFirst"
        let parameters = [
            "event": "AddSongFirst"
        ]
        Analytics.logEvent(event, parameters: parameters)
    }
    static func analyticsAddSongLast() {
        let event = "AddSongLast"
        let parameters = [
            "event": "AddSongLast"
        ]
        Analytics.logEvent(event, parameters: parameters)
    }
//Screen View Event
    static func analyticsScreenEvent(screenName: String, screenClass: String) {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: screenName,
                                        AnalyticsParameterScreenClass: screenClass])
    }
}
