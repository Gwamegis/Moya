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

    var body: some View {
        
        ScrollView(showsIndicators: true) {
            Text("\(song.lyrics.replacingOccurrences(of: "\\n", with: "\n"))")
                .foregroundColor(.white.opacity(0.8))
                .font(.Halmap.CustomHeadline)
                .lineSpacing(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 40, leading: 40, bottom: 120, trailing: 40))
        }
    }
}
