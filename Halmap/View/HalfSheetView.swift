//
//  HalfSheetView.swift
//  Halmap
//
//  Created by 전지민 on 2023/05/23.
//

import SwiftUI

struct HalfSheetView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var collectedSongData: CollectedSong
    @Binding var showSheet: Bool
    @FetchRequest(
        entity: CollectedSong.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.date, ascending: true)],
        predicate: PlaylistFilter(filter: "favorite").predicate,
        animation: .default) private var favoriteSongs: FetchedResults<CollectedSong>
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Image(Utility.getAlbumImage(with: collectedSongData, seasonSongs: dataManager.seasonSongs))
                    .resizable()
                    .cornerRadius(10)
                    .frame(width: 52, height: 52)
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                VStack(alignment: .leading, spacing: 6) {
                    Text(collectedSongData.safeTitle)
                        .font(Font.Halmap.CustomBodyBold)
                        .foregroundColor(.customBlack)
                    Text(TeamName(rawValue: collectedSongData.safeTeam)?.fetchTeamNameKr() ?? ".")
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
            if let index = favoriteSongs.firstIndex(where: { $0.id == collectedSongData.id}) {
                MenuItem(menuType: .cancelLiked, collectedSong: favoriteSongs[index], showSheet: $showSheet)
            } else {
                MenuItem(menuType: .liked, collectedSong: collectedSongData, showSheet: $showSheet)
            }
            MenuItem(menuType: .playNext, collectedSong: collectedSongData, showSheet: $showSheet)
            MenuItem(menuType: .playLast, collectedSong: collectedSongData, showSheet: $showSheet)
            Spacer()

        }
    }
}

struct MenuItem: View {
    let menuType: MenuType
    @ObservedObject var collectedSong: CollectedSong
    @Binding var showSheet: Bool
    @FetchRequest(entity: CollectedSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.order, ascending: true)], predicate: PlaylistFilter(filter: "defaultPlaylist").predicate, animation: .default) private var collectedSongs: FetchedResults<CollectedSong>
    
    var body: some View {
        Button {
            menuType.fetchFunction(collectedSong: collectedSong, playlists: collectedSongs)
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
    case liked
    case cancelLiked
    case playNext
    case playLast
    
    func fetchMenuTitle() -> String {
        switch self {
        case .liked:
            return "좋아요"
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
        case .liked:
            return "heart"
        case .cancelLiked:
            return "heart.slash.fill"
        case .playNext:
            return "text.insert"
        case .playLast:
            return "text.append"
        }
    }
    
    func fetchFunction(collectedSong: CollectedSong, playlists: FetchedResults<CollectedSong>) {
        let persistence = PersistenceController.shared
        switch self {
        case .liked:
            return persistence.saveSongs(song: Utility.convertSongToSongInfo(song: collectedSong), playListTitle: "favorite")
        case .cancelLiked:
            return persistence.deleteSongs(song: collectedSong)
        case .playNext:
            //TODO: 바로 다음에 재생 기능 추가
            return persistence.saveSongs(collectedSong: collectedSong, playListTitle: "defaultPlaylist", menuType: .playNext, collectedSongs: playlists)
        case .playLast:
            //TODO: 맨 마지막에 재생 기능 추가
            return persistence.saveSongs(collectedSong: collectedSong, playListTitle: "defaultPlaylist", menuType: .playLast, collectedSongs: playlists)
        }
    }
}
