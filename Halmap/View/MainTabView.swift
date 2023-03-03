//
//  MainTabView.swift
//  Halmap
//
//  Created by 전지민 on 2023/03/03.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        NavigationView {
            TabView {
                MainSongListTabView()
                    .tabItem {
                        Image(systemName: "music.note.house.fill")
                        Text("응원곡 듣기")
                      }
                SongSearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("검색")
                      }
                StadiumListSheetView()
                    .tabItem {
                        Image(systemName: "map.fill")
                        Text("야구장 지도")
                      }
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
