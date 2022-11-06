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
    @Binding var music: Music
    @State var sound: Data?
    @State var audioPlayer: AVAudioPlayer!
    @State var isPlaying: Bool = false
    @Environment(\.presentationMode) var presentationMode
    


    var body: some View {
        ZStack{
            Image("\(selectedTeam)Background")
                .resizable()
                .scaledToFill()

                HStack(spacing: 20){
                    VStack(alignment: .leading, spacing: 10){
                        // TODO: - System Style to Custom Style
                        Spacer()
                        Text(music.songTitle)
                            .font(.title2)
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 25, trailing: 20))
       
                    Spacer()
                    VStack(alignment: .trailing, spacing: 10){
                        Spacer()

                        // 재생 버튼
                        Button(action: {
                            // TODO: 실제 URL로 바꾸기
                            isPlaying.toggle()
                            if isPlaying {
                                playSoundURL("test-song")
                            } else {
                                stopSound()
                            }
                            
                            print(selectedTeam)
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
        }.scaledToFill()
        .onAppear(){
            // TODO: Configure 로직 추가하기
        }
        .onDisappear(){
            stopSound()
        }
    }
    
    func playSoundURL(_ soundFileName : String) {
            guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "m4a") else {
                fatalError("Unable to find \(soundFileName) in bundle")
            }
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                print(error.localizedDescription)
            }
            audioPlayer.play()
        }
    
    // TODO: Configure 함수 url로 수정
//    func configureSoundAsset(_ assetName: String){
//        DispatchQueue.global().sync {
//            guard let audioData = NSDataAsset(name: assetName)?.data else {
//               fatalError("Unable to find asset \(assetName)")
//            }
//            sound = audioData
//            print("불러오기 완료")
//        }
//    }

    func stopSound(){
        guard let player = audioPlayer else {
            return
        }
        player.stop()
    }
}
