//
//  SongContentView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI

struct SongContentView: View {
    
    @State var selectedTeam: String = (UserDefaults.standard.string(forKey: "selectedTeam") ?? "Hanwha")
    @Binding var music: Music
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("가사")
                    .foregroundColor(Color("\(selectedTeam)Background"))
                    .font(.Halmap.CustomCaptionBold)
                
                Text(music.lyric.replacingOccurrences(of: "\\n", with: "\n"))
                    .foregroundColor(.black)
                    .font(.Halmap.CustomBodyMedium)
                    .lineSpacing(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .padding(20)
        }
    }
}
