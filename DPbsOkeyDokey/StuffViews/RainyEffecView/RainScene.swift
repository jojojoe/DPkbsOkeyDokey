//
//  RainScene.swift
//  DPbsOkeyDokey
//
//  Created by nataliya on 2022/5/26.
//

import Foundation
import UIKit
import SpriteKit
import SwiftUI

final class RainScene: SKScene {

    var particles:SKEmitterNode!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        setup()
    }
    
    func setup(){
//        let bundle = Bundle(for: type(of: self))
//        let bundleName = bundle.infoDictionary!["CFBundleName"] as! String
        let path = Bundle.main.path(forResource: "rain", ofType: "sks")
        do {
            
            if let path_m = path, let data = NSData(contentsOfFile: path_m) as? Data {
                
                let p = try NSKeyedUnarchiver.unarchivedObject(ofClass: SKEmitterNode.self, from: data)
                
                if let p_m = p, let texture = UIImage(named: "spark.png") {
                    p_m.particleTexture = SKTexture(image: texture)
                    particles = p_m
                    layout()
                    addChild(particles)
                }
            }

        } catch {
            
        }
        
        
    }
    
    func layout(){
        particles.position = CGPoint(x: size.width/2, y: size.height)
    }
}
