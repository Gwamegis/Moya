//
//  TeamName.swift
//  Halmap
//
//  Created by 전지민 on 2023/03/06.
//

import Foundation

enum TeamName: String, CaseIterable {
    case doosan = "Doosan"
    case hanwha = "Hanwha"
    case samsung = "Samsung"
    case lotte = "Lotte"
    case lg = "LG"
    case ssg = "SSG"
    case kt = "Kt"
    case nc = "NC"
    case kiwoom = "Kiwoom"
    case kia = "Kia"
    
    func fetchTeamNameKr() -> String {
        switch self {
        case .doosan:
            return "두산 베어스"
        case .hanwha:
            return "한화 이글스"
        case .samsung:
            return "삼성 라이온즈"
        case .lotte:
            return "롯데 자이언츠"
        case .lg:
            return "엘지 트윈스"
        case .ssg:
            return "쓱 랜더스"
        case .kt:
            return "케이티 위즈"
        case .nc:
            return "엔씨 다이노스"
        case .kiwoom:
            return "키움 히어로즈"
        case .kia:
            return "기아 타이거즈"
        }
    }
    
    func fetchTeamIndex() -> Int {
        switch self {
        case .doosan:
            return 0
        case .hanwha:
            return 1
        case .samsung:
            return 2
        case .lotte:
            return 3
        case .lg:
            return 4
        case .ssg:
            return 5
        case .kt:
            return 6
        case .nc:
            return 7
        case .kiwoom:
            return 8
        case .kia:
            return 9
        }
    }
}
