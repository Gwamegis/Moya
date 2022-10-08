//
//  Halmap+Font.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

// 사용 예시 : Text("텍스트").font(.Halmap.폰트명예시1)

enum AppleSDGothicNeoWeight: String {
    case ultraLight = "AppleSDGothicNeoUL00"
    case thin = "AppleSDGothicNeoT00"
    case light = "AppleSDGothicNeoL00"
    case regular = "AppleSDGothicNeoR00"
    case medium = "AppleSDGothicNeoM00"
    case semiBold = "AppleSDGothicNeoSB00"
    case bold = "AppleSDGothicNeoB00"
    case extraBold = "AppleSDGothicNeoEB00"
    case heavy = "AppleSDGothicNeoH00"
}

extension Font {
    enum HalmapFont {
        static var 폰트명예시1: Font { Font.HalmapFontFont(weight: .light, size: 20) }
        static var 폰트명예시2: Font { Font.HalmapFontFont(weight: .bold, size: 20) }
    }
}

private extension Font {
    static func HalmapFontFont(weight: AppleSDGothicNeoWeight, size: CGFloat) -> Font {
        Font.custom(weight.rawValue, size: size)
    }
}
