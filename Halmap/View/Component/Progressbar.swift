//
//  Progressbar.swift
//  Halmap
//
//  Created by JeonJimin on 2023/06/29.
//

import SwiftUI

struct Progressbar: View {
    @EnvironmentObject var audioManager: AudioManager
    @Binding var team: String
    let isThumbActive: Bool
    
    init(team: Binding<String>, isThumbActive: Bool) {
        self.isThumbActive = isThumbActive
        self._team = team
        let thumbImage = makeThumbView(isThumbActive: isThumbActive)
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
        UISlider.appearance().maximumTrackTintColor = UIColor(Color.customGray.opacity(0.2))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Slider(value: $audioManager.progressValue) { editing in
                audioManager.didSliderChanged(editing)
            }
            .tint(Color("\(team)Point"))
            .padding(.horizontal, isThumbActive ? 5 : 0)
//            .disabled(!isThumbActive)
            if isThumbActive {
                HStack {
                    Text(formatTime(audioManager.currentTime))
                    Spacer()
                    Text(formatTime(audioManager.duration))
                }
                .font(Font.Halmap.CustomCaptionMedium)
                .foregroundColor(.customGray)
            }
        }
        
        
    }
    
    func makeThumbView(isThumbActive: Bool) -> UIImage {
        lazy var thumbView: UIView = {
            let thumb = UIView()
            thumb.backgroundColor = UIColor(isThumbActive ? Color("\(team)Point") : Color.clear)
            return thumb
        }()
        let radius:CGFloat = 10
        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        let image = renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
        
        return image
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        if time.isNaN {
            return "00:00"
        } else {
            let minutes = Int(time) == 0 ? 0 : Int(time) / 60
            let seconds = Int(time) == 0 ? 0 : Int(time) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
        
    }
}
