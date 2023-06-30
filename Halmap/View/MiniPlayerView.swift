//
//  MiniPlayerView.swift
//  Halmap
//
//  Created by Kyubo Shim on 2023/05/18.
//

import SwiftUI

struct MiniPlayerView: View {
    var animation: Namespace.ID
    @State var isScrolled = false
    @State var selectedTeam: String = (UserDefaults.standard.string(forKey: "selectedTeam") ?? "test")
    @Binding var expand : Bool
    @Binding var isPlayingMusic: Bool
    @Binding var selectedSong: Song
    @ObservedObject var dataManager = DataManager()
    @EnvironmentObject var audioManager: AudioManager
    @State var isFavorite = false
    let persistence = PersistenceController.shared
    @State var teamName: String?
    @FetchRequest(entity: CollectedSong.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CollectedSong.id, ascending: true)], animation: .default) private var favoriteSongs: FetchedResults<CollectedSong>
    
    var height = UIScreen.main.bounds.height / 3
    
    // safearea...
    
    var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    
    @State var volume : CGFloat = 0
    
    // gesture Offset...
    
    @State var offset : CGFloat = 0
    
    var body: some View {
        
        ZStack{
            // MARK: 미니 플레이어 뷰
            
            if !expand{
                HStack(spacing: 15){
                    VStack(alignment: .leading){
                        Text(selectedSong.title)
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .matchedGeometryEffect(id: "Label", in: animation)
                        
                        Text("팀 이름")
                            .font(.caption)
                            .foregroundColor(.gray)
                            
                    }
                    
                    
                    Spacer(minLength: 0)
                    
                    
                    
                    Button {
                        if !audioManager.isPlaying {
                            audioManager.AMplay()
                        } else {
                            audioManager.AMstop()
                        }
                    } label: {
                        Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {}, label: {
                        
                        Image(systemName: "forward.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    })
                    
                }
                .padding(.horizontal)
                .cornerRadius(10)
            }
            
            
            // MARK: 메인 플레이어 뷰

            
            VStack {
                ZStack{
                    Rectangle()
                        .frame(height: UIScreen.getHeight(120))
                        .foregroundColor(Color.HalmacSub)
                    HStack{
                        Button(action: {
                            withAnimation(.spring()) {
                                self.expand = false
                            }
                        }, label: {
                            Image(systemName: "chevron.down")
                                .foregroundColor(.white)
                        })
                        
                        Image("\(selectedTeam)Album")
                            .resizable()
                            .frame(width: 52, height: 52)
                        
                        VStack {
                            Text(selectedSong.title)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            
                            Text("팀 명")
                        }
                        
                        Spacer()

                        Button(action: {
                            if isFavorite {
                                persistence.deleteSongs(song: findFavoriteSong())
                            } else {
                                persistence.saveSongs(song: selectedSong, playListTitle: "favorite")
                            }
                            isFavorite.toggle()
                        }, label: {
                            if isFavorite {
                                Image(systemName: "heart.fill")
                                .foregroundColor(Color("\(teamName ?? selectedTeam)Point"))
                            } else {
                                Image(systemName: "heart")
                                    .foregroundColor(.white)
                            }
                            
                        })
                    }
                    .background(Color.HalmacSub)
                    .padding(.top, 60)
                    .padding(.horizontal)
                    .frame(height: 100)
                }
                ZStack{
//                    HStack{
//                        Button(action: {
//                            print("go to main")
//                        }, label: {
//                            Image(systemName: "chevron.down")
//                                .foregroundColor(.white)
//                        })
//
//                        Image("\(selectedTeam)Album")
//                            .resizable()
//                            .scaledToFit()
//
//                        VStack{
//                            Text(selectedSong.title)
//
//                            Text("팀 명")
//                        }
//
//                        Spacer()
//
//                        Button(action: {
//                            print("favorite selected")
//                        }, label: {
//                            Image(systemName: "heart")
//                                .foregroundColor(.white)
//                        })
//                    }
//                    .frame(height: 50)
                    
                     SongContentView(song: $selectedSong, isScrolled: $isScrolled)
                        VStack(spacing: 0) {
                            ZStack{
//                                Rectangle()
//                                    .frame(height: UIScreen.getHeight(120))
//                                    .foregroundColor(Color.HalmacSub)
                                
                            }
//                            if isScrolled {
//                                Rectangle()
//                                    .frame(height: 100)
//                                    .background(Color.fetchTopGradient())
//                                    .foregroundColor(Color(UIColor.clear))
//                            }
                            Spacer()
//                            Rectangle()
//                                .frame(height: 100)
//                                .background(Color.fetchBottomGradient())
//                                .foregroundColor(Color(UIColor.clear))
                            ZStack(alignment: .center) {
                                Rectangle()
                                    .frame(height: UIScreen.getHeight(120))
                                    .foregroundColor(Color.HalmacSub)
                                SongPlayerView(song: $selectedSong)
                            }
                        }
                    
                }
                
                // SongPlayerView(song: $selectedSong)

                
//                VStack(spacing: 0) {
//                    Rectangle()
//                        .frame(height: UIScreen.getHeight(108))
//                        .foregroundColor(Color.HalmacSub)
//                    if isScrolled {
//                        Rectangle()
//                            .frame(height: 120)
//                            .background(Color.fetchTopGradient())
//                            .foregroundColor(Color(UIColor.clear))
//                    }
//                    Spacer()
//                    Rectangle()
//                        .frame(height: 120)
//                        .background(Color.fetchBottomGradient())
//                        .foregroundColor(Color(UIColor.clear))
//                    ZStack(alignment: .center) {
//                        Rectangle()
//                            .frame(height: UIScreen.getHeight(120))
//                            .foregroundColor(Color.HalmacSub)
//                        SongPlayerView(song: $selectedSong)
//                    }
//                }
//                .ignoresSafeArea()
                
//                HStack{
//
//                    if expand{
//
//                        Text(selectedSong.title)
//                            .font(.title2)
//                            .foregroundColor(.primary)
//                            .fontWeight(.bold)
//                            .matchedGeometryEffect(id: "Label", in: animation)
//                    }
//
//                    Spacer(minLength: 0)
//
//                    Button(action: {}) {
//
//                        Image(systemName: "ellipsis.circle")
//                            .font(.title2)
//                            .foregroundColor(.primary)
//                    }
//                }
//                .padding()
//                .padding(.top,20)
                
                // Live String...
                
//                HStack{
//
//                    Capsule()
//                        .fill(
//
//                            LinearGradient(gradient: .init(colors: [Color.primary.opacity(0.7),Color.primary.opacity(0.1)]), startPoint: .leading, endPoint: .trailing)
//                        )
//                        .frame(height: 4)
//
//                    Text("LIVE")
//                        .fontWeight(.bold)
//                        .foregroundColor(.primary)
//
//                    Capsule()
//                        .fill(
//
//                            LinearGradient(gradient: .init(colors: [Color.primary.opacity(0.1),Color.primary.opacity(0.7)]), startPoint: .leading, endPoint: .trailing)
//                        )
//                        .frame(height: 4)
//                }
//                .padding()
                
                // Stop Button...
                
//                Button(action: {}) {
//
//                    Image(systemName: "stop.fill")
//                        .font(.largeTitle)
//                        .foregroundColor(.primary)
//                }
//                .padding()
//
//                Spacer(minLength: 0)
//
//                HStack(spacing: 15){
//
//                    Image(systemName: "speaker.fill")
//
//                    Slider(value: $volume)
//
//                    Image(systemName: "speaker.wave.2.fill")
//                }
//                .padding()
                
                
//                HStack(spacing: 22){
//
//                    Button(action: {}) {
//
//                        Image(systemName: "arrow.up.message")
//                            .font(.title2)
//                            .foregroundColor(.primary)
//                    }
//
//                    Button(action: {}) {
//
//                        Image(systemName: "airplayaudio")
//                            .font(.title2)
//                            .foregroundColor(.primary)
//                    }
//
//                    Button(action: {}) {
//
//                        Image(systemName: "list.bullet")
//                            .font(.title2)
//                            .foregroundColor(.primary)
//                    }
//                }
//                .padding(.bottom,safeArea?.bottom == 0 ? 15 : safeArea?.bottom)
                
            }
            // this will give strech effect...
            .frame(height: expand ? nil : 0)
            .opacity(expand ? 1 : 0)
        }
        // expanding to full screen when clicked...
        .frame(maxHeight: expand ? .infinity : 65)
        
        // moving the miniplayer above the tabbar...
        // approz tab bar height is 49
        
        // Divider Line For Separting Miniplayer And Tab Bar....
        .background(
        
            VStack(spacing: 0){
                
                Color.HalmacSub
                // Color.red
                // Divider()
            }
            .onTapGesture(perform: {
                
                withAnimation(.spring()){expand = true}
            })
        )
        .cornerRadius(expand ? 20 : 10)
        .offset(y: expand ? 0 : -48)
        .offset(y: offset)
        .gesture(DragGesture().onEnded(onended(value:)).onChanged(onchanged(value:)))
        .ignoresSafeArea()
        .onChange(of: selectedSong) { newValue in
            print("Song has changed to: \(newValue.title)")
            audioManager.removePlayer()
            audioManager.AMset(song: selectedSong, selectedTeam: selectedTeam)
        }

    }
    
    func onchanged(value: DragGesture.Value){
        
        // only allowing when its expanded...
        print(offset)
        if value.translation.height > 0 && expand {
            offset = value.translation.height
        }
    }
    
    func onended(value: DragGesture.Value){
        
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.95, blendDuration: 0.95)){
            
            // if value is > than height / 3 then closing view...
            
            if value.translation.height > height{
                expand = false
            }

            offset = 0
        }
    }
    
    func findFavoriteSong() -> CollectedSong {
        if let index = favoriteSongs.firstIndex(where: {selectedSong.id == $0.id}) {
            return favoriteSongs[index]
        } else {
            return CollectedSong()
        }
    }
}

struct MiniPlayerView_Previews: PreviewProvider {
    @Namespace static var animation
    static var previews: some View {
        MiniPlayerView(animation: animation, expand: .constant(true), isPlayingMusic: .constant(true), selectedSong: .constant(Song(id: "", type: false, title: "'", lyrics: "", info: "'", url: "")))
    }
}
