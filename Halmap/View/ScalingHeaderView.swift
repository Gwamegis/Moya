//
//  ScalingHeaderView.swift
//  Halmap
//
//  Created by 전지민 on 2023/04/13.
//

import SwiftUI

struct ScalingHeaderView: View {
    
    let maxHeight = UIScreen.main.bounds.height/2.3
    var topEdge: CGFloat
    
    @State var offset: CGFloat = 0
    
    @FetchRequest(entity: FavoriteSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteSong.date, ascending: true)], animation: .default) private var favoriteSongs: FetchedResults<FavoriteSong>
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                GeometryReader { proxy in
                    TopBar(topEdge: topEdge, offset: $offset)
                    .frame(maxWidth: .infinity)
                    .frame(height: getHeaderHeight(), alignment: .bottom)
                    .overlay(
                        topTitle
                            .opacity(topTitleOpacity())
                    )
                }
                .frame(height: maxHeight)
                .offset(y: -offset)
                
                ForEach(favoriteSongs) { favoriteSong in
                    let song = Song(id: favoriteSong.id ?? "", type: favoriteSong.type , title: favoriteSong.title ?? "" , lyrics: favoriteSong.lyrics ?? "", info: favoriteSong.info ?? "", url: favoriteSong.url ?? "")
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
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.HalmacBackground)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                }

            }
            .modifier(OffsetModifier(offset: $offset))
        }
        .coordinateSpace(name: "StorageScroll")
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
//        .background(Color.systemBackground)
    }
    
    func getHeaderHeight() -> CGFloat {
        let topHeight = maxHeight + offset*2
        
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
        VStack(alignment: .leading, spacing: 15) {
            Image("LotteSongListImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .cornerRadius(10)
            
            Text("falksjdf;l")
                .font(.largeTitle.bold())
            Text("a;lsdjfalsdjkf;lskjdld;jal;sdjflk a;lda;lsdkjfa;lsdkjf;alfj;aljsdfl;asjdf;lajsdflajdksfajldf")
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .padding(.bottom)
    }
}

struct ScalingHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        StorageContentView()
    }
}
