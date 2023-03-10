//
//  StadiumListSheetView.swift
//  Halmap
//
//  Created by Gary Shim on 2022/10/08.
//

import SwiftUI

struct StadiumListSheetView: View {
    private let messages = MapName.allCases
    
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
                    Text(message.fetchNameKr())
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
    }
}


struct StadiumListSheetView_Previews: PreviewProvider {
    static var previews: some View {
        StadiumListSheetView()
    }
}
