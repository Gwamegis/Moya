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
    
    init() {
        //탭바 색, 그림자 설정
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(Color.lightGray)
        appearance.shadowColor = UIColor(Color.lightGray2)
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        //네비게이션바 색, 백버튼 색 설정
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor.clear
        navigationBarAppearance.shadowColor = UIColor.clear
        //indicator color 지정
        let image = UIImage(systemName: "chevron.backward")?
            .withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
        navigationBarAppearance.setBackIndicatorImage(image, transitionMaskImage: image)
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactScrollEdgeAppearance = navigationBarAppearance
    }

    var body: some Scene {
        WindowGroup {
//            MainView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            OnBoardingStartView()
        }
    }
}
