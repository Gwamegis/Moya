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
    
    @StateObject var dataManager = DataManager()
    
    init() {
        //탭바 색, 그림자 설정, 탭바 아이콘 색 설정
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(Color.tabBarGray)
        appearance.shadowColor = UIColor(Color.customGray)
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.customDarkGray)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(Color.customDarkGray)]
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
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont(name: "Pretendard-Bold", size: 20)! ]
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont(name: "Pretendard-Bold", size: 20)! ]
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactScrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        
        UITableView.appearance().showsVerticalScrollIndicator = false
    }

    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.0, *) {
                OnBoardingStartView()
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                    .environmentObject(dataManager)
            } else {
                OnBoardingStartView()
                    .environmentObject(dataManager)
            }
        }
    }
}
