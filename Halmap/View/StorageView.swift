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
    
    @State var isScrolled = false
    @State var scrolledValue = 0.0
    @State var yOffset = 0.0
    
    var body: some View {
        
        VStack(spacing: 0) {
            if !isScrolled {
                ZStack(alignment: .bottom) {
                    Image("storageTop")
                        .resizable()
                        .scaledToFit()
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
            } else {
                HStack {
                    Spacer()
                    Text("보관함")
                        .font(Font.Halmap.CustomTitleBold)
                    Spacer()
                }
                .padding(.top, 62)
            }
            
            ScrollView {
                LazyVStack(pinnedViews: .sectionHeaders) {
                    Section {
                        VStack(spacing: 0) {
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
                                                    Image(systemName: "heart.fill")
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
                        .background(GeometryReader{
                            Color.clear.preference(key: StorageViewOffsetKey.self,
                                                   value: -$0.frame(in: .named("scroll")).origin.y)
                        })
                        .onPreferenceChange(StorageViewOffsetKey.self) {
                            print(Int($0))
                            if isScrolled {
                                if Int($0) < -143 {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isScrolled = false
                                    }
                                }
                            } else {
                                if Int($0) > -274 {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isScrolled = true
                                    }
                                }
                            }
                        }
                        
                    } header: {
                        sectionHeader
                    }
                }
            }
            .coordinateSpace(name: "scrolled")
            
        }
        .background(Color.systemBackground)
        .navigationBarTitleDisplayMode(.automatic)
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
    }
    var sectionHeader: some View {
        VStack(spacing: 0) {
            HStack {
                Text("총 \(favoriteSongs.count)곡")
                    .font(Font.Halmap.CustomCaptionBold)
                    .foregroundColor(.customDarkGray)
                Spacer()
            }
            .padding(.vertical, 17)
            .padding(.horizontal, 20)
            
            Divider()
                .background(Color.customGray)
        }
        .background(Color.systemBackground)
    }
    
    struct StorageViewOffsetKey: PreferenceKey {
        static var defaultValue = CGFloat.zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value += nextValue()
        }
    }
}

struct StorageView_Previews: PreviewProvider {
    static var previews: some View {
        StorageView()
    }
}
