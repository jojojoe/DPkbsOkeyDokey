//
//  DPkbsEffectView.swift
//  DPbsOkeyDokey
//
//  Created by JOJO on 2022/4/20.
//

import UIKit
import Comets
import Pulsator
import AVFAudio

class DPkbsEffectView: UIView, AVAudioPlayerDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContentView() {
        updateContentBgColor(color: .black)
//        addRainyEffect()
//        addRipple2Effect()
//        addRipple1Effect()
        
//        addWaterPointWaveEffect()
//        setupSiriWaveEffect()
//        setupLineWaveEffect()
//        setupBreathEffect()
//        setupSpacesStarLineEffect()
    }
    
}

extension DPkbsEffectView {
    
}

extension DPkbsEffectView {
    func clearContentEffect() {
        self.removeSubviews()
    }
    
    func updateContentBgColor(color: UIColor) {
        backgroundColor = color
    }

    
}

extension DPkbsEffectView {
    
    func addRainyEffect() {
        let rainyEffectView = RainyEffecView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height))
        rainyEffectView.adhere(toSuperview: self)
        rainyEffectView.didBeginRefresh()
    }
    
    func addRipple2Effect() {
        let rippleEffectView = RippleEffectView()
        
//        rippleEffectView.tileImage = UIImage(named: "sliderPoint")
        rippleEffectView.tileImage = UIImage(named: "cell-image")
        rippleEffectView.magnitude = 0.2
        rippleEffectView.cellSize = CGSize(width:20, height:20)
        rippleEffectView.rippleType = .heartbeat
        self.addSubview(rippleEffectView)
        
        //Example, simple tile image customization
        
        rippleEffectView.tileImageCustomizationClosure = { rows, columns, row, column, image in
            let newImage = image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
          UIGraphicsBeginImageContextWithOptions(image.size, false, newImage.scale)
          
          let xmiddle = (columns % 2 != 0) ? columns/2 : columns/2 + 1
          let ymiddle = (rows % 2 != 0) ? rows/2 : rows/2 + 1
          
          let xoffset = abs(xmiddle - column)
          let yoffset = abs(ymiddle - row)
          
          UIColor(hue: 206/360.0, saturation: 1, brightness: 0.95, alpha: 1).withAlphaComponent(1.0 - CGFloat((xoffset + yoffset)) * 0.1).set()
          
          newImage.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: newImage.size.height));
          if let titledImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return titledImage
          }
          UIGraphicsEndImageContext()
          return image
        }
        
        rippleEffectView.setupView()
        rippleEffectView.animationDidStop = { [unowned self] in
            //Each time animation sequency finished this callback will change background of the wrapper view.
            UIView.animate(withDuration: 1.5, animations: {
                rippleEffectView.backgroundColor = UIColor.random.withAlphaComponent(0.25)
            })
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            rippleEffectView.startAnimating()
        }
    }
    
    func addRipple1Effect() {
        let rippleEffectView = RippleEffectView()
        
//        rippleEffectView.tileImage = UIImage(named: "sliderPoint")
        rippleEffectView.tileImage = UIImage(named: "cell-image")
        rippleEffectView.magnitude = 0.2
        rippleEffectView.cellSize = CGSize(width:20, height:20)
        rippleEffectView.rippleType = .heartbeat
        self.addSubview(rippleEffectView)
        
        //Example, simple tile image customization
        
        rippleEffectView.tileImageCustomizationClosure = {rows, columns, row, column, image in
            if (row % 2 == 0 && column % 2 == 0) {
                let newImage = image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                UIGraphicsBeginImageContextWithOptions(image.size, false, newImage.scale)
                UIColor.random.set()
                newImage.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
                
                if let titledImage = UIGraphicsGetImageFromCurrentImageContext() {
                    UIGraphicsEndImageContext()
                    return titledImage
                }
                UIGraphicsEndImageContext()
            }
            return image
        }
        
        rippleEffectView.setupView()
        rippleEffectView.animationDidStop = { [unowned self] in
            //Each time animation sequency finished this callback will change background of the wrapper view.
            UIView.animate(withDuration: 1.5, animations: {
                rippleEffectView.backgroundColor = UIColor.random.withAlphaComponent(0.25)
            })
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            rippleEffectView.startAnimating()
        }
        
    }
    
    func addWaterPointWaveEffect() {
        let pulsaV = UIImageView(frame: CGRect(x: self.width/2, y: self.height/2, width: 10, height: 10))
        pulsaV.adhere(toSuperview: self)
            .image("")
            .backgroundColor(.clear)
        
        
        let pulsator = Pulsator()
        pulsaV.layer.superlayer?.insertSublayer(pulsator, below: pulsaV.layer)
        pulsator.numPulse = 8
        pulsator.radius = CGFloat(140)
        pulsator.animationDuration = 5.0
        pulsator.backgroundColor = UIColor.white.cgColor
        pulsator.position = pulsaV.layer.position
        pulsator.start()
        
        
    }
    
    func setupSiriWaveEffect() {
        let siriWave = SiriWaveView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        siriWave.adhere(toSuperview: self)

        var ampl: CGFloat = 0.8
        let speed: CGFloat = 0.25

        func modulate() {
            ampl = Lerp.lerp(ampl, 1.5, speed)
            siriWave.update(ampl * 5)
            debugPrint("ampli = \(ampl)")
        }

        _ = Timeout.setInterval(TimeInterval(speed)) {
            DispatchQueue.main.async {
                modulate()
            }
        }

    }
    
    func setupLineWaveEffect() {
        let waveView = SwiftyWaveView()
        waveView.adhere(toSuperview: self)
        waveView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        waveView.start()
    }
    
    func setupBreathEffect() {
        let breathBgV = BreatheView()
        breathBgV.adhere(toSuperview: self)
        breathBgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
    }
    
    func setupSpacesStarLineEffect() {
        
        let spaceBgView = UIView()
        spaceBgView.adhere(toSuperview: self)
            .backgroundColor(.clear)
        spaceBgView.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        
        addSubview(spaceBgView)
        
        // Customize your comet
        let width = self.bounds.width
        let height = self.bounds.height
        let comets = [
            Comet(startPoint: CGPoint(x: 100, y: 0),
                  endPoint: CGPoint(x: 0, y: 100),
                  lineColor: UIColor.white.withAlphaComponent(0.0),
                  cometColor: UIColor.white),
            Comet(startPoint: CGPoint(x: 0.4 * width, y: 0),
                  endPoint: CGPoint(x: width, y: 0.8 * width),
                  lineColor: UIColor.white.withAlphaComponent(0.0),
                  cometColor: UIColor.white),
            Comet(startPoint: CGPoint(x: 0.8 * width, y: 0),
                  endPoint: CGPoint(x: width, y: 0.2 * width),
                  lineColor: UIColor.white.withAlphaComponent(0.2),
                  cometColor: UIColor.white),
            Comet(startPoint: CGPoint(x: width, y: 0.2 * height),
                  endPoint: CGPoint(x: 0, y: 0.25 * height),
                  lineColor: UIColor.white.withAlphaComponent(0.0),
                  cometColor: UIColor.white),
            Comet(startPoint: CGPoint(x: 0, y: height - 0.8 * width),
                  endPoint: CGPoint(x: 0.6 * width, y: height),
                  lineColor: UIColor.white.withAlphaComponent(0.0),
                  cometColor: UIColor.white),
            Comet(startPoint: CGPoint(x: width - 100, y: height),
                  endPoint: CGPoint(x: width, y: height - 100),
                  lineColor: UIColor.white.withAlphaComponent(0.0),
                  cometColor: UIColor.white),
            Comet(startPoint: CGPoint(x: 0, y: 0.8 * height),
                  endPoint: CGPoint(x: width, y: 0.75 * height),
                  lineColor: UIColor.white.withAlphaComponent(0.0),
                  cometColor: UIColor.white)
        ]
        
        // draw track and animate
        for comet in comets {
            spaceBgView.layer.addSublayer(comet.drawLine())
            spaceBgView.layer.addSublayer(comet.animate())
        }
        
        //
        let starView = SSStarSpaceView.init(frame: bounds)
        starView.backgroundColor(.clear)
        spaceBgView.addSubview(starView)
    }
}




