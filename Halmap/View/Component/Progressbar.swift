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
    var isThumbActive: Bool = true
    
    init(team: Binding<String>, isThumbActive: Bool) {
        self._team = team
        let thumbImage = makeThumbView(isThumbActive: isThumbActive)
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
        UISlider.appearance().maximumTrackTintColor = UIColor(Color.customGray.opacity(0.2))
    }
    
    var body: some View {
        Slider(value: $audioManager.progressValue) { editing in
            audioManager.didSliderChanged(editing)
        }
        .tint(Color("\(team)Point"))
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
}
