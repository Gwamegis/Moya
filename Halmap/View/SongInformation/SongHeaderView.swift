//
//  SongHeaderView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI
import AVFoundation

struct SongHeaderView: View {
    
    @Binding var music: Music
    @State var sound: Data?
    @State var audioPlayer: AVAudioPlayer!
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        ZStack{
            Image("lotteBackground")
                .resizable()
            
            HStack(spacing: 20){
                VStack(alignment: .leading, spacing: 10){
                    Spacer()
                    // TODO: - System Style to Custom Style
                    Text(music.songTitle)
                        .font(.title2)
                        .foregroundColor(.white)
                        .bold()
                }.padding(EdgeInsets(top: 0, leading: 20, bottom: 25, trailing: 20))
                
                Spacer()
                VStack(alignment: .trailing, spacing: 10){
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                            .foregroundColor(Color("sheetCloseButtonBlack"))
                    })
                    
                    // 재생 버튼
                    Button(action: {
                        playSoundAsset()
                    }, label: {
                        ZStack{
                            Rectangle()
                                .foregroundColor(Color("LotteBackground"))
                                .cornerRadius(20)
                                .frame(width: 83, height: 44)
                            
                            Text("재생").foregroundColor(.white)
                                .bold()
                        }
                        
                    })
                }.padding(EdgeInsets(top: 0, leading: 20, bottom: 17, trailing: 17))
            }
        }
        .onAppear(){
            configureSoundAsset(music.songTitle)
        }
    }
    
    func playSoundURL(_ soundFileName : String) {
            guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: nil) else {
                fatalError("Unable to find \(soundFileName) in bundle")
            }
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                print(error.localizedDescription)
            }
            audioPlayer.play()
        }
    
    func configureSoundAsset(_ assetName: String){
        DispatchQueue.global().sync {
            guard let audioData = NSDataAsset(name: assetName)?.data else {
               fatalError("Unable to find asset \(assetName)")
            }
            sound = audioData
            print("불러오기 완료")
        }
    }
 
    func playSoundAsset() {
       do {
           if let sound = sound {
               audioPlayer = try AVAudioPlayer(data: sound)
               audioPlayer.play()
           }
       } catch {
          fatalError(error.localizedDescription)
       }
    }
    
    
    struct SongHeaderView_Previews: PreviewProvider {
        static var previews: some View {
            
            SongHeaderView(music: .constant(Music(songTitle: "유정인", lyric: "과메기즈가 간다")))
        }
    }
}
