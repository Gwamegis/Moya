//
//  StadiumMapView.swift
//  Halmap
//
//  Created by Gary Shim on 2022/10/08.
//

import SwiftUI

struct StadiumMapView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let message: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("좌석 배치도")
                .font(Font.HalmapFont.CustomCaptionBold)
                .padding(EdgeInsets(top: 40, leading: 20, bottom: 0, trailing: 0))
            Image(message)
                .resizable()
                .scaledToFit()
            Spacer()
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(message, displayMode: .inline)
        .navigationBarItems(leading: btnBack)
    }
    
    var btnBack : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.black)
            }
        }
    }
}

struct StadiumMapView_Previews: PreviewProvider {
    
    static var previews: some View {
        StadiumMapView(message: "SSG 랜더스 필드")
    }
}
