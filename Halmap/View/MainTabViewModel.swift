//
//  MainTabViewModel.swift
//  Halmap
//
//  Created by JeonJimin on 2023/09/04.
//

import Foundation

class MainTabViewModel: ObservableObject {
    @Published var state: State = .home

    enum State: String, CaseIterable {
        case home = "home"
        case search = "search"
        case storage = "storage"
        
        var title: String{
            switch self {
            case .home:
                return "응원곡"
            case .search:
                return "곡 검색"
            case .storage:
                return "보관함"
            }
        }
    }
}
