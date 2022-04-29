//
//  DPkbsPreviewVC.swift
//  DPbsOkeyDokey
//
//  Created by JOJO on 2022/4/18.
//

import UIKit

class DPkbsPreviewVC: UIViewController, UITextFieldDelegate {
    var styleItem: ODStyleItem
    let backBtn = UIButton()
    let textBgV = UIView()
    var effectBgV: DPkbsEffectView!
    var toolView = UIView()
    let contentTextFeid = UITextField()
    let sendBtn = UIButton()
    let lockBtn = UIButton()
    let flashBtn = UIButton()
    let adjustBtn = UIButton()
    
    init(styleItem: ODStyleItem) {
        self.styleItem = styleItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor(.white)
        view.clipsToBounds()
        registKeyboradNotification()
        setupView()
    }
    
    func setupView() {
        setupContentV()
        setupBottomToolBar()
        setupAdjustControV()
        
        //
        
        backBtn.image(UIImage(named: ""))
            .adhere(toSuperview: view)
            .backgroundColor(.darkGray)
        backBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(4)
            $0.width.height.equalTo(48)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        
        
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
            
        }
        
        debugPrint(keyboardHeight)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            
        }
        debugPrint(keyboardHeight)
    }
}

extension DPkbsPreviewVC {
    @objc func backBtnClick(sender: UIButton) {
        self.navigationController?.hero.navigationAnimationType = .slide(direction: .down)
        popVC()
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
        
        
        //
        if styleItem.templateId == "1" {
            
        }
        
        let textScrollView = ASTextAutoScrollView.init(frame: self.view.bounds)
        textScrollView.adhere(toSuperview: textBgV)
        textScrollView.scrollView.tapClickViewActionBlock = {
            [weak self] in
            guard let `self` = self else {return}
            
        }
        
        
    }
    
    func setupAdjustControV() {
        
    }
    
    func setupBottomToolBar() {
        let bottomBar = UIView()
        bottomBar.adhere(toSuperview: view)
        bottomBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
        }
        bottomBar.backgroundColor(UIColor.white.withAlphaComponent(0.3))
        //
        
        //
        bottomBar.addSubview(toolView)
        toolView.backgroundColor = UIColor(hexString: "#FAFAFA")
        toolView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        
        //
        contentTextFeid.delegate = self
        contentTextFeid.textAlignment = .center
        contentTextFeid.borderStyle = .roundedRect
        contentTextFeid.textColor = .black
        contentTextFeid.backgroundColor = .white
        contentTextFeid.inputAccessoryView = toolView
        contentTextFeid.font = UIFont(name: "PingFangSC-Semibold", size: 16)
        toolView.addSubview(contentTextFeid)
        
        contentTextFeid.placeholder = "标签..."
        contentTextFeid.clearButtonMode = .whileEditing
        contentTextFeid.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(36)
        }
        //
        
        sendBtn.addTarget(self, action: #selector(sendBtnClick(sender: )), for: .touchUpInside)
        sendBtn.adhere(toSuperview: toolView)
            .image(UIImage(named: ""))
            .backgroundColor(.lightGray)
        sendBtn.snp.makeConstraints {
            $0.centerY.equalTo(contentTextFeid.snp.centerY)
            $0.left.equalTo(contentTextFeid.snp.right).offset(20)
            $0.width.height.equalTo(36)
        }
        
        //

        lockBtn.addTarget(self, action: #selector(lockBtnClick(sender: )), for: .touchUpInside)
        lockBtn.adhere(toSuperview: view)
            .image(UIImage(named: ""))
            .backgroundColor(.lightGray)
        lockBtn.snp.makeConstraints {
            $0.centerY.equalTo(contentTextFeid.snp.centerY)
            $0.left.equalToSuperview().offset(34)
            $0.width.height.equalTo(36)
        }
        
        //

        flashBtn.addTarget(self, action: #selector(flashBtnClick(sender: )), for: .touchUpInside)
        flashBtn.adhere(toSuperview: toolView)
            .image(UIImage(named: ""))
            .backgroundColor(.lightGray)
        flashBtn.snp.makeConstraints {
            $0.centerY.equalTo(contentTextFeid.snp.centerY)
            $0.left.equalTo(lockBtn.snp.right).offset(34)
            $0.width.height.equalTo(36)
        }
        
        //

        adjustBtn.addTarget(self, action: #selector(adjustBtnClick(sender: )), for: .touchUpInside)
        adjustBtn.adhere(toSuperview: toolView)
            .image(UIImage(named: ""))
            .backgroundColor(.lightGray)
        adjustBtn.snp.makeConstraints {
            $0.centerY.equalTo(contentTextFeid.snp.centerY)
            $0.right.equalToSuperview().offset(-34)
            $0.width.height.equalTo(36)
        }
        
        
        
    }
    
    
    
}

extension DPkbsPreviewVC {
    @objc func sendBtnClick(sender: UIButton) {
        
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
            backBtn.isHidden = false
        } else {
            sender.isSelected = true
            toolView.isHidden = true
            backBtn.isHidden = true
        }
    }
    
    @objc func flashBtnClick(sender: UIButton) {
        
    }
    
    @objc func adjustBtnClick(sender: UIButton) {
        
    }
    
    
}

extension DPkbsPreviewVC {
    func updateScreenContent_canvasColor(colorItem: YAColorItem) {
        let color = colorItem.itemColor(view.bounds.size)
        effectBgV.updateContentBgColor(color: color)
        
    }
    
    // 设备层面
    func updateScreenContent_deviceScreenFlash(isOn: Bool) {
        ScreenBrightnessManager.defaultShared.openSinFlashActionStatus(isOpen: isOn)
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
