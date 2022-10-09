//
//  Model.swift
//  Halmap
//
//  Created by 전지민 on 2022/10/09.
//

import Foundation

struct TeamList: Codable {
    let teamLists: [Team]

    enum CodingKeys: String, CodingKey {
        case teamLists = "teamLists"
    }
}

struct Team: Codable, Hashable {
    let id: Int
    let teamName: String
    let teamSongs: [TeamSong]
    let player: [Player]

    enum CodingKeys: String, CodingKey {
        case id
        case teamName = "teamName"
        case teamSongs = "teamSongs"
        case player = "player"
    }
}

struct Player: Codable, Hashable {
    let playerName, lyric, songInfo: String

    enum CodingKeys: String, CodingKey {
        case playerName
        case songInfo = "songInfo"
        case lyric
    }
}

struct TeamSong: Codable, Hashable {
    let songName, lyric, songInfo: String

    enum CodingKeys: String, CodingKey {
        case songName = "songName"
        case lyric, songInfo
    }
}

struct Music {
    let teamName, songName, lyric, songInfo: String
}
