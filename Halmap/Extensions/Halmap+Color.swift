//
//  Halmap+Color.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

// static var 변수명 = Color("에셋색상파일명")

extension Color {
    static var HalmacPoint = Color("LottePoint")
    static var HalmacBackground = Color("LotteBackground")
    static var HalmacSub = Color("LotteBackground")
    
    static var customGray = Color("customGray")
    static var customDarkGray = Color("customDarkGray")
    static var systemBackground = Color("systemBackground")
    static var tabBarGray = Color("tabBarGray")
    static var mainGreen = Color("mainGreen")
    
    static func setColor(_ teamName: String) {
        Color.HalmacPoint = Color("\(teamName)Point")
        Color.HalmacBackground = Color("\(teamName)Background")
        Color.HalmacSub = Color("\(teamName)Sub")
    }
    
    static func fetchBottomGradient() -> LinearGradient {
        LinearGradient(colors: [HalmacSub, HalmacSub.opacity(0)], startPoint: .bottom, endPoint: .top)
    }
    static func fetchTopGradient() -> LinearGradient {
        LinearGradient(colors: [HalmacSub, HalmacSub.opacity(0)], startPoint: .top, endPoint: .bottom)
    }
}
