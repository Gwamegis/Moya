//
//  HalfSheetView.swift
//  Halmap
//
//  Created by 전지민 on 2023/05/23.
//

import SwiftUI

struct HalfSheetView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    let persistence = PersistenceController.shared
    @ObservedObject var collectedSong: CollectedSong
    @State var songData: Song
    @State var song: CollectedSong = CollectedSong()
    var team: String
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Image("\(team)SongListImage")
                    .frame(width: 52, height: 52)
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                VStack(alignment: .leading, spacing: 6) {
                    Text(songData.title )
                        .font(Font.Halmap.CustomBodyBold)
                        .foregroundColor(.customBlack)
                    Text(TeamName(rawValue: team )?.fetchTeamNameKr() ?? ".")
                        .font(Font.Halmap.CustomCaptionMedium)
                        .foregroundColor(.customDarkGray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 20)
            .padding(.top, 27)
            Divider()
                .overlay(Color.customGray.opacity(0.6))
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 29, trailing: 0))
            MenuItem(menuType: .cancelLiked, collectedSong: collectedSong, showSheet: $showSheet)
            MenuItem(menuType: .playNext, collectedSong: collectedSong, showSheet: $showSheet)
            MenuItem(menuType: .playLast, collectedSong: collectedSong, showSheet: $showSheet)
            Spacer()
        }
        .onAppear() {
            print("****\(songData)")
        }
    }
}

struct MenuItem: View {
    let menuType: MenuType
    @ObservedObject var collectedSong: CollectedSong
    @Binding var showSheet: Bool
    
    var body: some View {
        Button {
            menuType.fetchFunction(collectedSong: collectedSong)
            showSheet.toggle()
        } label: {
            HStack(spacing: 24) {
                Image(systemName: menuType.fetchImage())
                    .font(.system(size: 20, weight: .regular))
                Text(menuType.fetchMenuTitle())
                    .font(Font.Halmap.CustomTitleMedium)
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
    }
}

enum MenuType {
    case cancelLiked
    case playNext
    case playLast
    
    func fetchMenuTitle() -> String {
        switch self {
        case .cancelLiked:
            return "좋아요 취소"
        case .playNext:
            return "바로 다음에 재생"
        case .playLast:
            return "맨 마지막에 재생"
        }
    }
    func fetchImage() -> String {
        switch self {
        case .cancelLiked:
            return "heart.slash.fill"
        case .playNext:
            return "text.insert"
        case .playLast:
            return "text.append"
        }
    }
    
    func fetchFunction(collectedSong: CollectedSong) {
        let persistence = PersistenceController.shared
        switch self {
        case .cancelLiked:
            return persistence.deleteSongs(song: collectedSong)
        case .playNext:
            //TODO: 바로 다음에 재생 기능 추가
            return (print("play next"))
        case .playLast:
            //TODO: 맨 마지막에 재생 기능 추가
            return (print("play last"))
        }
    }
}
