//
//  ScalingHeaderView.swift
//  Halmap
//
//  Created by 전지민 on 2023/04/13.
//

import SwiftUI

struct ScalingHeaderView: View {
    
    let maxHeight: CGFloat = 216
    var topEdge: CGFloat
    
    @State var offset: CGFloat = 0
    
    @FetchRequest(entity: CollectedSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.date, ascending: true)], predicate: PlayListFilter(filter: "favorite").predicate, animation: .default) private var collectedSongs: FetchedResults<CollectedSong>
    let persistence = PersistenceController.shared
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                GeometryReader { proxy in
                    VStack(spacing: 0) {
                        TopBar(topEdge: topEdge, offset: $offset)
                            .frame(maxWidth: .infinity)
                            .frame(height: getHeaderHeight(), alignment: .bottom)
                            .overlay(
                                topTitle
                                    .opacity(topTitleOpacity())
                            )
                        HStack() {
                            Text("총 \(collectedSongs.count)곡")
                                .font(Font.Halmap.CustomCaptionBold)
                                .foregroundColor(.customDarkGray)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 17)
                        Divider()
                            .overlay(Color.customGray.opacity(0.6))
                            .padding(.horizontal, 20)
                    }
                    .background(Color.systemBackground)
                }
                .frame(height: maxHeight + 48)
                .offset(y: -offset)
                .zIndex(1)
                
                LazyVStack(spacing: 0) {
                    if collectedSongs.isEmpty {
                        Image("storageEmpty")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding(.top, 60)
                    } else {
                        ForEach(collectedSongs) { favoriteSong in
                            let song = Song(
                                id: favoriteSong.id ?? "",
                                type: favoriteSong.type ,
                                title: favoriteSong.title ?? "" ,
                                lyrics: favoriteSong.lyrics ?? "",
                                info: favoriteSong.info ?? "",
                                url: favoriteSong.url ?? ""
                            )
                            VStack(spacing: 0) {
                                NavigationLink {
                                    SongDetailView(song: song, team: favoriteSong.team ?? "Doosan")
                                } label: {
                                    HStack(spacing: 16) {
                                        Image("\(favoriteSong.team ?? "NC")\(favoriteSong.type ? "Player" : "Album")")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .cornerRadius(8)
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(favoriteSong.title ?? "test ")
                                                .font(Font.Halmap.CustomBodyMedium)
                                                .foregroundColor(.black)
                                            Text(TeamName(rawValue: favoriteSong.team ?? "NC")?.fetchTeamNameKr() ?? ".")
                                                .font(Font.Halmap.CustomCaptionMedium)
                                                .foregroundColor(.customDarkGray)
                                        }
                                        Spacer()
                                        Button {
                                            persistence.deleteSongs(song: favoriteSong)
                                        } label: {
                                            Image(systemName: "heart.fill")
                                                .foregroundColor(.mainGreen)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                }
                            }
                            .background(Color.systemBackground)
                        }
                    }
                }
            }
            .modifier(OffsetModifier(offset: $offset))
        }
        .coordinateSpace(name: "StorageScroll")
        .background(Color.systemBackground)
    }
    var topTitle: some View {
        VStack{
            HStack {
                Spacer()
                Text("보관함")
                    .font(Font.Halmap.CustomTitleBold)
                Spacer()
            }
            .padding(.top, 40)
            
        }
    }
    
    func getHeaderHeight() -> CGFloat {
        let topHeight = maxHeight + offset
        
        return topHeight >= (59 + topEdge) ? topHeight : (59 + topEdge)
    }
    func topTitleOpacity() -> CGFloat {
        let progress = -offset*2 / (maxHeight - (59 + topEdge))
        return progress
    }
    func getOpacity() -> CGFloat {
        let progress = -offset*2 / 40
        let opacity = 1 - progress
        return offset < 0 ? opacity : 1
    }
}

struct TopBar: View {
    
    let topEdge: CGFloat
    @Binding var offset: CGFloat
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("storageTop")
                .resizable()
            HStack {
                Text("보관함")
                    .font(Font.Halmap.CustomLargeTitle)
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
        }
        .opacity(getOpacity())
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .background(Color.systemBackground)
    }
    func getOpacity() -> CGFloat {
        let progress = -offset / 40
        let opacity = 1 - progress
        return offset < 0 ? opacity : 1
    }
}

struct ScalingHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        StorageContentView()
    }
}
