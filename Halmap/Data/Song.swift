//
//  Song.swift
//  Halmap
//
//  Created by 전지민 on 2022/11/05.
//

import Foundation

struct Song: Identifiable, Codable {
    var id: String
    var team: String
    var type: Bool
    var title: String
    var lyrics: String
    var info: String
    
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
}
