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
    
    static func setColor(_ teamName: String) {
        Color.HalmacPoint = Color("\(teamName)Point")
        Color.HalmacBackground = Color("\(teamName)Background")
        Color.HalmacSub = Color("\(teamName)Sub")
    }
    
    static var customGray = Color("customGray")
    static var customGray2 = Color("customGray2")
    static var lightGray = Color("lightGray")
    static var lightGray2 = Color("lightGray2")
    static var lightGray3 = Color("lightGray3")
    static var systemBackground = Color("systemBackground")
}
