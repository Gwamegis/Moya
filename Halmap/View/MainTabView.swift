//
//  MainTabView.swift
//  Halmap
//
//  Created by 전지민 on 2023/03/03.
//

import SwiftUI

struct MainTabView: View {    
    @AppStorage("selectedTeam") var selectedTeam = "Hanwha"
    @State var expand = false
    // @State var isMusicPlaying = false
    @Binding var isMusicPlaying: Bool
    @Binding var selectedSong: SongInfo
//    @State var selectedSong: SongInfo = SongInfo(id: "", team: "", type: false, title: "", lyrics: "", info: "", url: "")
    @Namespace var animation

    init(selectedSong: Binding<SongInfo>, isMusicPlaying: Binding<Bool>) {
        self._selectedSong = selectedSong
        self._isMusicPlaying = isMusicPlaying
        Color.setColor(selectedTeam)
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            TabView {
                MainSongListTabView(expand: $expand, isMusicPlaying: $isMusicPlaying, selectedSong: $selectedSong)
                    .tabItem {
                        Image("home")
                        Text("응원곡")
                    }
                SongSearchView()
                    .tabItem {
                        Image("search")
                        Text("곡 검색")
                      }
                StorageContentView()
                    .tabItem {
                        Image("storage")
                        Text("보관함")
                    }
            }
            .accentColor(Color.HalmacPoint)
            
//            if isMusicPlaying{
//                MiniPlayerView(animation: animation, expand: $expand, isPlayingMusic: $isMusicPlaying, selectedSong: $selectedSong)
//            }
        }
    }
}

//struct MainTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainTabView()
//    }
//}
