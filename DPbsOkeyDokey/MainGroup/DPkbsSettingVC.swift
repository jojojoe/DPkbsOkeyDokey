//
//  DPkbsSettingVC.swift
//  DPbsOkeyDokey
//
//  Created by nataliya on 2022/4/18.
//

import UIKit
import MessageUI
//import DeviceKit
import NoticeObserveKit
import ZKProgressHUD
import StoreKit

class DPkbsSettingVC: UIViewController {
    
    private var pool = Notice.ObserverPool()
    
    let topBanner = UIView()
    var didlayoutOnce = Once()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
//        updateBuyCoinStatus()
//        addNotificationObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        didlayoutOnce.run {
            let colorStr = "#000000"
            let bgColorStr = "#FFFFFF"
            let appShareAttr = NSAttributedString(string: "给个好评".localized(), attributes: [NSAttributedString.Key.font : UIFont(name: "AppleSDGothicNeo-Bold", size: 16)!, NSAttributedString.Key.foregroundColor : UIColor(hexString: colorStr)!])
            let termofAttr = NSAttributedString(string: "隐私政策与用户协议".localized(), attributes: [NSAttributedString.Key.font : UIFont(name: "AppleSDGothicNeo-Bold", size: 16)!, NSAttributedString.Key.foregroundColor : UIColor(hexString: colorStr)!])
            let feedAttr = NSAttributedString(string: "联系我们".localized(), attributes: [NSAttributedString.Key.font : UIFont(name: "AppleSDGothicNeo-Bold", size: 16)!, NSAttributedString.Key.foregroundColor : UIColor(hexString: colorStr)!])
            let appShareBtn = UIButton()
            appShareBtn.contentHorizontalAlignment = .center
            appShareBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            appShareBtn.setAttributedTitle(appShareAttr, for: .normal)
            appShareBtn
                .backgroundColor(UIColor(hexString: bgColorStr)!)
                .adhere(toSuperview: view)
            appShareBtn.addTarget(self, action: #selector(appShareBtnClick(sender: )), for: .touchUpInside)
            appShareBtn.layer.cornerRadius = 10
            //
            let feedbackBtn = UIButton()
            feedbackBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            feedbackBtn.contentHorizontalAlignment = .center
            feedbackBtn.setAttributedTitle(feedAttr, for: .normal)
            feedbackBtn
                .backgroundColor(UIColor(hexString: bgColorStr)!)
                .adhere(toSuperview: view)
            feedbackBtn.addTarget(self, action: #selector(feedbackBtnClick(sender: )), for: .touchUpInside)
            feedbackBtn.layer.cornerRadius = 10
            //
            let termBtn = UIButton()
            termBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            termBtn.contentHorizontalAlignment = .center
            termBtn.setAttributedTitle(termofAttr, for: .normal)
            termBtn
                .backgroundColor(UIColor(hexString: bgColorStr)!)
                .adhere(toSuperview: view)
            termBtn.addTarget(self, action: #selector(termsTBtnClick(sender: )), for: .touchUpInside)
            termBtn.layer.cornerRadius = 10
            
            feedbackBtn.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.centerX.equalToSuperview()
                $0.width.equalTo(240)
                $0.height.equalTo(50)
            }
            termBtn.snp.makeConstraints {
                $0.bottom.equalTo(feedbackBtn.snp.top).offset(-20)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(240)
                $0.height.equalTo(50)
            }
            appShareBtn.snp.makeConstraints {
                $0.top.equalTo(feedbackBtn.snp.bottom).offset(20)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(240)
                $0.height.equalTo(50)
            }
            
            
        }
    }
    
    func setupView() {
        view.backgroundColor(UIColor.black.withAlphaComponent(0.6))
            .clipsToBounds()
        //
      
        
       //
       let backBtn = UIButton()
        backBtn.adhere(toSuperview: view)
           .backgroundColor(.clear)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        backBtn.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
    }
     
    
    @objc func purchaseBtnClick(sender: UIButton) {
 
    }
    
    func showTermsPrivateView() {
        let contentV = DPbsPrivateTermsView()
        contentV.adhere(toSuperview: view)
        contentV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        contentV.alpha = 0
        UIView.animate(withDuration: 0.35) {
            contentV.alpha = 1
        }
        
        contentV.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseInOut) {
                    contentV.alpha = 0
                } completion: { finished in
                    if finished {
                        contentV.removeFromSuperview()
                    }
                }
            }
        }
        contentV.termsBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.showTermsofusePage()
            }
        }
        contentV.privateBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.showPrivatePage()
            }
        }
    }
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @objc func appShareBtnClick(sender: UIButton) {
        //
        
        let itunesStr = "itms-apps://itunes.apple.com/app/id\(AppAppStoreID)"
        if let url = URL(string: itunesStr) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            
        }
    }
    
    @objc func termsTBtnClick(sender: UIButton) {
        showTermsPrivateView()
    }
    
    @objc func feedbackBtnClick(sender: UIButton) {
        feedback()
    }
    
    func showPrivatePage() {
        if let url = URL(string: PrivacyPolicyURLStr.localized()) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func showTermsofusePage() {
        if let url = URL(string: TermsofuseURLStr.localized()) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}

extension DPkbsSettingVC: MFMailComposeViewControllerDelegate {
  func feedback() {
      //首先要判断设备具不具备发送邮件功能
      if MFMailComposeViewController.canSendMail(){
          //获取系统版本号
          let systemVersion = UIDevice.current.systemVersion
          let modelName = UIDevice.current.modelName
          
          let infoDic = Bundle.main.infoDictionary
          // 获取App的版本号
          let appVersion = infoDic?["CFBundleShortVersionString"] ?? "8.8.8"
          // 获取App的名称
          let appName = "\(AppName)"

          
          let controller = MFMailComposeViewController()
          //设置代理
          controller.mailComposeDelegate = self
          //设置主题
          controller.setSubject("")
          //设置收件人
          // FIXME: feed back email
          controller.setToRecipients([feedbackEmail])
          //设置邮件正文内容（支持html）
       controller.setMessageBody("\n\n\nSystem Version：\(systemVersion)\n Device Name：\(modelName)\n App Name：\(appName)\n App Version：\(appVersion )", isHTML: false)
          
          //打开界面
       self.present(controller, animated: true, completion: nil)
      }else{
          HUD.error("The device doesn't support email")
      }
  }
  
  //发送邮件代理方法
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
      controller.dismiss(animated: true, completion: nil)
  }
}
