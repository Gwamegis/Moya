//
//  UISlider.swift
//  Halmap
//
//  Created by JeonJimin on 2023/06/27.
//

import SwiftUI

struct SwiftUISlider: UIViewRepresentable {
    class UXSlider: UISlider {
        
        // Function to be triggered by touchEvent
        var dragBegan: () -> Void = {}
        var dragMoved: () -> Void = {}
        var dragEnded: () -> Void = {}
        
        /// Initialize UXSlider by overriding existing UISlider initializer
        /// - Parameter frame: The frame rectangle for the slider view, measured in points.
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        }
        
        /// UIEvent listener, listening on UISlider touchEvent
        @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
            if let touchEvent = event.allTouches?.first {
                switch touchEvent.phase {
                case .began:
                    dragBegan()
                case .moved:
                    dragMoved()
                case .ended:
                    dragEnded()
                default:
                    break
                }
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    final class Coordinator: NSObject {
        // The class property value is a binding: It’s a reference to the SwiftUISlider
        // value, which receives a reference to a @State variable value in ContentView.
        var value: Binding<Float>
        
        // Create the binding when you initialize the Coordinator
        init(value: Binding<Float>) {
            self.value = value
        }
        
        // Create a valueChanged(_:) action
        @objc func valueChanged(_ sender: UXSlider) {
            self.value.wrappedValue = sender.value
        }
    }
    
    @Binding var value: Float
    @Binding var maxValue: Float
    var tintColor: UIColor = UIColor.blue
    var thumbDiameter: CGFloat = 10
    
    var dragBegan: () -> Void = {}
    var dragMoved: () -> Void = {}
    var dragEnded: () -> Void = {}
    
    func customizeSlider(_ slider: UXSlider) {
        slider.minimumTrackTintColor = tintColor.withAlphaComponent(0.6)
        slider.maximumTrackTintColor = tintColor.withAlphaComponent(0.15)
        slider.value = value
        //        slider.value = value.rounded(.toNearestOrEven)    // if stepped
        slider.maximumValue = Float(maxValue)
        
        // create slide thumb
        let thumbView = UIView()
        thumbView.backgroundColor = tintColor
        thumbView.layer.masksToBounds = false
        thumbView.frame = CGRect(x: 0, y: thumbDiameter / 2, width: thumbDiameter, height: thumbDiameter)
        thumbView.layer.cornerRadius = CGFloat(thumbDiameter / 2)
        
        // render thumbView as image, then set it as the thumb view image
        let imageRenderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        let thumbImage = imageRenderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
        slider.setThumbImage(thumbImage, for: .normal)
        
        // set drop shadow appearance
        slider.layer.shadowColor = UIColor.black.cgColor
        slider.layer.shadowOpacity = 0.2
        slider.layer.shadowOffset = CGSize(width: 0, height: 3)
        slider.layer.shadowRadius = 5
        
        // set slider’s events be continuous updated by value, triggers the
        // associated target’s action method repeatedly, as user moves thumb
        slider.isContinuous = true
    }
    
    func makeUIView(context: Context) -> UXSlider {
        
        let slider = UXSlider(frame: .zero)
        
        // set dragging event
        slider.dragBegan = dragBegan
        slider.dragMoved = dragMoved
        slider.dragEnded = dragEnded
        
        // apply slider customization
        customizeSlider(slider)
        
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        
        return slider
    }
    
    func updateUIView(_ slider: UXSlider, context: Context) {
        // Coordinating data between UIView and SwiftUI view
        customizeSlider(slider)
        
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
    }
    
    func makeCoordinator() -> SwiftUISlider.Coordinator {
        Coordinator(value: $value)
    }
}
