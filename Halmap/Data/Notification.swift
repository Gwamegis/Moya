//
//  Notification.swift
//  Halmap
//
//  Created by JeonJimin on 2023/07/09.
//

import Foundation

struct Notification: Identifiable, Codable {
    var id: String
    var icon: String
    var isNews: Bool
    var title: String
    var detail: String
    var list: [String]
}
