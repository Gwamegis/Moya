//
//  StadiumMapView.swift
//  Halmap
//
//  Created by Gary Shim on 2022/10/08.
//

import SwiftUI

struct StadiumMapView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var currentScale: CGFloat = 1.0
    @State var lastScale: CGFloat = 1.0
    @State var currentOffset = CGSize.zero
    @State var lastOffset = CGSize.zero
    
    let message: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
//                Capsule()
//                    .fill(Color.secondary)
//                    .opacity(0.5)
//                    .frame(width: 60, height: 5)
//                    .padding(EdgeInsets(top: 12, leading: geometry.size.width / 2 - 30, bottom: 23, trailing: geometry.size.width / 2 - 30))
                NavigationView{
                    VStack(alignment: .leading) {
                        Text("좌석 배치도")
                            .font(Font.Halmap.CustomCaptionBold)
                            .padding(EdgeInsets(top: 40, leading: 20, bottom: 0, trailing: 0))
                        
                        ZStack {
                            Image(message)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .offset(x: self.currentOffset.width, y: self.currentOffset.height)
                                .scaleEffect(max(self.currentScale, 1.0)) // the second question
                                .gesture(DragGesture()
                                    .onChanged { value in
                                        
                                        let deltaX = value.translation.width - self.lastOffset.width
                                        let deltaY = value.translation.height - self.lastOffset.height
                                        self.lastOffset.width = value.translation.width
                                        self.lastOffset.height = value.translation.height
                                        
                                        let newOffsetWidth = self.currentOffset.width + deltaX / self.currentScale
                                        if newOffsetWidth <= geometry.size.width - 150.0 && newOffsetWidth > -150.0 {
                                            self.currentOffset.width = self.currentOffset.width + deltaX / self.currentScale
                                        }
                                        
                                        let newOffsetHeight = self.currentOffset.height + deltaY / self.currentScale
                                        if newOffsetHeight <= geometry.size.height && newOffsetHeight > 0 {
                                            self.currentOffset.height = self.currentOffset.height + deltaY / self.currentScale
                                        }
                                    }
                                    .onEnded { value in self.lastOffset = CGSize.zero })
                            
                                .gesture(MagnificationGesture()
                                    .onChanged { value in
                                        let delta = value / self.lastScale
                                        self.lastScale = value
                                        self.currentScale = self.currentScale * delta
                                    }
                                    .onEnded { value in self.lastScale = 1.0 })
                        }
                        Spacer()
                        
                    }
                    .navigationBarBackButtonHidden(true)
                    .navigationBarTitle(message, displayMode: .inline)
                    .navigationBarItems(leading: backButton)
                }
            }
            .navigationBarHidden(true)
        }
        .background(Color.systemBackground)
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

struct StadiumMapView_Previews: PreviewProvider {
    
    static var previews: some View {
        StadiumMapView(message: "SSG 랜더스 필드")
    }
}
