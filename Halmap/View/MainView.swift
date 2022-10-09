//
//  MainView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

struct MainView: View {
    @State private var showingFullScreenCover = false
    
    var body: some View {
        Button("노래 정보"){
            self.showingFullScreenCover.toggle()
        }
        .fullScreenCover(isPresented: $showingFullScreenCover){
            SongInformationView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
