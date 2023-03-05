//
//  StadiumListSheetView.swift
//  Halmap
//
//  Created by Gary Shim on 2022/10/08.
//

import SwiftUI

struct StadiumListSheetView: View {
    private let messages = [ "서울 종합 야구장", "고척 스카이돔", "SSG 랜더스 필드", "사직 야구장", "대전 이글스 파크", "수원 KT 위즈 파크"]
    
    var body: some View {
        VStack(spacing: 0) {
            
            Text("야구장 좌석 배치도")
                .font(Font.Halmap.CustomTitleBold)
                .padding(.top, 16)
                .padding(.bottom, 32)
            
            Divider()
                .background(Color.customGray)
            
            List(messages, id: \.self) { message in
                NavigationLink(destination: StadiumMapView(message: message)) {
                    Text(message)
                        .font(Font.Halmap.CustomBodyMedium)
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                }
                .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                .listRowBackground(Color.systemBackground)
                .listRowSeparatorTint(Color.customGray)
            }
            .listStyle(.plain)
            .padding(.horizontal, 20)
        }
        .background(Color.systemBackground)
    }
}


struct StadiumListSheetView_Previews: PreviewProvider {
    static var previews: some View {
        StadiumListSheetView()
    }
}
