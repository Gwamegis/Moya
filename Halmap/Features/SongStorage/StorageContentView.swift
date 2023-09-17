//
//  StorageContentView.swift
//  Halmap
//
//  Created by 전지민 on 2023/03/30.
//

import SwiftUI

struct StorageContentView: View {
    var body: some View {
        GeometryReader { proxy in
            let topEdge = proxy.safeAreaInsets.top
            
            ScalingHeaderView(topEdge: topEdge)
                .ignoresSafeArea(.all, edges: .top)
        }
    }
}

struct StorageContentView_Previews: PreviewProvider {
    static var previews: some View {
        StorageContentView()
    }
}
