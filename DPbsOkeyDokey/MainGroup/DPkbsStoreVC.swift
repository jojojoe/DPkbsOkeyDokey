//
//  DPkbsStoreVC.swift
//  DPbsOkeyDokey
//
//  Created by JOJO on 2022/4/18.
//

import UIKit

class DPkbsStoreVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
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
            $0.width.equalTo(450)
            $0.height.equalTo(300)
            
        }
        
        //
        let iconImgV = UIImageView()
        iconImgV.adhere(toSuperview: contentV)
            .contentMode(.scaleAspectFit)
            .image("appicon")
            .clipsToBounds()
        iconImgV.layer.cornerRadius = 6
        iconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.width.height.equalTo(32)
        }
        
        //
        let versionLabel = UILabel()
        versionLabel.fontName(16, "AppleSDGothicNeo-Bold")
            .color(.white)
            .text("\("加入会员".localized())")
            .textAlignment(.center)
            .adhere(toSuperview: contentV)
            
        versionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(iconImgV.snp.bottom).offset(12)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.greaterThanOrEqualTo(1)
        }
        
        //
        let vipInfo1 = UILabel()
        vipInfo1.fontName(14, "AppleSDGothicNeo-Bold")
            .color(.white)
            .text("\("数十套精美特效无限使用".localized())")
            .textAlignment(.center)
            .adhere(toSuperview: contentV)
            
        versionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(iconImgV.snp.bottom).offset(12)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.greaterThanOrEqualTo(1)
        }
        
        //
        let contentInfoLabel = UILabel()
        contentInfoLabel.fontName(15, "AppleSDGothicNeo-Bold")
            .color(.white)
            .text("终身会员".localized())
            .adhere(toSuperview: contentV)
        contentInfoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-40)
            $0.top.equalTo(versionLabel.snp.bottom).offset(14)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        //
        let priceStr = "$1.99"
        let priceLabel = UILabel()
        priceLabel.text(priceStr)'
        priceLabel.fontName(15, "AppleSDGothicNeo-Bold")
            .color(.white)
            .text("终身会员".localized())
            .adhere(toSuperview: contentV)
        priceLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-40)
            $0.top.equalTo(versionLabel.snp.bottom).offset(14)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        
        
        
    }
    
    
}
