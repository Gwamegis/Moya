//
//  SongHeaderView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI
import AVFoundation

struct SongHeaderView: View {
    
    @State var selectedTeam: String = (UserDefaults.standard.string(forKey: "selectedTeam") ?? "test")
    @Binding var song: Song
    @State var sound: Data?
    @State var audioPlayer: AVPlayer!
    @State var isPlaying: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            Image("\(selectedTeam)Background")
                .resizable()
                .scaledToFill()
            
            HStack(spacing: 20){
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 10){
                    
                    Spacer()
                    Button(action: {
                        isPlaying.toggle()
                        if isPlaying {
                            playSoundURL(song.url)
                        } else {
                            stopSound()
                        }
                    }, label: {
                        ZStack{
                            Rectangle()
                                .foregroundColor(Color("\(selectedTeam)Background"))
                                .cornerRadius(20)
                                .frame(width: 83, height: 44)
                            
                            Text(isPlaying ? "정지" : "재생").foregroundColor(.white)
                                .bold()
                        }
                    })
                }.padding(EdgeInsets(top: 0, leading: 20, bottom: 17, trailing: 17)) // Button
            }
            
        }
        .scaledToFill()
            .onDisappear(){
                stopSound()
            }
    }
    
    func playSoundURL(_ urlString : String?) {
        
        guard let urlString = urlString else { fatalError("url을 받아올 수 없습니다.") }
        
        guard let url = URL(string: urlString) else { fatalError("url을 변환할 수 없습니다.") }
        let item = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: item)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
        audioPlayer.play()
    }
    
    func stopSound(){
        guard let player = audioPlayer else {
            return
        }
        player.pause()
    }
}
