//
//  Theme.swift
//  Halmap
//
//  Created by 전지민 on 2023/03/05.
//

import SwiftUI

enum Themes {
    static let themes = TeamName.allCases
    
    static func getTheme(_ theme: String) -> TeamName {
        Self.themes.first { $0.rawValue == theme } ?? .doosan
    }
}
