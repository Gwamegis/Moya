//
//  PlayListFilter.swift
//  Halmap
//
//  Created by 전지민 on 2023/05/23.
//

import Foundation

struct PlayListFilter: Equatable {
    var filter: String?
    var predicate: NSPredicate? {
        guard let filter = filter else { return nil }
        return NSPredicate(format: "playListTitle == %@", filter)
    }
}
