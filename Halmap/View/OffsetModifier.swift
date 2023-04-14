//
//  OffsetModifier.swift
//  Halmap
//
//  Created by 전지민 on 2023/03/30.
//

import SwiftUI

struct OffsetModifier: ViewModifier {
    
    @Binding var offset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader{ proxy -> Color in
                    let minY = proxy.frame(in: .named("StorageScroll")).minY
                    
                    DispatchQueue.main.async {
                        self.offset = minY
                    }
                    return Color.clear
                }
                , alignment: .top
            )
    }
}
