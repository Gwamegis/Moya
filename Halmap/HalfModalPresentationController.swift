//
//  HalfModalPresentationController.swift
//  Halmap
//
//  Created by JeonJimin on 2023/07/09.
//

import SwiftUI

class HalfSheetController<Content>: UIHostingController<Content> where Content : View {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let presentation = sheetPresentationController {
            presentation.detents = [.medium()]
            presentation.prefersGrabberVisible = false
            presentation.largestUndimmedDetentIdentifier = .none
        }
    }
}

struct HalfSheet<Content>: UIViewControllerRepresentable where Content : View {
    
    private let content: Content
    
    @inlinable init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    func makeUIViewController(context: Context) -> HalfSheetController<Content> {
        return HalfSheetController(rootView: content)
    }
    
    func updateUIViewController(_: HalfSheetController<Content>, context: Context) {
    }
}
