//
//  OnboardingView.swift
//  Halmap
//
//  Created by 유정인 on 2022/10/08.
//

import SwiftUI

struct OnboardingView: View {
    var columns: [GridItem] = Array(repeating: .init(.adaptive(minimum: 200, maximum: .infinity)), count: 2)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            Text("""
            뽕이 차오르는
            당신의 \(Text("야구 팀").font(.system(size: 30, weight: .bold)).foregroundColor(.red))을
            \(Text("골라주세요!").font(.system(size: 30, weight: .bold)))
            """)
            .font(.system(size: 26, weight: .regular))
            .padding(.leading, 11)
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(0..<6) { _ in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black)
                        .frame(width: 165, height: 165)
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
