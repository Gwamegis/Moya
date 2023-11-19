//
//  MiniPlayerView.swift
//  Halmap
//
//  Created by Kyubo Shim on 11/19/23.
//

import SwiftUI

struct MiniPlayerView: View {
    
    // ScreenHeight..
    
    @EnvironmentObject var miniPlayerViewModel: MiniPlayerViewModel
    
    
    var body: some View {
        
        VStack(spacing: 0){
            
            // Video Player...
            
            Image(systemName: "apple.logo")
                .resizable()
                .frame(width: miniPlayerViewModel.isMiniPlayerActivate ? 150 : miniPlayerViewModel.width,height: miniPlayerViewModel.isMiniPlayerActivate ? 70 : getFrame())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            GeometryReader{reader in
                
                ScrollView {
                    VStack(spacing: 18){
                        
                        // Video Playback Details And Buttons....
                        
                        VStack(alignment: .leading, spacing: 8, content: {
                            Text("M1 MacBook Unboxing And First Impressions")
                                .font(.callout)
                            
                            Text("1.2M Views")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider()
                    }
                    .padding()
                }
                .onAppear(perform: {
                    miniPlayerViewModel.height = reader.frame(in: .global).height + 250
                })
            }
            .background(Color.white)
            .opacity(miniPlayerViewModel.isMiniPlayerActivate ? 0 : getOpacity())
            .frame(height: miniPlayerViewModel.isMiniPlayerActivate ? 0 : nil)
        }
        .background(
        
            Color.white
                .ignoresSafeArea(.all, edges: .all)
                .onTapGesture {
                    withAnimation{
                        miniPlayerViewModel.width = UIScreen.main.bounds.width
                        miniPlayerViewModel.isMiniPlayerActivate.toggle()
                    }
                }
        )
    }
    
    // Getting Frame And Opacity While Dragging
    
    func getFrame()->CGFloat{
        
        let progress = miniPlayerViewModel.offset / (miniPlayerViewModel.height - 100)
        
        if (1 - progress) <= 1.0{
         
            let videoHeight : CGFloat = (1 - progress) * 250
            
            // stopping height at 70...
            if videoHeight <= 70{
                
                // Decresing Width...
                let percent = videoHeight / 70
                let videoWidth : CGFloat = percent * UIScreen.main.bounds.width
                DispatchQueue.main.async {
                    // Stopping At 150...
                    if videoWidth >= 150{
                    
                        miniPlayerViewModel.width = videoWidth
                    }
                }
                return 70
            }
            // Preview WIll Have Animation Problems...
            DispatchQueue.main.async {
                miniPlayerViewModel.width = UIScreen.main.bounds.width
            }
            
            return videoHeight
        }
        return 250
    }
    
    func getOpacity()->Double{
        
        let progress = miniPlayerViewModel.offset / (miniPlayerViewModel.height)
        if progress <= 1{
            return Double(1 - progress)
        }
        return 1
    }
}

struct PlayBackVideoButtons: View {
    var image: String
    var text: String
    var body: some View {
        Button(action: {}, label: {
            VStack(spacing: 8){
                
                Image(systemName: image)
                    .font(.title3)
                
                Text(text)
                    .fontWeight(.semibold)
                    .font(.caption)
            }
        })
        .foregroundColor(.black)
        .frame(maxWidth: .infinity)
    }
}

struct VideoContorls: View {
    
    @EnvironmentObject var player: MiniPlayerViewModel
    
    var body: some View{
        
        HStack(spacing: 15){
            
            // Video View...
            Rectangle()
                .fill(Color.clear)
                .frame(width: 150, height: 70)
            
            VStack(alignment: .leading, spacing: 6, content: {
                Text("M1 MacBook Unboxing And First Impressions")
                    .font(.callout)
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Text("Kavsoft")
                    .fontWeight(.bold)
                    .font(.caption)
                    .foregroundColor(.gray)
            })

            
            Button(action: {}, label: {
                Image(systemName: "pause.fill")
                    .font(.title2)
                    .foregroundColor(.black)
            })
            
            Button(action: {
                //withAnimation{
                    player.showPlayer.toggle()
                    player.offset = 0
                    player.isMiniPlayerActivate.toggle()
                //}
            }, label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.black)
            })
        }
        .padding(.trailing)
    }
}

//#Preview {
//    MiniPlayerView()
//}
