//
//  PlayListRow.swift
//  Halmap
//
//  Created by Yeni Hwang on 2023/06/29.
//

import SwiftUI

struct PlayListRow: View {
    @EnvironmentObject var dataManager: DataManager
    @State var songInfo: SongInfo
    
    var body: some View {
        HStack{
            Image(dataManager.checkSeasonSong(data: songInfo) ? "\(songInfo.team ?? "")23" : "\( songInfo.team ?? "NC")\(songInfo.type ? "Player" : "Album")")
                .resizable()
                .frame(width: 40, height: 40)
                .cornerRadius(8)
            VStack(alignment: .leading, spacing: 8) {
                Text(songInfo.title ?? "test ")
                    .font(Font.Halmap.CustomBodyMedium)
                    .foregroundColor(.white)
                Text(TeamName(rawValue: songInfo.team ?? "NC")?.fetchTeamNameKr() ?? ".")
                    .font(Font.Halmap.CustomCaptionMedium)
                    .foregroundColor(.customDarkGray)
            }.padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(1)
            Image(systemName: "text.justify")
                .frame(width: 18, height: 18)
                .foregroundStyle(.gray)
        }
        .padding(.horizontal, 20) // 40 -> 20 값 조정
        .frame(height: 50) // 70 -> 50값 조정
    }
}
