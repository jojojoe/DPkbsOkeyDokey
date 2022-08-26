//
//  DPkbsStoreVC.swift
//  DPbsOkeyDokey
//
//  Created by nataliya on 2022/4/18.
//

import UIKit
import ZKProgressHUD
class DPkbsStoreVC: UIViewController {
    let priceLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        DPksOkeyPurchaseManager.default.purchaseInfo { (products) in
            debugPrint(products)
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                self.updatePriceLabel(productItems: products)
            }
        }
    }

    func updatePriceLabel(productItems: [DPksOkeyPurchaseManager.IAPProduct]) {
        if let yearProduct = productItems.first {
            priceLabel.text = yearProduct.localizedPrice
        }
    }
}

extension DPkbsStoreVC {
    
   
    func setupView() {
        view.backgroundColor(.clear)
        //
        let contentV = UIView()
            .backgroundColor(UIColor(hexString: "#1C1C1D")!.withAlphaComponent(0.6))
            .adhere(toSuperview: view)
            .clipsToBounds()
        contentV.layer.cornerRadius = 12
        contentV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.left.top.equalToSuperview()
            
        }
        
        
        
        //
        let vipInfo1 = UILabel()
        vipInfo1.fontName(18, "AppleSDGothicNeo-Bold")
            .color(.white)
            .text("\("Dozens of exquisite special effects for unlimited use".localized())")
            .textAlignment(.center)
            .adhere(toSuperview: contentV)
            
        vipInfo1.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(30)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.greaterThanOrEqualTo(1)
        }
        
        //
        let contentInfoLabel = UILabel()
        contentInfoLabel.fontName(15, "AppleSDGothicNeo-Bold")
            .color(.white)
            .text("Yearly".localized())
            .adhere(toSuperview: contentV)
        contentInfoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-40)
            $0.top.equalTo(vipInfo1.snp.bottom).offset(24)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        //
        let priceLabelBgV = UIView()
        priceLabelBgV.adhere(toSuperview: contentV)
            .backgroundColor(UIColor.clear)
//            .backgroundColor(UIColor(hexString: "#FECB42")!)
//        priceLabelBgV.layer.cornerRadius = 8
        //
        let priceStr = "$0.99"
        priceLabel.fontName(15, "Avenir-HeavyOblique")
            .color(UIColor(hexString: "#FECB42")!)
            .text(priceStr)
            .adhere(toSuperview: contentV)
        priceLabel.snp.makeConstraints {
            $0.left.equalTo(contentInfoLabel.snp.right).offset(40)
            $0.centerY.equalTo(contentInfoLabel.snp.centerY).offset(0)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        //
        priceLabelBgV.snp.makeConstraints {
            $0.center.equalTo(priceLabel.snp.center)
            $0.left.equalTo(priceLabel.snp.left).offset(-5)
            $0.top.equalTo(priceLabel.snp.top).offset(-5)
        }
        //
        let vipInfo = UIButton()
        vipInfo.font(18, "AppleSDGothicNeo-Bold")
            .titleColor(.white)
            .adhere(toSuperview: contentV)
            .title("\(" ")\("Subscription Now".localized())\("")")
            .image(UIImage(named: "vippro"))
            .backgroundColor(UIColor(hexString: "#FECB42")!)
        vipInfo.layer.cornerRadius = 20
        vipInfo.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(contentInfoLabel.snp.bottom).offset(18)
            $0.width.greaterThanOrEqualTo(200)
            $0.height.greaterThanOrEqualTo(40)
        }
        vipInfo.addTarget(self, action: #selector(vipPurchaseClick(sender: )), for: .touchUpInside)
        
        //
        let purchaseInfoUrlBtn = UIButton()
        purchaseInfoUrlBtn.adhere(toSuperview: contentV)
        purchaseInfoUrlBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
            $0.width.equalTo(200)
            $0.height.equalTo(35)
        }
        purchaseInfoUrlBtn.addTarget(self, action: #selector(purchaseInfoUrlBtnClick(sender: )), for: .touchUpInside)
        //
        let attri = NSAttributedString(string: "Subscription notice".localized(), attributes: [NSAttributedString.Key.font : UIFont(name: "AvenirNext-MediumItalic", size: 13)!, NSAttributedString.Key.foregroundColor : UIColor(hexString: "#E5FF7E")!, NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, NSAttributedString.Key.underlineColor : UIColor(hexString: "#E5FF7E")!])
        purchaseInfoUrlBtn.setAttributedTitle(attri, for: .normal)
        
        
    }
    
    @objc func purchaseInfoUrlBtnClick(sender: UIButton) {
        
        debugPrint("info link")
        if let url = URL(string: DPbsManager.default.SubscribeInfoURLStr) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func vipPurchaseClick(sender: UIButton) {
        debugPrint("vipPurchase")
        DPksOkeyPurchaseManager.default.order(iapType: .year, source: "") {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                ZKProgressHUD.showSuccess("Congratulations, you can use special effects freely!".localized())
                self.view.isHidden = true
            }
        }
    }
    
    
}
