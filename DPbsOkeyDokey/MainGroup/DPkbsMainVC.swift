//
//  DPkbsMainVC.swift
//  DPbsOkeyDokey
//
//  Created by JOJO on 2022/4/18.
//

import UIKit
import Magnetic
import Hero
import SpriteKit
import SwifterSwift
import Comets
import Pulsator

class DPkbsMainVC: UIViewController {
    
    var magneticView: MagneticView = MagneticView()
    
    var onceViewWillAppear: Once = Once()
    var onceViewDidAppear: Once = Once()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMagneticView()
        setupSpacesStarLine()
        setupView()
        
        
        
    }
 
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onceViewDidAppear.run {
            [weak self] in
            guard let `self` = self else {return}
            for styleItem in DPbsManager.default.styleList {
                self.addStyleTemplate(item: styleItem)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }

    func setupView() {
        //
        let settingBtn = UIButton()
        settingBtn.image(UIImage(named: ""))
            .adhere(toSuperview: view)
            .backgroundColor(.darkGray)
        settingBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(4)
            $0.width.height.equalTo(48)
        }
        settingBtn.addTarget(self, action: #selector(settingBtnClick(sender: )), for: .touchUpInside)
        
        //
        let storeBtn = UIButton()
        storeBtn.image(UIImage(named: ""))
            .adhere(toSuperview: view)
            .backgroundColor(.darkGray)
        storeBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-24)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(4)
            $0.width.height.equalTo(48)
        }
        storeBtn.addTarget(self, action: #selector(storeBtnClick(sender: )), for: .touchUpInside)
    }
    
    
    func setupMagneticView() {
        magneticView.magnetic.backgroundColor = .clear
        magneticView.magnetic.magneticDelegate = self
        magneticView.magnetic.allowsMultipleSelection = false
        magneticView.adhere(toSuperview: view)
        magneticView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
#if DEBUG
        magneticView.showsFPS = true
        magneticView.showsDrawCount = true
        magneticView.showsQuadCount = true
#endif
    }

    
    func addStyleTemplate(item: ODStyleItem) {
        let title = item.templateName
        let imgName = item.coverImg
        let color = item.coverColor
        // Image Node: image displayed by default
        
        let node = ImageNode(text: title, image: UIImage(named: imgName), color: UIColor(hexString: color) ?? UIColor.white, radius: 40)
        magneticView.magnetic.addChild(node)
    }
    
    
}

extension DPkbsMainVC {
    @objc func settingBtnClick(sender: UIButton) {
        
    }
    
    @objc func storeBtnClick(sender: UIButton) {
        
    }
    
    func showPreviewVC(style: ODStyleItem) {
        
        
        let styleVC = DPkbsPreviewVC(styleItem: style)
        self.navigationController?.hero.isEnabled = true
        self.navigationController?.hero.navigationAnimationType = .slide(direction: HeroDefaultAnimationType.Direction.up)
        pushVC(styleVC, animate: true)
        
        
    }
}


extension DPkbsMainVC: MagneticDelegate {
    
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        print("didSelect -> \(node)")
        if let imgNode = node as? ImageNode {
           let styleItem = DPbsManager.default.styleList.first { (item) -> Bool in
                if imgNode.text == item.templateName {
                    return true
                } else {
                    return false
                }
            }
            if let styleItem_m = styleItem {
                showPreviewVC(style: styleItem_m)
            } else {
                debugPrint("没有 当前 style")
            }
            
            node.isSelected = false
            
        }
    }
    
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        print("didDeselect -> \(node)")
        
    }
    
}

extension DPkbsMainVC {
    func setupSpacesStarLine() {
        
        let spaceBgView = UIView()
        spaceBgView.adhere(toSuperview: view)
            .backgroundColor(.clear)
        spaceBgView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        magneticView.addSubview(spaceBgView)
        
        // Customize your comet
        let width = view.bounds.width
        let height = view.bounds.height
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
        
        let starView = SSStarSpaceView.init(frame: view.bounds)
        starView.backgroundColor(.clear)
        spaceBgView.addSubview(starView)
    }
}


//MARK: 背景星空图
extension DPkbsMainVC {
    
    
}





