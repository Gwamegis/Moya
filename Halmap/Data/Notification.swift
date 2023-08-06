//
//  Notification.swift
//  Halmap
//
//  Created by JeonJimin on 2023/07/09.
//

import Foundation
import FirebaseFirestoreSwift

struct Notification: Codable, Equatable {
    var icon: String
    var isRequired: Bool
    var title: String
    var detail: String
    var list: [String]
    var version: String
    
    init() {
        self.icon = ""
        self.title = ""
        self.detail = ""
        self.list = []
        self.isRequired = false
        self.version = ""
    }
    
    init(title: String, detail: String) {
        self.icon = "alert"
        self.title = title
        self.detail = detail
        self.list = []
        self.isRequired = false
        self.version = ""
    }
}
