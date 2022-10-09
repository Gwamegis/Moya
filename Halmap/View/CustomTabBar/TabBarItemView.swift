//
//  TabBarItemView.swift
//  Halmap
//
//  Created by 유정인 on 2022/10/08.
//

import SwiftUI

struct TabBarItemView: View {
    @State var tabBarItemName: String
    @Binding var currentTab: Int
    
    let namespace: Namespace.ID
    var tab: Int
    
    var body: some View {
        Button {
            self.currentTab = tab
        } label: {
            // MARK: - 탭바 형태, 애니메이션
            VStack {
                Spacer()
                Text(tabBarItemName)
                    .font(Font.HalmapFont.CustomTitleMedium)
                    .foregroundColor(Color.white)
                if currentTab == tab {
                    Color.red
                        .frame(width: 92, height: 4)
                        .matchedGeometryEffect(id: "underline",
                                               in: namespace,
                                               properties: .frame)
                } else {
                    Color.clear.frame(height: 4)
                }
            }
            .frame(width: 100) // 탭바 아이템 간격
            .animation(.spring(), value: self.currentTab)
        }
    }
}
