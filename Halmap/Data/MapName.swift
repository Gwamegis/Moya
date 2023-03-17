//
//  MapName.swift
//  Halmap
//
//  Created by 전지민 on 2023/03/07.
//

import Foundation

enum MapName: String, CaseIterable {
    case gocheokSkyDome = "GocheokSkyDome"
    case gwangjuKiaChampionsField = "GwangjuKiaChampionsField"
    case daeguSamsungLionsPark = "DaeguSamsungLionsPark"
    case sajikBaseballStadium = "SajikBaseballStadium"
    case suwonKTWizPark = "SuwonKTWizPark"
    case ulsanMunsuBaseballStadium = "UlsanMunsuBaseballStadium"
    case incheonSSGLandersField = "IncheonSSGLandersField"
    case seoulSportsComplexBaseballStadium = "SeoulSportsComplexBaseballStadium"
    case changwonNCPark = "ChangwonNCPark"
    case daejeonHanwhaLifeEaglesPark = "DaejeonHanwhaLifeEaglesPark"
    
    func fetchNameKr() -> String {
        switch self {
        case .daejeonHanwhaLifeEaglesPark:
            return "한화생명 이글스 파크"
        case .gocheokSkyDome:
            return "고척 스카이돔"
        case .incheonSSGLandersField:
            return "인천 SSG 랜더스 필드"
        case .sajikBaseballStadium:
            return "사직 야구장"
        case .seoulSportsComplexBaseballStadium:
            return "잠실 야구장"
        case .suwonKTWizPark:
            return "수원 KT 위즈 파크"
        case .changwonNCPark:
            return "창원 NC 파크"
        case .daeguSamsungLionsPark:
            return "대구 삼성 라이온즈 파크"
        case .gwangjuKiaChampionsField:
            return "광주 기아 챔피언스 필드"
        case .ulsanMunsuBaseballStadium:
            return "울산 문수 야구장"
        }
    }
}
