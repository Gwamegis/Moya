//
//  Halmap+View.swift
//  Halmap
//
//  Created by 이지원 on 2022/11/05.
//

import Foundation

extension View {
    func halfSheet<SheetView: View>(showSheet: Binding<Bool>, @ViewBuilder sheetView: @escaping ()->SheetView) -> some View {
        return self
            .background(
                HalfSheetHelper
            )
    }
}
