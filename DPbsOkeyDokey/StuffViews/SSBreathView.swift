//
//  SSBreathView.swift
//  DPbsOkeyDokey
//
//  Created by nataliya on 2022/4/24.
//

import Foundation
import UIKit

class BreatheView: UIView {
    
    
    private var containerLayer: CALayer?
    private var containerSize: CGFloat = 120.0
    private let animationDuration: TimeInterval = 4.0
    private let defaultColor: CGColor = {
        let blue = UIColor(red: 76/255, green: 175/255, blue: 247/255, alpha: 1)
        return blue.withAlphaComponent(0.7).cgColor
    }()
    
    private var circles: [Circle] = []
      
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if containerLayer == nil {
            let container = setupContainer(size: containerSize)
            layer.addSublayer(container)
            containerLayer = container
            rotateContainer()
            
        }
    }
    
    private func setupContainer(size: CGFloat) -> CALayer {
        let container = CAShapeLayer()
        let rect = CGRect(x: 0, y: 0,
                            width: 2.0 * size,
                            height: 2.0 * size)
        
        container.path = UIBezierPath(rect: rect).cgPath
        container.position = CGPoint(x: frame.midX - size, y: frame.midY - size)
        
        let totalCircles = 6
            
        for i in 1...totalCircles {
            
            let circle = Circle(radius: containerSize / 2,
                                index: i,
                                color: defaultColor)
            circle.animateWith(duration: animationDuration)
            circles.append(circle)
            container.addSublayer(circle)
        }
        container.fillColor = UIColor.clear.cgColor
        return container
    }
    
    
    private func rotateContainer() {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = animationDuration
        animation.fromValue = layer.transform
        animation.toValue = CATransform3DMakeRotation(.pi, 0, 0, 1)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        layer.add(animation, forKey: "rotate")
    }
    
    
    func resetColor() {
        updateCirclesColor(to: defaultColor)
    }
    
    
    func updateCirclesColor(to color: CGColor) {
        for circle in circles {
            circle.updateColor(to: color)
        }
    }
    
    
    
    
    
}



class Circle: CAShapeLayer {
    
    private let centerOffset: CGFloat = 0.855
    private let minimumScale: CGFloat = 0.25
    private var index: Int = 0
    private var side: CGFloat = 0
    private var color: CGColor = UIColor.clear.cgColor
    var colorsList: [String] = ["#C83D3D", "#D8B021", "#41C6A6", "#6F80DC", "#8D46B8"]
    var currentColorIndex: Int = 0
    var timer: Timer?
    
    init(radius: CGFloat, index: Int, color: CGColor) {
        self.side = 2.0 * radius
        self.index = index
        self.color = color
        super.init()
        
        initialSetup()
    }
    
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("Cannot initialize from storyboard")
    }
    
    deinit {
        if let timer_m = timer {
            timer_m.invalidate()
            timer = nil
        }
    }
    
    override func removeFromSuperlayer() {
        super.removeFromSuperlayer()
        if let timer_m = timer {
            timer_m.invalidate()
            timer = nil
        }
    }
    
    private func initialSetup() {
        let rect = CGRect(x: 0, y: 0,
                          width: side,
                          height: side)
        
        self.transform = getTransform(for: centerOffset)
        self.fillColor = color
        self.path = UIBezierPath(roundedRect: rect, cornerRadius: side / 2).cgPath
        self.position = getPosition(for: centerOffset)
        self.compositingFilter = "linearDodgeBlendMode"
    }
    
    
    private func getTransform(for centerOffset: CGFloat) -> CATransform3D {
        let offset: CGFloat = .pi / 4
        let rotation: CGFloat = ((.pi * 2) / 6) * CGFloat(index)
        
        let rotationPoint = CGPoint(x: side, y: side)
        let center = CGPoint(x: side * centerOffset, y: side * centerOffset)
        let scale = getScale(for: centerOffset)
        
        var transform: CATransform3D = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, rotationPoint.x-center.x, rotationPoint.y-center.y, 0.0)
        transform = CATransform3DScale(transform, scale, scale, scale)
        transform = CATransform3DRotate(transform, rotation - offset, 0.0, 0.0, 1.0)
        transform = CATransform3DTranslate(transform, center.x-rotationPoint.x, center.y-rotationPoint.y, 0.0)
        
        return transform
    }
    
    
    private func getScale(for offset: CGFloat) -> CGFloat {
        let range = self.centerOffset - 0.5
        let factor = (1 - minimumScale) / range
        let diff = offset - 0.5
        let scale = minimumScale + (diff * factor)
        return scale
    }
    
    
    private func getPosition(for centerOffset: CGFloat) -> CGPoint {
        CGPoint(x: side * centerOffset, y: side * centerOffset)
    }
    
    
    private func createRotateAnimation(duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = duration
        animation.fromValue = transform
        animation.toValue = getTransform(for: 0.5)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        add(animation, forKey: "rotate")
    }
    
    
    private func createPositionAnimation(duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.position))
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = duration
        animation.fromValue = position
        animation.toValue = getPosition(for: 0.5)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        add(animation, forKey: "position")
    }
     
    
    func animateWith(duration: TimeInterval) {
        createRotateAnimation(duration: duration)
        createPositionAnimation(duration: duration)
        addColorAnimation(duration: duration)
    }
    
    
    func updateColor(to color: CGColor) {
        setValue(color, forKey: "fillColor")
    }
     
    func addColorAnimation(duration: TimeInterval) {
        
//        timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { timer in
//            let colorStr = self.colorsList[self.currentColorIndex]
//            self.currentColorIndex += 1
//            if self.currentColorIndex >= self.colorsList.count {
//                self.currentColorIndex = 0
//            }
//            let color = UIColor(hexString: colorStr) ?? UIColor.white
//            self.updateColor(to: color.cgColor)
//        }
    }
    
}

 
