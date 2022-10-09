//
//  Halmap+View.swift
//  Halmap
//
//  Created by 이지원 on 2022/10/09.
//

import SwiftUI

extension View {
    
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
