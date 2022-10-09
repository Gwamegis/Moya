//
//  HalmapApp.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

@main
struct HalmapApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        let teamName = UserDefaults.standard.string(forKey: "team") ?? "Hanwha"
        Color.setColor(teamName)
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
