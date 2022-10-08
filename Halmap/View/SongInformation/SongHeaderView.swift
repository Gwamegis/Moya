//
//  SongHeaderView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

struct SongHeaderView: View {
    
    var songType: String = "견제곡"
    var title: String = "유정인 응원가"
    var description: String = "과메기즈 홈런타자 유정인이 나가신다"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            HStack{
                Text(songType)
                    .foregroundColor(Color("songLabel"))
                    .bold()
                Spacer()
                Button(action: {
                    
                }, label: {
                    Image("Close")
                })
            }
            HStack{
                VStack(alignment: .leading, spacing: 10){
                    Text(title)
                        .font(.title)
                        .bold()
                    Text(description)
                }
                
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Image("play")
                })
            }
        }.padding([.trailing, .leading])
    }
}

struct SongHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SongHeaderView()
    }
}
