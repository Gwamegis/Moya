//
//  TabBarView.swift
//  Halmap
//
//  Created by 유정인 on 2022/10/08.
//

import SwiftUI

struct TabBarView: View {
    
    @Binding var currentTab: Int
    @Namespace var namespace
    
    var tabBarOptions: [String] = ["팀 응원가", "선수 응원가"]
    
    var body: some View {
        HStack {
            // MARK: - 탭바 생성
            HStack {
                ForEach(Array(zip(self.tabBarOptions.indices,
                                  self.tabBarOptions)),
                        id: \.0,
                        content: { index, name in
                            TabBarItemView(tabBarItemName: name,
                                   currentTab: self.$currentTab,
                                   namespace: namespace.self,
                                   tab: index)
                })
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 24))
        // FIXME: - background 생략시 탭바가 아래로 밀리는 현상 발생
        .frame(height: 32)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(currentTab: .constant(0))
    }
}
