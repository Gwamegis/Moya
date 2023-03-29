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
    
    var body: some View {
        VStack(spacing: 0) {
            Text("보관함")
                .font(Font.Halmap.CustomTitleBold)
                .padding(.top, 16)
                .padding(.bottom, 32)
            
            Divider()
                .background(Color.customGray)
            
            List {
                ForEach(favoriteSongs) { favoriteSong in
                    let song = Song(id: favoriteSong.id ?? "", type: favoriteSong.type , title: favoriteSong.title ?? "" , lyrics: favoriteSong.lyrics ?? "", info: favoriteSong.info ?? "", url: favoriteSong.url ?? "")
                    
                    NavigationLink {
                        SongDetailView(song: song)
                    } label: {
                        HStack {
                            Text(favoriteSong.title ?? "test ")
                                .font(Font.Halmap.CustomBodyMedium)
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                            Spacer()
                            Button {
                                print("")
                            } label: {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.HalmacBackground)
                            }
                            
                        }
                    }
                }
                .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                .listRowBackground(Color.systemBackground)
                .listRowSeparatorTint(Color.customGray)
            }
            .listStyle(.plain)
            .padding(.horizontal, 20)
        }
        .background(Color.systemBackground)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
    }
}

struct StorageView_Previews: PreviewProvider {
    static var previews: some View {
        StorageView()
    }
}
