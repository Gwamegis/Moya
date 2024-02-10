//
//  StorageContentView.swift
//  Halmap
//
//  Created by 전지민 on 2023/03/30.
//

import SwiftUI

struct StorageContentView: View {
    @EnvironmentObject var dataManager: DataManager
    let persistence = PersistenceController.shared
    @EnvironmentObject var miniPlayerViewModel: MiniPlayerViewModel
    
    var body: some View {
        GeometryReader { proxy in
            let topEdge = proxy.safeAreaInsets.top
            
            ScalingHeaderView(viewModel: SongStorageViewModel(dataManager: dataManager, persistence: persistence, topEdge: topEdge))
                .ignoresSafeArea(.all, edges: .top)
        }
        .onAppear() {
            Utility.analyticsScreenEvent(screenName: "보관함", screenClass: "SongStorageView")
        }
    }
}
