//
//  SongHeaderView.swift
//  Halmap
//
//  Created by Yeni Hwang on 2022/10/08.
//

import SwiftUI
import AVKit

struct SongHeaderView: View {
    
    @State var audioPlayer: AVAudioPlayer!
    @Environment(\.presentationMode) var presentationMode
    
    var team: String = "롯데 자이언츠"
    var title: String = "유정인"
    
    var body: some View {
        ZStack{
            Image("lotteBackground")
                .resizable()
            
            HStack(spacing: 20){
                VStack(alignment: .leading, spacing: 10){
                    Spacer()
                    // TODO: - System Style to Custom Style
                    Text(team)
                        .font(.caption)
                        .foregroundColor(Color("songLabel"))
                        .bold()
                    // TODO: - System Style to Custom Style
                    Text(title)
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
                        initializePlayer()
                        audioPlayer.play()
//                        if self.audioPlayer.isPlaying {
//                            self.audioPlayer.pause()
//                        } else {
//                            self.audioPlayer.play()
//                        }
                        
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
        .onAppear {
//            initializePlayer()
        }
    }
    
    
    func initializePlayer(){
        let url = Bundle.main.url(forResource: "승리는 누구", withExtension: "m4a")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url!)
            audioPlayer?.play()
        } catch {
            print("error")
        }
//        guard let soundAsset: NSDataAsset = NSDataAsset(name: "고승민 응원가.mov") else {
//            print("음원 파일 에셋을 가져올 수 없습니다")
//            return
//        }
//
//        do {
//            try self.audioPlayer = AVAudioPlayer(data: soundAsset.data)
//        } catch let error as NSError {
//            print("플레이어 초기화 실패")
//            print("코드 : \(error.code), 메세지 : \(error.localizedDescription)")
//        }
    }
}
