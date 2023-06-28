//
//  ProgressBar.swift
//  Halmap
//
//  Created by JeonJimin on 2023/06/25.
//

import UIKit
import SwiftUI

struct ProgressBar: UIViewRepresentable {
    
    typealias UIViewType = UISlider
    
    @EnvironmentObject var audioManager: AudioManager
//
//    final class Coordinator: NSObject {
//        var value: Binding<Float>
//
//        init(value: Binding<Float>) {
//            self.value = value
//        }
//
//        @objc func valueChanged(_ sender: UISlider) {
//            self.value.wrappedValue = Float(sender.value)
//        }
//    }
    
    var thumbColor: UIColor = .white
    var minTrackColor: UIColor?
    var maxTrackColor: UIColor?
    
    var maxValue: Float
    
    @Binding var value: Float
    
    func makeUIView(context: Context) -> UISlider {
        var progressbar = UISlider(frame: .zero)
        progressbar = UISlider(frame: .zero)
        progressbar.minimumTrackTintColor = minTrackColor
        progressbar.maximumTrackTintColor = maxTrackColor
        progressbar.isContinuous = false
        progressbar.value = self.value
//        progressbar.addTarget(self, action: #selector(audioManager.update2(:)), for: .valueChanged)
        
        //thumb 설정
        progressbar.setThumbImage(makeThumbView(), for: .normal)
        return progressbar
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        print("value",self.value)
//        uiView.addTarget(self, action: #selector(audioManager.update2(value:)), for: .valueChanged)
        uiView.value = (1 / maxValue) * self.value
        
        
    }
    
    func makeThumbView() -> UIImage {
        lazy var thumbView: UIView = {
            let thumb = UIView()
            thumb.backgroundColor = .yellow//thumbTintColor
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
    
//    func makeCoordinator() -> ProgressBar.Coordinator {
//        Coordinator(value: $value)
//    }
}
