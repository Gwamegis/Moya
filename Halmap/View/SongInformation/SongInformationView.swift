//
//  SongInformationView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

struct SongInformationView: View {
    var body: some View {
        VStack{
            SongHeaderView()
                .frame(width: UIScreen.main.bounds.width,
                       height: 170)
                .background(Color("songGrey"))
            
            SongContentView()
                .frame(width: UIScreen.main.bounds.width)
                .background(.white)
            Spacer()
        }.ignoresSafeArea()
    }
}

struct SongInformationView_Previews: PreviewProvider {
    static var previews: some View {
        SongInformationView()
    }
}
