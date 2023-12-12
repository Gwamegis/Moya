//
//  MiniPlayerViewModel.swift
//  Halmap
//
//  Created by Kyubo Shim on 12/12/23.
//

import Foundation
import SwiftUI

class MiniPlayerViewModel: ObservableObject {
    @Published var showPlayer = false
    
    @Published var offset: CGFloat = 0
    @Published var width: CGFloat = UIScreen.main.bounds.width
    @Published var height : CGFloat = 0
    @Published var isMiniPlayerActivate = false
    @Published var hideTabBar = false
    
//    func convertTeamNameToKor(teamName: String) -> String {
//        switch teamName{
//            case "doosan":
//                return "두산 베어스"
//            case "hanwha":
//                return "한화 이글스"
//            case "samsung":
//                return "삼성 라이온즈"
//            case "lotte":
//                return "롯데 자이언츠"
//            case .:
//                return "엘지 트윈스"
//            case .ssg:
//                return "쓱 랜더스"
//            case .kt:
//                return "케이티 위즈"
//            case .nc:
//                return "엔씨 다이노스"
//            case .kiwoom:
//                return "키움 히어로즈"
//            case .kia:
//                return "기아 타이거즈"
//        }
//    }
}

