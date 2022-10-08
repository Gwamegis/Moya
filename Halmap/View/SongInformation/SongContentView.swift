//
//  SongContentView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

struct SongContentView: View {
    
    var lylic: String = "별빛이 흐르는 다리를 건너 (전 구단 공통)으쌰라 으쌰 으쌰라 으쌰 바람부는 갈대숲을 지나 (전 구단 공통)으쌰라 으쌰 으쌰라 으쌰 언제나 나를 (LG, 키움, 한화, KIA, NC)OO(구단명)! / (두산)오~두산! / (kt) 언제나 kt! / (삼성)오! 오! 언제나 나를 (LG, 키움, 한화, KIA, NC)OO(구단명)! / (두산)오~두산! / (kt) 언제나 kt! / (삼성)오! 오! 기다리던 너의 아파트 / (kt) 나의 사랑 kt wiz / (나머지)으쌰라 으쌰 으쌰라 으쌰"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            Text("가사")
                .foregroundColor(Color("songLabel"))
                .bold()
            Text(lylic)
                .foregroundColor(Color.white)
                .font(.body)
            Spacer()
        }.padding([.horizontal, .top])
        
        
    }
}

struct SongContentView_Previews: PreviewProvider {
    static var previews: some View {
        SongContentView()
    }
}
