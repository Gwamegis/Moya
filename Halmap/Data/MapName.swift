//
//  MapName.swift
//  Halmap
//
//  Created by 전지민 on 2023/03/07.
//

import Foundation

enum MapName: String, CaseIterable {
    case daejeonHanwhaLifeEaglesPark = "DaejeonHanwhaLifeEaglesPark"
    case gocheokSkyDome = "GocheokSkyDome"
    case incheonSSGLandersField = "IncheonSSGLandersField"
    case sajikBaseballStadium = "SajikBaseballStadium"
    case seoulSportsComplexBaseballStadium = "SeoulSportsComplexBaseballStadium"
    case suwonKTWizPark = "SuwonKTWizPark"
    
    func fetchNameKr() -> String {
        switch self {
        case .daejeonHanwhaLifeEaglesPark:
            return "대전 이글스 파크"
        case .gocheokSkyDome:
            return "고척 스카이돔"
        case .incheonSSGLandersField:
            return "SSG 랜더스 필드"
        case .sajikBaseballStadium:
            return "사직 야구장"
        case .seoulSportsComplexBaseballStadium:
            return "서울 종합 야구장"
        case .suwonKTWizPark:
            return "수원 KT 위즈 파크"
        }
    }
}
