//
//  HalfSheet.swift
//  Halmap
//
//  Created by Yeni Hwang on 2023/06/24.
//
import SwiftUI

class HalfSheetController<Content>: UIHostingController<Content> where Content : View {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let presentation = sheetPresentationController {
            presentation.detents = [.medium(), .large()]
            presentation.prefersGrabberVisible = true
            presentation.largestUndimmedDetentIdentifier = .medium
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
