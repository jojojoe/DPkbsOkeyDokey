//
//  RainyEffecView.swift
//  DPbsOkeyDokey
//
//  Created by JOJO on 2022/5/26.
//

import Foundation
import UIKit
import SpriteKit

class RainyEffecView: UIView {
    
    private var backgroundView: SKView!
    var bgColor = UIColor.clear//(red: 85.0/255.0, green: 74.0/255.0, blue: 99.0/255.0, alpha: 0)
    private var scene: RainScene?
    private var thresholdValue: CGFloat = 100.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        backgroundView = SKView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        backgroundView.backgroundColor = .clear
        addSubview(backgroundView)
        
        backgroundView.showsFPS = false
        backgroundView.showsNodeCount = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        backgroundView.ignoresSiblingOrder = true
        
        scene = RainScene(size: backgroundView.bounds.size)
        // Configure the view.
        scene?.backgroundColor = bgColor
        /* Set the scale mode to scale to fit the window */
        scene?.scaleMode = .aspectFill
        scene?.particles.particleBirthRate = 0
        backgroundView.presentScene(scene)
         
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        backgroundView.frame = bounds
        scene?.size = bounds.size
        scene?.layout()
    }
    
    func didBeginRefresh() {
        scene?.particles.particleBirthRate = 766
        scene?.particles.resetSimulation()
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        CATransaction.commit()
         
    }
    
    func willEndRefresh() {
        scene?.particles.particleBirthRate = 0
        scene?.particles.resetSimulation()
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        CATransaction.commit()
         
    }
}
