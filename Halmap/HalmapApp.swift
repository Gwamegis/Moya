//
//  HalmapApp.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//


import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct HalmapApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            MainView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            OnBoardingStartView()
        }
    }
}
