//
//  Halmap+Font.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

// 사용 예시 : Text("텍스트").font(.Halmap.폰트명예시1)

enum PretendardWeight: String {
    case medium = "PretendardBold"
    case bold = "PretendardMedium"
}

extension Font {
    enum HalmapFont {
        static var CustomHeadline: Font { Font.HalmapFontFont(weight: .bold, size: 26) }
        static var CustomTitleBold: Font { Font.HalmapFontFont(weight: .bold, size: 20) }
        static var CustomTitleMedium: Font { Font.HalmapFontFont(weight: .medium, size: 20) }
        static var CustomBodyBold: Font { Font.HalmapFontFont(weight: .bold, size: 16) }
        static var CustomBodyMedium: Font { Font.HalmapFontFont(weight: .medium, size: 16) }
        static var CustomCaptionBold: Font { Font.HalmapFontFont(weight: .bold, size: 12) }
        static var CustomCaptionMedium: Font { Font.HalmapFontFont(weight: .medium, size: 12) }
    }
}

private extension Font {
    static func HalmapFontFont(weight: PretendardWeight, size: CGFloat) -> Font {
        Font.custom(weight.rawValue, size: size)
    }
}
