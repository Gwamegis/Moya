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
    
    let message: MapName
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0){
                NavigationView{
                    VStack(alignment: .center) {
                        Divider()
                            .foregroundColor(Color.customGray)
                            .padding(.top, UIScreen.getHeight(119))
                        
                        Text("손가락으로 확대해 좌석을 찾아보세요!")
                            .font(Font.Halmap.CustomBodyMedium)
                            .foregroundColor(.customDarkGray)
                            .padding(.top, 28)
                        
                        ZStack {
                            Image(message.rawValue)
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
                    .ignoresSafeArea()
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            backButton
                        }
                        ToolbarItem(placement: .principal) {
                            Text(message.fetchNameKr())
                                .font(Font.Halmap.CustomTitleBold)
                                .foregroundColor(.black)
                        }
                    }
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
        StadiumMapView(message: MapName.daejeonHanwhaLifeEaglesPark)
    }
}
