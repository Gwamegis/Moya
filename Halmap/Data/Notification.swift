//
//  Notification.swift
//  Halmap
//
//  Created by JeonJimin on 2023/07/09.
//

import Foundation
import FirebaseFirestoreSwift

struct Notification: Identifiable, Codable {
    @DocumentID var id: String?
//    var id: String
    var icon: String
    var isNews: Bool
    var title: String
    var detail: String
    var list: [String]
    var version: String
}
