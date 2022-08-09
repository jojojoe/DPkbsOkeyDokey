//
//  SSStarSpaceView.swift
//  DPbsOkeyDokey
//
//  Created by nataliya on 2022/4/18.
//

import Foundation
import UIKit

class SSStarSpaceView: UIView {
    
    // 透明度 0->1  大->小
    var birthRate : CGFloat = 2
    var lifetime : CGFloat = 20
    var cellScale : CGFloat = 0.5
    var spinMult : CGFloat = 0.2 // 自转速度
    var alphaSpeed : CGFloat = 0.5
    var scaleSpeed: CGFloat = 0.0
    
    var starImage: UIImage? = UIImage(named: "sliderPoint") // 星星的样式图片
    var starColor: UIColor = UIColor.white  // 星星颜色
    var bgColor: UIColor = UIColor.black  // 背景颜色
    
    
    
    var emitterLayer: CAEmitterLayer {
        get {
            return layer as! CAEmitterLayer
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupEmitterLayer()
        
        setupStyle_1()
        setupStarEmitter(cellName: "star1")
        setupStyle_2()
        setupStarEmitter(cellName: "star2")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override class var layerClass: AnyClass {
        return CAEmitterLayer.self
    }
}

//MARK: 粒子显示风格
extension SSStarSpaceView {
    // setup 透明度 0->1  大->小
    func setupStyle_1() {
        birthRate = 1
        lifetime = 20
        cellScale = 0.5 // cell size 初始值
        spinMult = 0.2 // 自转速度
        alphaSpeed = 0.5
        scaleSpeed =  -cellScale / lifetime
        starColor = UIColor.white.withAlphaComponent(0.0)
    }
    
    // setup 透明度 1->0  小->大
    func setupStyle_2() {
        birthRate = 3
        lifetime = 20
        cellScale = 0.0 // cell size 初始值
        spinMult = 0.3 // 自转速度
        alphaSpeed = -1.0 / lifetime
        scaleSpeed =  0.5 / lifetime
        starColor = UIColor.white.withAlphaComponent(1.0)
    }
    
}




extension SSStarSpaceView {
    
    func setupView() {
        backgroundColor = bgColor
    }
    
    func setupEmitterLayer() {
        emitterLayer.emitterShape = .rectangle
        emitterLayer.emitterMode = .surface
        emitterLayer.renderMode = .unordered
        emitterLayer.emitterSize = bounds.size
        emitterLayer.emitterPosition = CGPoint.init(x: bounds.size.width / 2, y: bounds.size.height / 2)
        
        
        
        
    }
    
    func setupStarEmitter(cellName: String) {
        
        let starFlake = CAEmitterCell()
        starFlake.name = cellName //"star"
        // 粒子参数的速度乘数因子
        starFlake.birthRate = Float(birthRate)//(birthRate > 0 ? Float(birthRate) : 10.0)
        // 粒子生命周期
        starFlake.lifetime = Float(lifetime)//(lifetime > 0 ? Float(lifetime) :20)
        // 粒子旋转角度
        starFlake.spinRange = -spinMult * CGFloat(Double.pi)
        // 获取图片
        starFlake.contents = starImage?.cgImage
        // 设置雪花形状的粒子的颜色
        starFlake.color = starColor.cgColor
        // 透明度变化速度
        starFlake.alphaSpeed = Float(alphaSpeed)
        // 尺寸
        starFlake.scale = cellScale
        // 尺寸变化范围
        starFlake.scaleSpeed = scaleSpeed
        
        // 添加粒子
//        self.emitterLayer.emitterCells = [starFlake]
        debugPrint("*** self.emitterLayer.emitterCells = \(String(describing: self.emitterLayer.emitterCells))")
        if self.emitterLayer.emitterCells == nil || self.emitterLayer.emitterCells?.count == 0 {
           self.emitterLayer.emitterCells = [starFlake]
        } else {
            self.emitterLayer.emitterCells?.append(starFlake)
        }
        
    }
}
 

 
