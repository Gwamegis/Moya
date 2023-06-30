//
//  ScalingHeaderView.swift
//  Halmap
//
//  Created by 전지민 on 2023/04/13.
//

import SwiftUI

struct ScalingHeaderView: View {
    @EnvironmentObject var dataManager: DataManager
    let maxHeight: CGFloat = UIScreen.getHeight(216)
    var topEdge: CGFloat
    
    @State var offset: CGFloat = 0
    @State var isShowSheet = false
    @State var collectedSongData: CollectedSong?
    @State var isDraged = false
    
    @FetchRequest(entity: CollectedSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.date, ascending: true)], predicate: PlayListFilter(filter: "favorite").predicate, animation: .default) private var collectedSongs: FetchedResults<CollectedSong>
    
    let persistence = PersistenceController.shared
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                GeometryReader { proxy in
                    VStack(spacing: 0) {
                        topBar
                            .frame(maxWidth: .infinity)
                            .frame(height: getHeaderHeight(), alignment: .bottom)
                            .overlay(
                                topTitle
                                    .opacity(checkScrollRequirement(listCount: collectedSongs.count) && isDraged ? 1 : 0)
                            )
                        HStack() {
                            Text("총 \(collectedSongs.count)곡")
                                .font(Font.Halmap.CustomCaptionBold)
                                .foregroundColor(.customDarkGray)
                            Spacer()
                            Button {
                                withAnimation {
                                    isDraged.toggle()
                                }
                            } label: {
                                HStack(spacing: 5) {
                                    Image(systemName: "play.circle.fill")
                                        .foregroundColor(.mainGreen)
                                        .font(.system(size: 20))
                                    Text("전체 재생하기")
                                        .font(Font.Halmap.CustomCaptionBold)
                                        .foregroundColor(.mainGreen)
                                }
                                .opacity(checkScrollRequirement(listCount: collectedSongs.count) && isDraged ? 1 : 0)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, UIScreen.getHeight(17))
                        Divider()
                            .overlay(Color.customGray.opacity(0.6))
                            .padding(.horizontal, 20)
                    }
                    .background(Color.systemBackground)
                }
                .frame(height: maxHeight + UIScreen.getHeight(48))
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
                        ForEach(self.collectedSongs, id: \.self) { favoriteSong in
                            var song = Song(
                                id: favoriteSong.id ?? "",
                                type: favoriteSong.type ,
                                title: favoriteSong.title ?? "" ,
                                lyrics: favoriteSong.lyrics ?? "",
                                info: favoriteSong.info ?? "",
                                url: favoriteSong.url ?? ""
                            )
                            let songInfo = SongInfo(
                                id: favoriteSong.id ?? "",
                                team: favoriteSong.team ?? "",
                                type: favoriteSong.type ,
                                title: favoriteSong.title ?? "" ,
                                lyrics: favoriteSong.lyrics ?? "",
                                info: favoriteSong.info ?? "",
                                url: favoriteSong.url ?? ""
                            )
                            
                            VStack(spacing: 0) {
                                NavigationLink {
                                    SongDetailView(song: songInfo, team: favoriteSong.team ?? "Doosan")
                                } label: {
                                    HStack(spacing: 16) {
                                        Image(dataManager.checkSeasonSong(data: songInfo) ? "\(favoriteSong.team ?? "")23" : "\( favoriteSong.team ?? "NC")\(favoriteSong.type ? "Player" : "Album")")
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
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .lineLimit(1)
                                        
                                        Button {
                                            print("scaling favorite",favoriteSong)
                                            self.collectedSongData = favoriteSong
                                            
                                            song = Song(id: favoriteSong.id ?? "", type: favoriteSong.type, title: favoriteSong.title ?? "", lyrics: favoriteSong.lyrics ?? "", info: favoriteSong.info ?? "", url: favoriteSong.url ?? "")
                                            
                                            isShowSheet.toggle()
                                            
                                        } label: {
                                            Image(systemName: "ellipsis")
                                                .foregroundColor(.black.opacity(0.2))
                                        }
                                        .sheet(isPresented: $isShowSheet) {
                                            HalfSheet {
                                                HalfSheetView(showSheet: $isShowSheet, collectedSongData: $collectedSongData)
                                            }
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
            .onChange(of: offset) { _ in
                if offset > -UIScreen.getHeight(90) {
                    withAnimation {
                        isDraged = false
                    }
                } else if offset < 0 {
                    withAnimation {
                        isDraged = true
                    }
                }
            }
        }
        .coordinateSpace(name: "StorageScroll")
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
                Button {
                    withAnimation {
                        isDraged.toggle()
                    }
                } label: {
                    Image(systemName: "play.circle.fill")
                        .foregroundColor(.mainGreen)
                        .font(.system(size: 50))
                }
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
        }
        .opacity(checkScrollRequirement(listCount: collectedSongs.count) && isDraged ? 0 : 1)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
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
        isDraged ? (59 + topEdge) : maxHeight + offset
    }
    
    func checkScrollRequirement(listCount: Int) -> Bool{
        UIScreen.screenHeight - (59 + topEdge) - CGFloat(75 * listCount) <= 0 ? true : false
    }
}

struct ScalingHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        StorageContentView()
    }
}
