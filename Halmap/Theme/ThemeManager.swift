//
//  ThemeManager.swift
//  Halmap
//
//  Created by 전지민 on 2023/03/05.
//

import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("selectedTeam") var selectedTeam = "Hanwha" {
        didSet {
            updateTheme()
        }
    }
    
    @Published var selectedTheme: TeamName = TeamName.doosan
    
    init() {
        updateTheme()
    }
    
    func updateTheme() {
        selectedTheme = Themes.getTheme(selectedTeam)
    }
}
