//
//  ScreenBrightnessManager.swift
//  DPbsOkeyDokey
//
//  Created by JOJO on 2022/4/24.
//

import Foundation
import UIKit

class ScreenBrightnessManager: NSObject {
    
    static var defaultShared  = ScreenBrightnessManager()
    
    var currentLight: CGFloat = 0
    
    var blingTimeInterval = 0.2
    
    var blingTimer: Timer?
    
    var isBling: Bool = false
    
    override init() {
        super.init()
        
    }
    
    
    
    
    
    
}

// 闪烁 屏幕
extension ScreenBrightnessManager {
    func openBlingBlingActionStatus(isOpen: Bool) {
        ScreenBrightnessManager.defaultShared.currentLight = UIScreen.main.brightness
        if isOpen {
            addBlingBlingTimer()
        } else {
            removeBlingTimer()
            screenBrightnessDefaultStatus()
        }
    }
    
    func addBlingBlingTimer() {
        
        blingTimer = Timer.scheduledTimer(timeInterval: blingTimeInterval, target: self, selector: #selector(controlBlingBlingAction), userInfo: nil, repeats: true)
        
    }

    func removeBlingTimer()  {
        
        blingTimer?.invalidate()
        blingTimer = nil
    }
    
    @objc func controlBlingBlingAction() {
        isBling = !isBling
        if isBling {
            debugPrint("bling bling bling Open ")
            UIScreen.main.brightness = 1.0
        } else {
            debugPrint("bling bling bling Close ")
            UIScreen.main.brightness = 0.0
        }
    }
    
    func screenBrightnessDefaultStatus() {
        UIScreen.main.brightness = ScreenBrightnessManager.defaultShared.currentLight
    }
    
    func changeBrightnessValue(blingValue: Float) {
        UIScreen.main.brightness = CGFloat(blingValue)
    }
}


// 正弦函数 变化
extension ScreenBrightnessManager {
    func openSinFlashActionStatus(isOpen: Bool) {
        
        let manager = SASinWaveValueManager.defaultShared
        manager.displayLinkSinValueBlock = {[weak self] sinValue in
            guard let `self` = self else {return}
            self.changeBrightnessValue(blingValue: sinValue)
        }
        
        if isOpen {
            ScreenBrightnessManager.defaultShared.currentLight = UIScreen.main.brightness
            SASinWaveValueManager.defaultShared.addDisplayLink()
        } else {
            SASinWaveValueManager.defaultShared.removeDisplayLink()
            screenBrightnessDefaultStatus()
        }
    }
    
}


class SASinWaveValueManager: NSObject {
    
    static var defaultShared  = SASinWaveValueManager()
    
    lazy var waveDisplaylink = CADisplayLink()
    
    var offsetX: Float = 0
    var perLenght: Float = 0.05
    
    var displayLinkSinValueBlock:((_ sinYValue: Float)->Void)?
    
    
    override init() {
        super.init()
        setupDisaplayLink()
    }
    
    func setupDisaplayLink() {
        waveDisplaylink = CADisplayLink(target: self, selector: #selector(getCurrentWave))
        
    }
    
    @objc
    func getCurrentWave() {
        offsetX += perLenght
        let yAxis = (sin (offsetX) * 0.5) + 0.5
        displayLinkSinValueBlock?(yAxis)

    }
    
    func addDisplayLink() {
         waveDisplaylink.add(to: RunLoop.current, forMode: .common)
    }
    
    func removeDisplayLink() {
        waveDisplaylink.remove(from: RunLoop.current, forMode: .common)
         
    }
    
    
}


