//
//  StorageView.swift
//  Halmap
//
//  Created by 전지민 on 2023/03/23.
//

import SwiftUI

struct StorageView: View {
    @EnvironmentObject var dataManager: DataManager
    @FetchRequest(entity: FavoriteSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteSong.id, ascending: true)], animation: .default) private var favoriteSongs: FetchedResults<FavoriteSong>
    
    let maxHeight: CGFloat = 216
    var topEdge: CGFloat
    @State var offset: CGFloat = 0
    
    var body: some View {
        
        ScrollView(){
            VStack(spacing: 0) {
                VStack(spacing: 12){
                    topBar
                        .frame(height: getHeaderHeight(), alignment: .bottom)
                        .overlay(
                            topTitle
                                .opacity(topTitleOpacity())
                        )
                    HStack() {
                        Text("총 \(favoriteSongs.count)곡")
                            .font(Font.Halmap.CustomCaptionBold)
                            .foregroundColor(.customDarkGray)
                        Spacer()
                        Button {
                            print("click")
                        } label: {
                            HStack(spacing: 5) {
                                Image(systemName: "play.circle.fill")
                                    .foregroundColor(.storagePlayerButtonColor)
                                    .font(.system(size: 20))
                                Text("전체 재생하기")
                                    .font(Font.Halmap.CustomCaptionBold)
                                    .foregroundColor(.storagePlayerButtonColor)
                            }
                            .opacity(topTitleOpacity())
                        }
                    }
                    .padding(.horizontal, 20)
                    Divider()
                        .background(Color.customGray)
                }
                .background(Color.systemBackground)
                .offset(y: -offset)
                .zIndex(1)
                
                LazyVStack(spacing: 0) {
                    Section {
                        if favoriteSongs.count > 0 {
                            ForEach(favoriteSongs) { favoriteSong in
                                let song = Song(id: favoriteSong.id ?? "", type: favoriteSong.type , title: favoriteSong.title ?? "" , lyrics: favoriteSong.lyrics ?? "", info: favoriteSong.info ?? "", url: favoriteSong.url ?? "")
                                VStack(spacing: 0) {
                                    NavigationLink {
                                        SongDetailView(song: song)
                                    } label: {
                                        HStack(spacing: 16) {
                                            Image("LotteSongListImage")
                                                .frame(width: 40)
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text(favoriteSong.title ?? "test ")
                                                    .font(Font.Halmap.CustomBodyMedium)
                                                    .foregroundColor(.black)
                                                Text("test ")
                                                    .font(Font.Halmap.CustomCaptionMedium)
                                                    .foregroundColor(.HalmacSub)
                                            }
                                            Spacer()
                                            Button {
                                                print("")
                                            } label: {
                                                Image(systemName: "ellipsis")
                                                    .foregroundColor(.HalmacBackground)
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 15)
                                    }
                                    Divider()
                                        .background(Color.customGray)
                                }
                                .background(Color.systemBackground)
                            }
                        } else {
                            Text("좋아하는 응원가를 담아보세요!")
                                .font(Font.Halmap.CustomBodyMedium)
                                .foregroundColor(.customDarkGray)
                                .padding(.top, 214)
                        }
                    }
                }
                .background(Color.systemBackground)
            }
            .modifier(OffsetModifier(offset: $offset))
        }
        .coordinateSpace(name: "StorageScroll")
        .edgesIgnoringSafeArea(.top)
        .background(Color.systemBackground)
    }
    var topBar: some View {
        ZStack(alignment: .bottom) {
            Image("storageTop")
                .resizable()
            HStack {
                Text("보관함")
                    .font(Font.Halmap.CustomLargeTitle)
                Spacer()
                Image(systemName: "play.circle.fill")
                    .foregroundColor(.storagePlayerButtonColor)
                    .font(.system(size: 50))
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
        }
        .opacity(getOpacity())
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
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
        .background(Color.systemBackground)
    }
    
    func getHeaderHeight() -> CGFloat {
        let topHeight = maxHeight + offset
        
        return topHeight > (59 + topEdge) ? topHeight : (59 + topEdge)
    }
    func topTitleOpacity() -> CGFloat {
        let progress = -offset / (maxHeight - (59 + topEdge))
        return progress
    }
    func getOpacity() -> CGFloat {
        let progress = -offset / 40
        let opacity = 1 - progress
        return offset < 0 ? opacity : 1
    }
}

struct StorageView_Previews: PreviewProvider {
    static var previews: some View {
        StorageContentView()
    }
}
