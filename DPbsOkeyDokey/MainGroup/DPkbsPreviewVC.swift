let playScrollBtn = UIButton()//
//  DPkbsPreviewVC.swift
//  DPbsOkeyDokey
//
//  Created by JOJO on 2022/4/18.
//

import UIKit

class DPkbsPreviewVC: UIViewController, UITextFieldDelegate {
    
    let settingBtn = UIButton()
    let textBgV = UIView()
    var effectBgV: DPkbsEffectView!
    var toolView = UIView()
    let contentTextFeid = UITextField()
    let sendBtn = UIButton()
    let lockBtn = UIButton()
    let flashBtn = UIButton()
    let fontBtn = UIButton()
    let bgEffectBtn = UIButton()
    let bottomBar = UIView()
    let playScrollBtn = UIButton()
    let hideButton = UIButton()
    let bottomMaskV = UIView()
    var currentStyleItem: ODStyleItem?
    let fontBar = DPkbsFontBar()
    let bgEffectBar = DPkbsBgEffectBar()
    var viewDidLayoutOnce = Once()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor(.white)
        view.clipsToBounds()
        registKeyboradNotification()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        
        viewDidLayoutOnce.run {
            self.setupAdjustControV()
        }
    }
    
    func setupView() {
        setupContentV()
        setupBottomToolBar()
        
        
        //
        
        settingBtn.image(UIImage(named: "i_setting"))
            .adhere(toSuperview: view)
        settingBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(4)
            $0.width.height.equalTo(44)
        }
        settingBtn.addTarget(self, action: #selector(settingBtnClick(sender: )), for: .touchUpInside)
        
        //
        lockBtn.addTarget(self, action: #selector(lockBtnClick(sender: )), for: .touchUpInside)
        lockBtn.adhere(toSuperview: view)
            .image(UIImage(named: "i_unlock_open"), .normal)
            .image(UIImage(named: "i_unlock_lock"), .selected)
        lockBtn.snp.makeConstraints {
            $0.centerY.equalTo(settingBtn.snp.centerY)
            $0.right.equalToSuperview().offset(-24)
            $0.width.height.equalTo(44)
        }
        
        //
        
        bottomMaskV.backgroundColor(UIColor(hexString: "#333333")!)
            .adhere(toSuperview: view)
        bottomMaskV.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    

}

extension DPkbsPreviewVC {
    
    func registKeyboradNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            self.updateToolBtnsShowStatus(isShow: false)
        }
        
        debugPrint(keyboardHeight)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            self.updateToolBtnsShowStatus(isShow: true)
            self.toolView
                .adhere(toSuperview: self.view)
            self.toolView.snp.remakeConstraints {
                $0.left.right.top.equalTo(self.bottomBar)
                $0.height.equalTo(54)
            }
        }
        debugPrint(keyboardHeight)
    }
}

extension DPkbsPreviewVC {
    func updateToolBtnsShowStatus(isShow: Bool) {
        if isShow {
            playScrollBtn.isHidden = false
            flashBtn.isHidden = false
            fontBtn.isHidden = false
            bgEffectBtn.isHidden = false
            sendBtn.isHidden = true
            hideButton.isHidden = true
        } else {
            playScrollBtn.isHidden = true
            flashBtn.isHidden = true
            fontBtn.isHidden = true
            bgEffectBtn.isHidden = true
            sendBtn.isHidden = false
            hideButton.isHidden = false
        }
    }
}

extension DPkbsPreviewVC {
    
    func setupContentV() {
        //
        let screenFrame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height)
        
        //
        effectBgV = DPkbsEffectView(frame: screenFrame)
        effectBgV.adhere(toSuperview: view)
        
        //
        textBgV.frame = screenFrame
        textBgV.adhere(toSuperview: view)
            .backgroundColor(.clear)
         
        
        let textScrollView = ASTextAutoScrollView.init(frame: self.view.bounds)
        textScrollView.adhere(toSuperview: textBgV)
        textScrollView.scrollView.tapClickViewActionBlock = {
            [weak self] in
            guard let `self` = self else {return}
            if self.contentTextFeid.isFirstResponder {
                self.contentTextFeid.resignFirstResponder()
            }
        }
        
        
    }
    
    func setupAdjustControV() {
        
        fontBar.adhere(toSuperview: view)
            .backgroundColor(UIColor(hexString: "#333333")!)
        fontBar.frame = CGRect(x: 0, y: bottomBar.frame.minY, width: self.view.frame.width, height: 65)
        fontBar.fontDidSelectBlock = {
            [weak self] fontNameStr in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateScreenContent_font(fontItem: fontNameStr)
            }
        }
        fontBar.isHidden = true
        
        //
        bgEffectBar.adhere(toSuperview: view)
            .backgroundColor(UIColor(hexString: "#333333")!)
        bgEffectBar.frame = CGRect(x: 0, y: bottomBar.frame.minY, width: self.view.frame.width, height: 65)
        bgEffectBar.didSelectBlock = {
            [weak self] bgStyleItem in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateBgEffect(styleItem: bgStyleItem)
            }
        }
        bgEffectBar.isHidden = true
        //
        view.bringSubviewToFront(bottomBar)
        view.bringSubviewToFront(toolView)
        view.bringSubviewToFront(bottomMaskV)
    }
    
    func setupBottomToolBar() {
        
        bottomBar.adhere(toSuperview: view)
        bottomBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-54)
        }
        bottomBar.backgroundColor(.clear)
         
        //
        toolView
            .adhere(toSuperview: view)
            .backgroundColor(UIColor(hexString: "#333333")!)
        toolView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 54)
        toolView.snp.makeConstraints {
            $0.left.right.top.equalTo(bottomBar)
            $0.height.equalTo(54)
        }
        //
        contentTextFeid.delegate = self
        contentTextFeid.textAlignment = .center
        contentTextFeid.borderStyle = .roundedRect
        contentTextFeid.textColor = .black
        contentTextFeid.backgroundColor = .white
        contentTextFeid.inputAccessoryView = toolView
        contentTextFeid.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14)
        toolView.addSubview(contentTextFeid)
        
        contentTextFeid.placeholder = "内容..."
        contentTextFeid.clearButtonMode = .whileEditing
        contentTextFeid.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-20)
            $0.width.equalTo(300)
            $0.height.equalTo(34)
        }
        contentTextFeid.layer.cornerRadius = 6
        //
        sendBtn.isHidden = true
        sendBtn.addTarget(self, action: #selector(sendBtnClick(sender: )), for: .touchUpInside)
        sendBtn.adhere(toSuperview: toolView)
            .image(UIImage(named: "i_send"))
        sendBtn.snp.makeConstraints {
            $0.centerY.equalTo(contentTextFeid.snp.centerY)
            $0.left.equalTo(contentTextFeid.snp.right).offset(10)
            $0.width.height.equalTo(36)
        }
        //
        hideButton.isHidden = true
        hideButton
            .adhere(toSuperview: toolView)
            .image(UIImage(named: "i_keyborad"))
            
        hideButton.addTarget(self, action: #selector(hideButtonClick(sender:)), for: .touchUpInside)
        toolView.addSubview(hideButton)
        hideButton.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.right.equalTo(contentTextFeid.snp.left).offset(-10)
            $0.centerY.equalToSuperview()
        }
        
        //
        
        playScrollBtn.adhere(toSuperview: toolView)
            .image(UIImage(named: "i_pause"), .normal)
            .image(UIImage(named: "i_play"), .selected)
        playScrollBtn.addTarget(self, action: #selector(scrollStatusBtnClick(sender: )), for: .touchUpInside)
        playScrollBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
            $0.width.height.equalTo(40)
        }
        
        //
        flashBtn.addTarget(self, action: #selector(flashBtnClick(sender: )), for: .touchUpInside)
        flashBtn.adhere(toSuperview: toolView)
            .image(UIImage(named: "i_flashlight_n"), .normal)
            .image(UIImage(named: "i_light_fill_s"), .selected)
        flashBtn.snp.makeConstraints {
            $0.centerY.equalTo(toolView.snp.centerY)
            $0.left.equalTo(playScrollBtn.snp.right).offset(14)
            $0.width.height.equalTo(40)
        }
        
        //
        bgEffectBtn.addTarget(self, action: #selector(bgEffectBtnClick(sender: )), for: .touchUpInside)
        bgEffectBtn.adhere(toSuperview: toolView)
            .image(UIImage(named: "i_bg_n"), .normal)
            .image(UIImage(named: "i_bg_s"), .selected)
        bgEffectBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-24)
            $0.width.height.equalTo(40)
        }
        
        
        //
        fontBtn.addTarget(self, action: #selector(textFontBtnClick(sender: )), for: .touchUpInside)
        fontBtn.adhere(toSuperview: toolView)
            .image(UIImage(named: "i_font_n"), .normal)
            .image(UIImage(named: "i_font_s"), .selected)
        fontBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(bgEffectBtn.snp.left).offset(-14)
            $0.width.height.equalTo(40)
        }
        
    }
    
}

extension DPkbsPreviewVC {
    @objc func settingBtnClick(sender: UIButton) {
        if contentTextFeid.isFirstResponder {
            contentTextFeid.resignFirstResponder()
        }
        self.present(DPkbsSettingVC(), animated: true)
        
    }
    
    @objc func hideButtonClick(sender: UIButton) {
        contentTextFeid.resignFirstResponder()
    }
    
    @objc func sendBtnClick(sender: UIButton) {
        contentTextFeid.resignFirstResponder()
        
        if let contentText = contentTextFeid.text {
             let removeWhiteSpaceString = contentText.trimmingCharacters(in: .whitespacesAndNewlines)
            if removeWhiteSpaceString != "" {
                // 有内容
                updateScreenContent_textString(contentText: contentText)
                // clear
                contentTextFeid.text = nil
                return
            }
        }
        // 没有内容，不改变当前现实效果
    }
    
    @objc func lockBtnClick(sender: UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
            toolView.isHidden = false
            settingBtn.isHidden = false
            bottomMaskV.isHidden = false
            if fontBtn.isSelected == true {
                fontBar.isHidden = false
            }
            if bgEffectBar.isHidden == true {
                bgEffectBar.isHidden = false
            }
        } else {
            sender.isSelected = true
            toolView.isHidden = true
            settingBtn.isHidden = true
            bottomMaskV.isHidden = true
            fontBar.isHidden = true
            bgEffectBar.isHidden = true
        }
        
        if contentTextFeid.isFirstResponder {
            contentTextFeid.resignFirstResponder()
        }
    }
    
    @objc func flashBtnClick(sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            ScreenBrightnessManager.defaultShared.openSinFlashActionStatus(isOpen: true)
        } else {
            sender.isSelected = false
            ScreenBrightnessManager.defaultShared.openSinFlashActionStatus(isOpen: false)
        }
        
    }
 /*
    @objc func resetBtnClick(sender: UIButton) {
        if let textScrollView = textBgV.subviews.first as? ASTextAutoScrollView {
            textScrollView.resetupDefaultStatus()
        }
    }
    */
    
    @objc func textFontBtnClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        //
        if fontBar.isHidden == false {
           hiddenFontBar()
        } else {
            if bgEffectBar.isHidden == false {
                hiddenEffectBgBar()
                bgEffectBtn.isSelected = false
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                    self.showFontBar()
                }
            } else {
                self.showFontBar()
            }
        }
        sender.isUserInteractionEnabled(false)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            sender.isUserInteractionEnabled(true)
        }
    }
    
    @objc func bgEffectBtnClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        //
        if bgEffectBar.isHidden == false {
            hiddenEffectBgBar()
            
        } else {
            if fontBar.isHidden == false {
                hiddenFontBar()
                fontBtn.isSelected = false
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                    self.showEffectBgBar()
                }
            } else {
                self.showEffectBgBar()
            }
        }
        sender.isUserInteractionEnabled(false)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            sender.isUserInteractionEnabled(true)
        }
    }
    
    @objc func scrollStatusBtnClick(sender: UIButton) {
        if let textScrollView = textBgV.subviews.first as? ASTextAutoScrollView {
            sender.isSelected = !sender.isSelected
            if sender.isSelected == true {
                textScrollView.scrollView.stopScroll()
            } else {
                textScrollView.scrollView.startScroll()
            }
            
        }
    }
    
    func showFontBar() {
        self.fontBar.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.fontBar.frame = CGRect(x: 0, y: self.bottomBar.frame.minY - 65, width: self.view.frame.width, height: 65)
        } completion: { finished in
            if finished {
                
            }
        }
    }
    
    func hiddenFontBar() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.fontBar.frame = CGRect(x: 0, y: self.bottomBar.frame.minY, width: self.view.frame.width, height: 65)
        } completion: { finished in
            if finished {
                self.fontBar.isHidden = true
            }
        }
    }
    
    func showEffectBgBar() {
        self.bgEffectBar.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.bgEffectBar.frame = CGRect(x: 0, y: self.bottomBar.frame.minY - 65, width: self.view.frame.width, height: 65)
        } completion: { finished in
            if finished {
                
            }
        }
    }
    
    func hiddenEffectBgBar() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.bgEffectBar.frame = CGRect(x: 0, y: self.bottomBar.frame.minY, width: self.view.frame.width, height: 65)
        } completion: { finished in
            if finished {
                self.bgEffectBar.isHidden = true
            }
        }
    }
    
}

extension DPkbsPreviewVC {
    func updateScreenContent_canvasColor(colorItem: YAColorItem) {
        
        effectBgV.updateContentBgColor(bgColorItem: colorItem)
    }
    
    func updateScreenContent_canvasBgPhoto(photoStr: String) {
        effectBgV.updateContentBgPhotoImage(photoImgStr: photoStr)
    }
    
    func updateScreenContent_canvasBgEffect(effectItem: ODStyleItem) {
        
        effectBgV.updateContentBgEffect(effectStr: effectItem.templateId, bgColorItem: YAColorItem(type: "rgb", colorName: effectItem.bgEffect))
        
        
    }
    
    // 设备层面
    func updateScreenContent_deviceScreenFlash(isOn: Bool) {
        ScreenBrightnessManager.defaultShared.openSinFlashActionStatus(isOpen: isOn)
    }
    
    
    func updateBgEffect(styleItem: ODStyleItem) {
        if styleItem.templateId.contains("c") {
            self.updateScreenContent_textColor(colorItem: YAColorItem(type: "rgb", colorName: styleItem.textColorStr))
            self.updateScreenContent_canvasColor(colorItem: YAColorItem(type: "rgb", colorName: styleItem.bgEffect))
        } else if styleItem.templateId.contains("e") {
            self.updateScreenContent_textColor(colorItem: YAColorItem(type: "rgb", colorName: styleItem.textColorStr))
            self.updateScreenContent_canvasBgEffect(effectItem: styleItem)
            
        } else if styleItem.templateId.contains("p") {
            self.updateScreenContent_textColor(colorItem: YAColorItem(type: "rgb", colorName: styleItem.textColorStr))
            self.updateScreenContent_canvasBgPhoto(photoStr: styleItem.bigImg)
        }
    }
}

extension DPkbsPreviewVC {
    
    func updateScreenContent_textString(contentText: String) {
        
        if let textScrollView = textBgV.subviews.first as? ASTextAutoScrollView {
            textScrollView.sysString = contentText
        }
    }
    
    func updateScreenContent_font(fontItem: String) {
        if let textScrollView = textBgV.subviews.first as? ASTextAutoScrollView {
            textScrollView.sysFontFileName = fontItem
        }
    }
    
    func updateScreenContent_textColor(colorItem: YAColorItem) {
        if let textScrollView = textBgV.subviews.first as? ASTextAutoScrollView {
            let color = colorItem.itemColor(textScrollView.bounds.size)
            textScrollView.sysTextColor = color
        }
    }
    
    func updateScreenContent_fontPointSize(fontPointSize: SAFontPointSizeItem) {
        if let textScrollView = textBgV.subviews.first as? ASTextAutoScrollView {
            textScrollView.sysFontPointSize = (fontPointSize.pointSize?.cgFloat() ?? 100)
        }
    }
    
    func updateScreenContent_speed(speed: SASpeedItem) {
        if let textScrollView = textBgV.subviews.first as? ASTextAutoScrollView {
            textScrollView.sysSpeed = (speed.speed?.cgFloat() ?? 0.01)
        }
    }
    
    func updateScreenContent_outLightSwitch(isOn: Bool) {
        if let textScrollView = textBgV.subviews.first as? ASTextAutoScrollView {
            textScrollView.sysOutlight = isOn
        }
 
//        //抖音效果
//        textScrollView?.sysTextDouyin = isOn
 
    }
    
    func updateScreenContent_textFlashSwitch(isOn: Bool) {
        if let textScrollView = textBgV.subviews.first as? ASTextAutoScrollView {
            textScrollView.sysTextFlash = isOn
        }
    }
    
    func updateScreenContent_textStroke(isOn: Bool) {
        if let textScrollView = textBgV.subviews.first as? ASTextAutoScrollView {
            textScrollView.sysTextStroke = isOn
        }
    }
    
    func updateScreenContent_reflectionEffect(isOn: Bool) {
        if let textScrollView = textBgV.subviews.first as? ASTextAutoScrollView {
            textScrollView.sysReflectionEffect = isOn
        }
    }
    
    func updateScreenContent_doubleLayer(isOn: Bool) {
        if let textScrollView = textBgV.subviews.first as? ASTextAutoScrollView {
            textScrollView.sysDoubleLayer = isOn
        }
    }
    
    func updateScreenContent_slantEffect(isOn: Bool) {
        if let textScrollView = textBgV.subviews.first as? ASTextAutoScrollView {
            textScrollView.sysSlantEffect = isOn
        }
    }
    
    func updateScreenContent_textScaleSwitch(isOn: Bool) {
        if let textScrollView = textBgV.subviews.first as? ASTextAutoScrollView {
            textScrollView.sysTextScale = isOn
        }
    }
    
    func updateScreenContent_resetDefaultStatus() {
        if let textScrollView = textBgV.subviews.first as? ASTextAutoScrollView {
            textScrollView.resetupDefaultDisplay()
        }
    }
    
}
