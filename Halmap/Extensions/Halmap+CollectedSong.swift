//
//  Halmap+CollectedSong.swift
//  Halmap
//
//  Created by JeonJimin on 2023/09/24.
//

import Foundation

extension CollectedSong {
    var safeId: String {
        return self.id ?? ""
    }
    var safeTeam: String {
        return self.team ?? ""
    }
    var safeTitle: String {
        return self.title ?? "Unknown"
    }
    var safeLyrics: String {
        return self.lyrics ?? ""
    }
    var safeInfo: String {
        return self.info ?? ""
    }
    var safeUrl: String {
        return self.url ?? ""
    }
}
