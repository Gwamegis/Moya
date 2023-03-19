//
//  SongContentView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI
import Firebase

struct SongContentView: View {
    
    @Binding var song: Song
    @Binding var isScrolled: Bool
    @State private var offset = CGFloat.zero

    var body: some View {
        
        ScrollView(showsIndicators: true) {
            VStack {
                Text("\(song.lyrics.replacingOccurrences(of: "\\n", with: "\n"))")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.Halmap.CustomHeadline)
                    .lineSpacing(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 40, leading: 40, bottom: 120, trailing: 40))
            }
            .background(GeometryReader{
                Color.clear.preference(key: ViewOffsetKey.self,
                                    value: -$0.frame(in: .named("scroll")).origin.y)
            })
            .onPreferenceChange(ViewOffsetKey.self) {
                if $0 > 0 {
                    isScrolled = true
                } else {
                    isScrolled = false
                }
            }
        }
        .coordinateSpace(name: "scroll")
    }
    
    struct ViewOffsetKey: PreferenceKey {
        static var defaultValue = CGFloat.zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value += nextValue()
        }
    }
}
