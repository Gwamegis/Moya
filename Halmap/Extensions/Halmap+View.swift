//
//  Halmap+View.swift
//  Halmap
//
//  Created by 이지원 on 2023/09/24.
//

import SwiftUI

extension View {
    func getSafeArea() -> UIEdgeInsets {
        UIApplication.shared.windows.first?.safeAreaInsets ?? .zero
    }
}

