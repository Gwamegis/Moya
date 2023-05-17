//
//  ScalingHeaderView.swift
//  Halmap
//
//  Created by 전지민 on 2023/04/13.
//

import SwiftUI

struct ScalingHeaderView: View {
    
//    let maxHeight = UIScreen.main.bounds.height/3
    let maxHeight: CGFloat = 216
    var topEdge: CGFloat
    
    @State var offset: CGFloat = 0
    @State var showSheet = false
    
    @FetchRequest(entity: FavoriteSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteSong.date, ascending: true)], animation: .default) private var favoriteSongs: FetchedResults<FavoriteSong>
    
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
                    if favoriteSongs.isEmpty {
                        Image("storageEmpty")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding(.top, 60)
                    } else {
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
                                            showSheet.toggle()
                                        } label: {
                                            Image(systemName: "ellipsis")
                                                .foregroundColor(.HalmacBackground)
                                        }
                                        .halfSheet(showSheet: $showSheet) {
                                            Text("half modal")
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
                Button {
                    print("전체재생")
                } label: {
                    Image(systemName: "play.circle.fill")
                        .foregroundColor(.storagePlayerButtonColor)
                        .font(.system(size: 57))
                }
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
