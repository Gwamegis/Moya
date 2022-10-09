//
//  StadiumListSheetView.swift
//  Halmap
//
//  Created by Gary Shim on 2022/10/08.
//

import SwiftUI

struct StadiumListSheetView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    private let messages = [ "서울 종합 야구장", "고척 스카이돔", "SSG 랜더스 필드", "사직 야구장", "대전 이글스 파크", "기아 챔피언스필드"]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("야구장 지도")
                    .font(Font.HalmapFont.CustomTitleBold)
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 40, trailing: 0))
                //                    .padding(.trailing, UIScreen.main.bounds.width - 120)
                
                
                List(messages, id: \.self) { message in
                    NavigationLink(destination: StadiumMapView(message: message)) {
                        Text(message)
                            .font(Font.HalmapFont.CustomTitleMedium)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    }
                }
                .listStyle(.plain)
            }
            .navigationBarHidden(true)
        }
    }
}


struct StadiumListSheetView_Previews: PreviewProvider {
    static var previews: some View {
        StadiumListSheetView()
    }
}
