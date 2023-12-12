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
    @ObservedObject var miniPlayerViewModel: MiniPlayerViewModel
    @Binding var songInfo: SongInfo
    
    var body: some View {
        GeometryReader { proxy in
            let topEdge = proxy.safeAreaInsets.top
            
            ScalingHeaderView(viewModel: SongStorageViewModel(dataManager: dataManager, persistence: persistence, topEdge: topEdge), miniPlayerViewModel: miniPlayerViewModel, songInfo: $songInfo)
                .ignoresSafeArea(.all, edges: .top)
        }
    }
}

//struct StorageContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        StorageContentView()
//    }
//}
