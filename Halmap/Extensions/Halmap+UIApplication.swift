//
//  Halmap+UIApplication.swift
//  Halmap
//
//  Created by 이지원 on 2022/11/05.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func hideKeyboard() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
        let tapRecognizer = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        let tap = UIGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapRecognizer.cancelsTouchesInView = false
        tapRecognizer.delegate = self
        window.addGestureRecognizer(tapRecognizer)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
