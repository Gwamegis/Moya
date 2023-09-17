//
//  RequestSongView.swift
//  Halmap
//
//  Created by 전지민 on 2023/04/01.
//

import SwiftUI

struct RequestSongView: View {
    var buttonColor: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Text("원하는 응원가가 없으신가요?")
                .foregroundColor(Color.customDarkGray)
                .font(Font.Halmap.CustomCaptionMedium)
            
            Link(destination: URL(string: "https://forms.gle/KmJaL1UTYahUVGkk7")!) {
                HStack(spacing: 8) {
                    Image(systemName: "paperplane.fill")
                    Text("응원가 신청하기")
                        .font(Font.Halmap.CustomBodyBold)
                }
                .padding(EdgeInsets(top: 8, leading: 38, bottom: 8, trailing: 38))
                .foregroundColor(buttonColor)
                .background {
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(buttonColor, lineWidth: 1)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)

    }
}

struct RequestSongView_Previews: PreviewProvider {
    static var previews: some View {
        RequestSongView(buttonColor: Color.HalmacPoint)
    }
}
