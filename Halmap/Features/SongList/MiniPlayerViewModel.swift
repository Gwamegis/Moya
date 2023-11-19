//
//  MiniPlayerViewModel.swift
//  Halmap
//
//  Created by Kyubo Shim on 11/15/23.
//

import Foundation
import SwiftUI

class MiniPlayerViewModel: ObservableObject {
    @Published var showPlayer = false
    
    @Published var offset: CGFloat = -50
    @Published var width: CGFloat = UIScreen.main.bounds.width
    @Published var height : CGFloat = 0
    @Published var isMiniPlayerActivate = false
}
