//
//  SongDetailView.swift
//  Halmap
//
//  Created by JeonJimin on 10/8/23.
//

import SwiftUI

struct SongDetailView: View {
    @State var song: Song
    @State var team: String
    
    @State var isScrolled = false
    @State var isFavorite = false
    
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        ZStack {
            Color("\(team)Sub")
                .ignoresSafeArea()
            
            Lyric(song: $song, team: $team, isScrolled: $isScrolled)
            
            VStack(spacing: 0) {
                Rectangle()
                    .frame(height: UIScreen.getHeight(108))
                    .foregroundColor(Color("\(team)Sub"))
                GradientRactangle(team: team, isScrolled: isScrolled, isTop: true)
                Spacer()
                GradientRactangle(team: team, isScrolled: isScrolled, isTop: false)
                PlayBar(song: $song, team: $team)
            }
            .ignoresSafeArea()
        }
        .navigationTitle(song.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                FavoriteButton(song: song, isFavorite: $isFavorite, team: $team)
            }
        }
    }
}

private struct GradientRactangle: View {
    let height : CGFloat = 120
    let team : String
    let isScrolled : Bool
    let isTop : Bool
    
    var body: some View {
        Rectangle()
            .frame(height: height)
            .foregroundColor(Color(UIColor.clear))
            .background(isTop ? (isScrolled ? Color.fetchTopGradient(color: Color("\(team)Sub")) : nil ) : Color.fetchBottomGradient(color: Color("\(team)Sub")))
            .allowsHitTesting(false)
    }
}

private struct Lyric: View {
    @Binding var song: Song
    @Binding var team: String
    @Binding var isScrolled: Bool
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            VStack {
                Text("\(song.lyrics.replacingOccurrences(of: "\\n", with: "\n"))")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.Halmap.CustomHeadline)
                    .lineSpacing(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 40, leading: 40, bottom: 230, trailing: 40))
            }
            .background(GeometryReader{
                Color.clear.preference(key: ViewOffsetKey.self,
                                    value: -$0.frame(in: .named("scroll")).origin.y)
            })
            .onPreferenceChange(ViewOffsetKey.self) {
                if $0 > 0 {
                    withAnimation {
                        isScrolled = true
                    }
                } else {
                    withAnimation {
                        isScrolled = false
                    }
                }
            }
        }
        .coordinateSpace(name: "scroll")
    }
    private struct ViewOffsetKey: PreferenceKey {
        static var defaultValue = CGFloat.zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value += nextValue()
        }
    }
}

private struct PlayBar: View {
    @Binding var song: Song
    @Binding var team: String
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        VStack(spacing: 0) {
            Progressbar(team: $team, isThumbActive: true)
            
            HStack(spacing: 52) {
                Button {
                    if !audioManager.isPlaying {
                        audioManager.AMplay()
                    } else {
                        audioManager.AMstop()
                    }
                } label: {
                    Image(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 60, weight: .medium))
                        .foregroundStyle(Color.customGray)
                }
            }
            .padding(.bottom, 54)
        }
        .padding(.horizontal, 45)
        .frame(maxWidth: .infinity)
        .background(Color("\(team)Sub"))
        .onDisappear(){
            audioManager.removePlayer()
        }
        .onAppear(){
            audioManager.AMset(song: song, selectedTeam: team)
        }
    }
}

private struct FavoriteButton: View {
    var song: Song
    let persistence = PersistenceController.shared
    
    @Binding var isFavorite: Bool
    @Binding var team: String
    
    @FetchRequest(entity: CollectedSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.id, ascending: true)], animation: .default) private var favoriteSongs: FetchedResults<CollectedSong>
    var body: some View {
        Button {
            if isFavorite {
                persistence.deleteSongs(song: findFavoriteSong())
            } else {
                let songInfo = SongInfo(id: song.id, team: team, type: song.type, title: song.title, lyrics: song.lyrics, info: song.info, url: song.url)
                persistence.saveSongs(song: songInfo, playListTitle: "favorite")
            }
            isFavorite.toggle()
        } label: {
            if isFavorite {
                Image(systemName: "heart.fill")
                    .foregroundColor(Color("\(team)Point"))
            } else {
                Image(systemName: "heart")
                    .foregroundColor(.white)
            }
        }
        .onAppear() {
            if favoriteSongs.contains(where: {$0.id == song.id}) {
                isFavorite = true
            }
        }
    }
    private func findFavoriteSong() -> CollectedSong {
        if let index = favoriteSongs.firstIndex(where: {$0.id == song.id}) {
            return favoriteSongs[index]
        } else {
            return CollectedSong()
        }
    }
}


#Preview {
    SongDetailView(song: Song(id: "", type: false, title: "", lyrics: "", info: "", url: ""), team: "")
}
