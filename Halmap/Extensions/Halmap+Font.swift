//
//  Halmap+Font.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

// 사용 예시 : Text("텍스트").font(.Halmap.폰트명예시1)

enum PretendardWeight: String {
    case medium = "Pretendard-Medium"
    case bold = "Pretendard-Bold" 
}

extension Font {
    enum Halmap {
        static var CustomLargeTitle: Font{ Font.HalmapFont(weight: .bold, size: 40) }
        static var CustomHeadline: Font { Font.HalmapFont(weight: .bold, size: 26) }
        static var CustomTitleBold: Font { Font.HalmapFont(weight: .bold, size: 20) }
        static var CustomTitleMedium: Font { Font.HalmapFont(weight: .medium, size: 20) }
        static var CustomBodyBold: Font { Font.HalmapFont(weight: .bold, size: 16) }
        static var CustomBodyMedium: Font { Font.HalmapFont(weight: .medium, size: 16) }
        static var CustomCaptionBold: Font { Font.HalmapFont(weight: .bold, size: 12) }
        static var CustomCaptionMedium: Font { Font.HalmapFont(weight: .medium, size: 10) }
    }
}

private extension Font {
    static func HalmapFont(weight: PretendardWeight, size: CGFloat) -> Font {
        Font.custom(weight.rawValue, size: size)
    }
}
