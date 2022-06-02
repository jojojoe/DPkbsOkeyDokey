//
//  DPkbsHorScrollPreview.swift
//  DPbsOkeyDokey
//
//  Created by JOJO on 2022/4/19.
//

import UIKit
import SwifterSwift
import AttributedString

class ASTextAutoScrollView: UIView {
    
    var textLabel = UILabel()
    
    
    var scrollView: ASAutoScrollView = ASAutoScrollView.init(frame: CGRect.zero, viewsList: [])
    
    
    var sysString: String = "SUPER IDOL LED!" {
        didSet {
            updateContentLabel()
        }
    }
    var sysFontFileName: String = "AppleSDGothicNeo-Bold" {
        didSet {
            updateContentLabel()
        }
    }
    var sysTextColor: UIColor = UIColor.white {
        didSet {
            updateContentLabel()
        }
    }
//    var sysCanvasColor: UIColor = UIColor.black {
//        didSet {
//            backgroundColor = sysCanvasColor
//        }
//    }
    var sysFontPointSize: CGFloat = 100 {
        didSet {
            updateContentLabel()
        }
    }
    var sysSpeed: CGFloat = 0.01 {
        didSet {
            scrollView.undateScrollSpeed(speed: sysSpeed)
        }
    }
    // 文字外发光
    var sysOutlight: Bool = false {
        didSet {
            updateContentLabel()
        }
    }
    // 文字渐隐渐显动画
    var sysTextFlash: Bool  = false {
        didSet {
            updateContentFlashAlphaAnimation(isOn: sysTextFlash)
            
        }
    }
    
    // 文字缩放动画
    var sysTextScale: Bool  = false {
        didSet {
            updateContentScaleAnimation(isOn: sysTextScale)
        }
    }
    // 文字绕中心点上下旋转动画
    var sysTextShake: Bool  = false {
        didSet {
            updateContentShakeAnimation(isOn: sysTextShake)
        }
    }
    // 文字描边
    var sysTextStroke: Bool = false {
        didSet {
            updateContentLabel()
        }
    }
    
    // 抖音
//    var sysTextDouyin: Bool = false {
//        didSet {
//            updateContentDouyinEffect(isOn: sysTextDouyin)
//        }
//    }
    
    // 倒影
    var sysReflectionEffect: Bool = false {
        didSet {
            updateContentReflectionEffect(isOn: sysReflectionEffect)
        }
    }
    // 叠影
    var sysDoubleLayer: Bool = false {
        didSet {
            updateContentDoubleLayerEffect(isOn: sysDoubleLayer)
        }
    }
    // 倾斜
    var sysSlantEffect: Bool = false {
        didSet {
            updateContentSlantEffect(isOn: sysSlantEffect)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupDefautScrollStatus()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .clear
    }

}

extension ASTextAutoScrollView {
    func setupDefautScrollStatus() {
 
        textLabel = UILabel.init(text: sysString)
        let scrollFrame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        scrollView = ASAutoScrollView.init(frame: scrollFrame, viewsList: [textLabel])
        addSubview(scrollView)
        
        textLabel.clipsToBounds = false
        textLabel.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        
        updateContentLabel()
    }
}

extension ASTextAutoScrollView {
    
    func resetupDefaultStatus() {
        sysString = "SUPER IDOL LED!"
        sysFontFileName = "AppleSDGothicNeo-Bold"
        sysTextColor = UIColor.white
        sysFontPointSize = 100
//        sysSpeed = 0.01
        sysOutlight = false
        sysReflectionEffect = false
        sysDoubleLayer = false
        sysSlantEffect = false
        sysTextStroke = false
        sysTextScale = false
        sysTextShake = false
        sysTextFlash = false
        updateContentLabel()
    }
    
    func updateContentLabel() {
       
        
        let font = UIFont(name: sysFontFileName, size: sysFontPointSize) ?? UIFont.systemFont(ofSize: sysFontPointSize)
        
        var originalAttri: ASAttributedString = "\(sysString, .font(font), .foreground(sysTextColor), .paragraph(.alignment(.center)))"
        
        if sysOutlight {
            let shadow = NSShadow.init(offset: CGSize.zero, radius: 10, color: UIColor.red)
            originalAttri = "\(sysString, .font(font), .foreground(sysTextColor), .paragraph(.alignment(.center)), .shadow(shadow))"
        } else {
            
        }
        
        if sysTextStroke {
            originalAttri = "\(sysString, .font(font), .foreground(UIColor.clear), .paragraph(.alignment(.center)), .stroke(-4, color: sysTextColor))"
        }

        textLabel.attributed.text = originalAttri
         
        
        let size = originalAttri.value.boundingRect(with: CGSize.init(width: CGFloat.infinity, height: CGFloat.infinity), options: .usesLineFragmentOrigin, context: nil).size //?? CGSize.zero
        
        var labelWidth: CGFloat = size.width + 200
        
        if size.width < frame.width {
            labelWidth = frame.width
        }
        
        textLabel.frame = CGRect.init(x: 0, y: 0, width: labelWidth, height: frame.height)
        
        // 文字真实高度
        scrollView.scrollConfig.contentRealHeight = size.height
        // 文字内容
        scrollView.scrollConfig.contentTextString = sysString
        // 文字字体
        scrollView.scrollConfig.contentTextFont = font
        
        // 更新scroll 的内容
        scrollView.updateContentString(viewsList: [textLabel])
        
    }
    
    func updateContentFlashAlphaAnimation(isOn: Bool) {
        // 渐隐渐显
        scrollView.addContentAlphaAnimation(isAdd: isOn)
        // 倒影效果
//        scrollView.addContentReflectionLayer(isOn: isOn)
        // 叠影效果
//        scrollView.addContentDoubleLayer(isOn: isOn)
        // 倾斜效果
//        scrollView.addContentSlant(isOn: isOn)
        
    }
    
    // 缩放动画
    func updateContentScaleAnimation(isOn: Bool) {
        scrollView.addScaleAnimal(isAdd: isOn)
    }
    // 文字绕中心点上下旋转动画
    func updateContentShakeAnimation(isOn: Bool) {
        scrollView.addShakeAnimal(isAdd: isOn)
    }
    // 抖音效果
//    func updateContentDouyinEffect(isOn: Bool) {
//        scrollView.addDouyinEffect(isOn: isOn)
//    }
    
    // 倒影效果
    func updateContentReflectionEffect(isOn: Bool) {
        scrollView.addContentReflectionLayer(isOn: isOn)
    }
    
    // 叠影效果
    func updateContentDoubleLayerEffect(isOn: Bool) {
        scrollView.addContentDoubleLayer(isOn: isOn)
    }
    
    // 倾斜效果
    func updateContentSlantEffect(isOn: Bool) {
        scrollView.addContentSlant(isOn: isOn)
    }
    
    func resetupDefaultDisplay() {
        sysFontFileName = "ProggyCleanSZ-1.ttf"
        sysFontPointSize = 100
        sysTextColor = UIColor.white
//        sysCanvasColor = UIColor.black
        sysSpeed = 0.05
        sysOutlight = false
        sysTextFlash = false
        sysTextScale = false
        sysDoubleLayer = false
        sysReflectionEffect = false
        sysTextStroke = false
        sysSlantEffect = false
        //TODO: 更改 UI 状态
        
    }
}
 





