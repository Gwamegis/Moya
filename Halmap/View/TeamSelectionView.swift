//
//  TeamSelectionView.swift
//  Halmap
//
//  Created by 유정인 on 2022/10/08.
//

import SwiftUI

struct TeamSelectionView: View {
    var columns: [GridItem] = Array(repeating: .init(.adaptive(minimum: 200, maximum: .infinity), spacing: 20), count: 2)
    var teamLogo: [String] = ["Doosan", "Lotte", "Hanwha", "Kiwoom", "Kia", "Ssg"]

    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            Text("""
            당신의 \(Text("팀").font(.system(size: 30, weight: .bold)).foregroundColor(.red))을
            \(Text("골라주세요!").font(.system(size: 30, weight: .bold)))
            """)
            .font(.system(size: 26, weight: .regular))
            .padding(.leading, 11)
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(teamLogo, id: \.self) { i in
                    Button {
                        // TODO: - 팀 선택시 효과 추가
                    } label: {
                        Image(i)
                            .resizable()
                            .frame(width: 165, height: 158)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct TeamSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TeamSelectionView()
    }
}
