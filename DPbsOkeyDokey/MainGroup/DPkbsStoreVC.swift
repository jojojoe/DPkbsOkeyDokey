//
//  DPkbsStoreVC.swift
//  DPbsOkeyDokey
//
//  Created by nataliya on 2022/4/18.
//

import UIKit

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
    
    func fetchPrice() {
        
    }
    
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
        let vipInfo = UILabel()
        vipInfo.fontName(18, "AppleSDGothicNeo-Bold")
            .color(.white)
            .text("\("加入会员".localized())")
            .textAlignment(.center)
            .adhere(toSuperview: contentV)
            
        vipInfo.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(30)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        let iconImgV = UIImageView()
        iconImgV.adhere(toSuperview: contentV)
            .contentMode(.scaleAspectFit)
            .image("appicon")
            .clipsToBounds()
        iconImgV.layer.cornerRadius = 6
        iconImgV.snp.makeConstraints {
            $0.right.equalTo(vipInfo.snp.left).offset(-10)
            $0.centerY.equalTo(vipInfo.snp.centerY).offset(0)
            $0.left.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        
        
        //
        let vipInfo1 = UILabel()
        vipInfo1.fontName(14, "AppleSDGothicNeo-Bold")
            .color(.white)
            .text("\("数十套精美特效无限使用".localized())")
            .textAlignment(.center)
            .adhere(toSuperview: contentV)
            
        vipInfo1.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(vipInfo.snp.bottom).offset(22)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.greaterThanOrEqualTo(1)
        }
        
        //
        let contentInfoLabel = UILabel()
        contentInfoLabel.fontName(15, "AppleSDGothicNeo-Bold")
            .color(.white)
            .text("年会员".localized())
            .adhere(toSuperview: contentV)
        contentInfoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-40)
            $0.top.equalTo(vipInfo1.snp.bottom).offset(24)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        //
        let priceLabelBgV = UIView()
        priceLabelBgV.adhere(toSuperview: contentV)
            .backgroundColor(UIColor(hexString: "#FECB42")!)
        priceLabelBgV.layer.cornerRadius = 8
        //
        let priceStr = "$1.99"
        priceLabel.fontName(15, "Avenir-HeavyOblique")
            .color(UIColor.white)
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
        
        
        
    }
    
    
}
