//
//  Traffic.swift
//  Halmap
//
//  Created by JeonJimin on 2023/07/30.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

protocol DocumentSerializable {
    init?(dictionary: [String: Any])
}

struct Traffic: Codable {
    var date: Date
    var title: String
    var description: String
    
    init() {
        self.date = Date()
        self.title = ""
        self.description = ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(Date.self, forKey: .date)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
    }
    
    init(date: Date, title: String, description: String) {
        self.date = date
        self.title = title
        self.description = description
    }
}

extension Traffic: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let date = dictionary["date"] as? Date,
              let title = dictionary["title"] as? String,
              let description = dictionary["description"] as? String else { return nil }
        
        self.init(date: date, title: title, description: description)
    }
}
