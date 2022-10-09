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
        GeometryReader { geometry in
            VStack{
                Capsule()
                    .fill(Color.secondary)
                    .opacity(0.5)
                    .frame(width: 60, height: 5)
                    .padding(EdgeInsets(top: 12, leading: geometry.size.width / 2 - 30, bottom: 23, trailing: geometry.size.width / 2 - 30))
                NavigationView{
                    VStack(alignment: .leading) {
                        Text("좌석 배치도")
                            .font(Font.Halmap.CustomCaptionBold)
                            .padding(EdgeInsets(top: 40, leading: 20, bottom: 0, trailing: 0))
                        Image(message)
                            .resizable()
                            .scaledToFit()
                        Spacer()
                        
                    }
                    .navigationBarBackButtonHidden(true)
                    .navigationBarTitle(message, displayMode: .inline)
                    .navigationBarItems(leading: backButton)
                }
            }
            .navigationBarHidden(true)
        }
    }
    var backButton : some View {
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

//Capsule()
//    .fill(Color.secondary)
//    .opacity(0.5)
//    .frame(width: 60, height: 5)
//    .padding(.horizontal, geometry.size.width / 2 - 30)

struct StadiumMapView_Previews: PreviewProvider {
    
    static var previews: some View {
        StadiumMapView(message: "SSG 랜더스 필드")
    }
}
