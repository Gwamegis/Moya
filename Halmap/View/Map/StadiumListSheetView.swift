//
//  StadiumListSheetView.swift
//  Halmap
//
//  Created by Gary Shim on 2022/10/08.
//

import SwiftUI

struct StadiumListSheetView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    private let messages = [ "서울 종합 야구장", "서울 고척 스카이돔", "인천 SSG 랜더스 필드", "부산 사직 야구장", "대전 이글스 파크", "수원 KT 위즈 파크"]
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    Capsule()
                        .fill(Color.secondary)
                        .opacity(0.5)
                        .frame(width: 60, height: 5)
                        .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                    
                    Text("야구장 지도")
                        .font(Font.Halmap.CustomTitleBold)
                        .padding(.vertical, 20)
                    
                    
                    List(messages, id: \.self) { message in
                        NavigationLink(destination: StadiumMapView(message: message)) {
                            Text(message)
                                .font(Font.Halmap.CustomTitleMedium)
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        }
                    }
                    .listStyle(.plain)
                }
                .navigationBarHidden(true)
            }
        }
    }
}


struct StadiumListSheetView_Previews: PreviewProvider {
    static var previews: some View {
        StadiumListSheetView()
    }
}
