//
//  ASAutoScrollView.swift
//  DPbsOkeyDokey
//
//  Created by nataliya on 2022/4/18.
//

import Foundation
import UIKit
import SnapKit
import SwifterSwift
//import GlitchLabel

enum AutoScrollDirection {
    case toLeft
    case toRight
    case toTop
    case toBottom
}

struct AutoScrollConfig {

    var scrollDirection: AutoScrollDirection = .toLeft
    var padding: CGFloat = 100
    var cellCornerRadius: CGFloat = 10
    var timeInterval: TimeInterval = 0.01 ///滚动的时间间隔,是每次滚动的距离需要的时间，设置越小，移动越快。默认是0.05秒
     
    
    /// 固定
    var scrollStep: CGFloat = 0.5 ///每次滚动的距离 默认为1个像素
    var repeatCount: Int = 100
    var maxTimeInterval: TimeInterval = 0.2
    var minTimeInterval: TimeInterval = 0.0005
     
    // 文字内容高度
    var contentRealHeight: CGFloat = 0
    
    // 文字内容
    var contentTextString: String?
    var contentTextFont: UIFont?
    
    // 倒影Layer reflection
    var isContentReflection: Bool = false
    // 叠影
    var isContentDoubleLayer: Bool = false
    // 倾斜
    var isContentSlantEffect: Bool = false
    // 抖音效果
//    var isDouyinEffect: Bool = false
    
}

class ASAutoScrollView: UIView {

    var contentViewList: [UIView] = []
    var contentRect: CGRect = .zero
    var scrollConfig: AutoScrollConfig = AutoScrollConfig()
    var contentBgView: UIView = UIView.init()
    var contentCollection = UICollectionView.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    var scrollTimer: Timer?
    var timer: Timer?
    
    var tapClickViewActionBlock:(()->Void)?
 
    override func removeFromSuperview() {
        super.removeFromSuperview()
        invalidateTimer()
    }
    
    init(frame: CGRect, viewsList: [UIView]) {

        contentRect = frame
        contentViewList = viewsList

        super.init(frame: frame)
        if viewsList.count != 0 {
            setupView()
            setupCollectoin()
            setupTimer()
            setupTapGesture()
        }
        
        //
//        addScaleAnimal(isAdd: true)
//        addShakeAnimal(isAdd: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        // view
        self.backgroundColor = .clear
        contentBgView.frame = CGRect.init(x: 0, y: 0, width: contentRect.size.width, height: contentRect.size.height)
        contentBgView.backgroundColor = .clear
        addSubview(contentBgView)
        
        
        
    }
    
    func setupCollectoin() {
    
        contentCollection.backgroundColor = .clear
        contentCollection.dataSource = self
        contentCollection.delegate = self
        contentCollection.showsVerticalScrollIndicator = false
        contentCollection.showsHorizontalScrollIndicator = false
        contentCollection.frame = CGRect.init(x: 0, y: 0, width: contentRect.size.width, height: contentRect.size.height)
        
        contentBgView.addSubview(contentCollection)
 
        updateScrollDirection(direction: scrollConfig.scrollDirection)
        contentCollection.register(cellWithClass: ASAutoScrollCell.self)
    }
    
    func setupTimer() {
        if let scrollTimer_m = scrollTimer {
            scrollTimer_m.invalidate()
            scrollTimer = nil
        }
        scrollTimer = Timer.scheduledTimer(timeInterval: scrollConfig.timeInterval, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        guard let scrollTimer = scrollTimer else { return }
        RunLoop.current.add(scrollTimer, forMode: .common)
//        stopScroll()
    }
 
    @objc
    func timerAction() {
        var offsetX: CGFloat = 0
        var offsetY: CGFloat = 0
        switch scrollConfig.scrollDirection {
        case .toLeft:
            offsetX = contentCollection.contentOffset.x + scrollConfig.scrollStep
            offsetY = contentCollection.contentOffset.y
            if offsetX >= contentCollection.contentSize.width - contentRect.size.width {
                offsetX = 0
            }
        case .toRight:
            offsetX = contentCollection.contentOffset.x - scrollConfig.scrollStep
            offsetY = contentCollection.contentOffset.y
            if offsetX <= 0 {
                offsetX = contentCollection.contentSize.width - contentRect.size.width
            }
        case .toTop:
            offsetX = contentCollection.contentOffset.x
            offsetY = contentCollection.contentOffset.y + scrollConfig.scrollStep
            if offsetY >= contentCollection.contentSize.height - contentRect.size.height {
                offsetY = 0
            }
            
        case .toBottom:
            offsetX = contentCollection.contentOffset.x
            offsetY = contentCollection.contentOffset.y + scrollConfig.scrollStep
            if offsetY <= 0 {
                offsetY = contentCollection.contentSize.height - contentRect.size.height
            }
            
        }
        
        DispatchQueue.main.async {[weak self] in
            guard let `self` = self else {return}
            self.contentCollection.setContentOffset(CGPoint.init(x: offsetX, y: offsetY), animated: false)
        }
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        self.contentCollection.addGestureRecognizer(tapGesture)
        
    }
    
    @objc
    func tapAction() {
        debugPrint("tap collection")
        tapClickViewActionBlock?()
    }
    
}



// public
extension ASAutoScrollView {
    
    func startScroll() {
        scrollTimer?.fireDate = Date.init(timeIntervalSinceNow: 0.5) //.5秒后开启
    }
    
    func stopScroll() {
        scrollTimer?.fireDate = Date.distantFuture    // 暂停
    }
    
    func invalidateTimer() {
        scrollTimer?.invalidate()
    }
    
    // 更新滚动方向
    func updateScrollDirection(direction: AutoScrollDirection) {
        
        scrollConfig.scrollDirection = direction
        
        var offsetX: CGFloat = 0
        var offsetY: CGFloat = 0
        
        var direction: UICollectionView.ScrollDirection = .horizontal
        switch scrollConfig.scrollDirection {
        case .toLeft:
            direction = .horizontal
            offsetX = 0
            offsetY = 0
        case .toRight:
            direction = .horizontal
            offsetX = contentCollection.contentSize.width - contentRect.size.width
            offsetY = 0
        case .toTop:
            direction = .vertical
            offsetX = 0
            offsetY = 0
        case .toBottom:
            direction = .vertical
            offsetX = 0
            offsetY = contentCollection.contentSize.height - contentRect.size.height
        
        }
        
        let collectionLayout = contentCollection.collectionViewLayout as? UICollectionViewFlowLayout
        collectionLayout?.scrollDirection = direction
        
        contentCollection.setContentOffset(CGPoint.init(x: offsetX, y: offsetY), animated: false)
        
    }
    
    // 滚动速度
    func undateScrollSpeed(speed: CGFloat) {
        if speed == 0 {
            stopScroll()
        } else {
            var currentInterval: TimeInterval = (scrollConfig.maxTimeInterval - TimeInterval(speed))
            if currentInterval <= scrollConfig.minTimeInterval {
                currentInterval = scrollConfig.minTimeInterval
            }
            scrollConfig.timeInterval = currentInterval
            setupTimer()
            startScroll()
        }
    }
     
    // 缩放动画
    func addScaleAnimal(isAdd: Bool) {
        if isAdd {
            let animati = CAKeyframeAnimation(keyPath: "transform.scale")
            // rotation 旋转，需要添加弧度值
            animati.values = [1.2,0.5,1.2]
            animati.calculationMode = .cubic
            animati.rotationMode = .rotateAutoReverse
            animati.duration = 1
            animati.repeatCount = MAXFLOAT
            contentBgView.layer.add(animati, forKey: "transform.scale.key")
        } else {
            contentBgView.layer.removeAnimation(forKey: "transform.scale.key")
        }
    }
    
    // 旋转动画
    func addShakeAnimal(isAdd: Bool)  {
        if isAdd {
            let animati = CAKeyframeAnimation(keyPath: "transform.rotation")
            // rotation 旋转，需要添加弧度值
            animati.values = [angle2Radion(angle: -50), angle2Radion(angle: 50), angle2Radion(angle: -50)]
            animati.duration = 1
            animati.repeatCount = MAXFLOAT
            contentBgView.layer.add(animati, forKey: "transform.rotation.key")
        } else {
            
            contentBgView.layer.removeAnimation(forKey: "transform.rotation.key")
        }
        
    }
    
    // 透明度动画
    func addContentAlphaAnimation(isAdd: Bool) {
        if isAdd {
            let animati = CAKeyframeAnimation(keyPath: "opacity")
            // rotation 旋转，需要添加弧度值
            animati.values = [0,1,0,1]
            animati.duration = 2
            animati.autoreverses = true
            animati.repeatCount = MAXFLOAT
            contentBgView.layer.add(animati, forKey: "content.opacity.key")
        } else {
            
            contentBgView.layer.removeAnimation(forKey: "content.opacity.key")
        }
    }
    
    // 更新文字内容
    func updateContentString(viewsList: [UIView]) {
        contentViewList = viewsList
        contentCollection.reloadData()
    }
    
    // 倒影 内容
    func addContentReflectionLayer(isOn: Bool) {
        scrollConfig.isContentReflection = isOn
        contentCollection.reloadData()
    }
    
    // 叠影 内容
    func addContentDoubleLayer(isOn: Bool) {
        scrollConfig.isContentDoubleLayer = isOn
        contentCollection.reloadData()
    }
    
    // 倾斜 内容
    func addContentSlant(isOn: Bool) {
        scrollConfig.isContentSlantEffect = isOn
        contentCollection.reloadData()
    }
    
    // 抖音文字 效果
//    func addDouyinEffect(isOn: Bool) {
//        scrollConfig.isDouyinEffect = isOn
//        contentCollection.reloadData()
//    }
    
}

extension ASAutoScrollView {
    
    func angle2Radion(angle: Float) -> Float {
        return angle / Float(180.0 * Double.pi)
    }
}


extension ASAutoScrollView {
    func cellSize(indexPath: IndexPath) -> CGSize {
        
        let realCount = indexPath.item % contentViewList.count
        
        let contentView = contentViewList[realCount]
        
        var cellWidth: CGFloat = 0
        var cellHeight: CGFloat = 0
        
        if scrollConfig.scrollDirection == .toLeft || scrollConfig.scrollDirection == .toRight {
            cellWidth = (contentView.size.width / contentView.size.height) * contentRect.size.height
            cellHeight = contentRect.size.height
        } else {
            cellHeight = (contentView.size.height / contentView.size.width) * contentRect.size.width
            cellWidth = contentRect.size.width
        }
        
        return CGSize.init(width: cellWidth, height: cellHeight)
    }
}

extension ASAutoScrollView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = contentCollection.dequeueReusableCell(withClass: ASAutoScrollCell.self, for: indexPath)
 
        let realCount = indexPath.item % contentViewList.count
        let contentView = contentViewList[realCount]
        if let subView = cell.contentBgView.subviews.last {
            subView.removeFromSuperview()
        }
        
//        if let originLabel = contentView as? UILabel, scrollConfig.isDouyinEffect == true, let contentString = scrollConfig.contentTextString, let contentFont = scrollConfig.contentTextFont {
//            let litchLabel = GlitchLabel.init(frame: CGRect.init(x: 0, y: 0, width: originLabel.width, height: scrollConfig.contentRealHeight))
//            
//            litchLabel.center = CGPoint.init(x: cell.width / 2, y: cell.height / 2)
//            litchLabel.text = contentString
//            litchLabel.font = contentFont
//            cell.contentBgView.addSubview(litchLabel)
//            return  cell
//        }
        
        if let screenShot = contentView.screenshot {
            let imageView = UIImageView.init(frame: contentView.bounds)
            imageView.image = screenShot
            cell.contentBgView.addSubview(imageView)
        }
        
        cell.contentBgView.clipsToBounds = false
        cell.contentBgView.cornerRadius = scrollConfig.cellCornerRadius
        
        // 倒影
        if scrollConfig.isContentReflection {
            if let replicatorLayer = cell.layer as? CAReplicatorLayer {
                replicatorLayer.instanceCount = 2
                // 沿y轴移动verticalOffset高度
                var transform = CATransform3DIdentity
                transform.m34 = -1.0/300
                transform = CATransform3DTranslate(transform, 0, scrollConfig.contentRealHeight, 0)
                // 沿着z轴旋转180度
                transform = CATransform3DRotate(transform, CGFloat.pi * -2/3, 1, 0, 0)
                transform = CATransform3DScale(transform, 1.05, 1.05, 0)
                // 使用transform
                replicatorLayer.instanceTransform = transform
            }
        } else {
            if let replicatorLayer = cell.layer as? CAReplicatorLayer {
                replicatorLayer.instanceCount = 1
                // 沿y轴移动verticalOffset高度
                var transform = CATransform3DIdentity
                transform = CATransform3DTranslate(transform, 0, scrollConfig.contentRealHeight, 0)
                // 沿着z轴旋转180度
                transform = CATransform3DRotate(transform, CGFloat.pi, 1, 0, 0.1)
                // 使用transform
                replicatorLayer.instanceTransform = transform
            }
        }
        
        // 叠影
        if scrollConfig.isContentDoubleLayer {
            if let replicatorLayer = cell.layer as? CAReplicatorLayer {
                replicatorLayer.instanceCount = 2
                // 沿y轴移动verticalOffset高度
                var transform = CATransform3DIdentity
                
                transform = CATransform3DTranslate(transform, scrollConfig.contentRealHeight * 1/5, scrollConfig.contentRealHeight * 1/5, 0)
                // 使用transform
                replicatorLayer.instanceTransform = transform
            }
        } else {
            if let replicatorLayer = cell.layer as? CAReplicatorLayer {
                replicatorLayer.instanceCount = 1
                // 沿y轴移动verticalOffset高度
                var transform = CATransform3DIdentity
                transform = CATransform3DTranslate(transform, scrollConfig.contentRealHeight * 1/5, scrollConfig.contentRealHeight * 1/5, 0)
                // 使用transform
                replicatorLayer.instanceTransform = transform
            }
        }
        
        // 倾斜
        if scrollConfig.isContentSlantEffect {
            var transform = CATransform3DIdentity
            transform.m34 = -1.0/300
            transform = CATransform3DTranslate(transform, 0, 0, 0)
            // 沿着z轴旋转180度
            transform = CATransform3DRotate(transform, CGFloat.pi * 1/4, 1.1, 0, 0)
            transform = CATransform3DScale(transform, 1.1, 1.1, 1.5)
            cell.transform3D = transform
        } else {
            let transform = CATransform3DIdentity
            cell.transform3D = transform
        }
        
        return cell;
    }
     
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return contentViewList.count * scrollConfig.repeatCount
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}
 
extension ASAutoScrollView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize(indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return scrollConfig.padding
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return scrollConfig.padding
    }

}

extension ASAutoScrollView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class ASAutoScrollCell: UICollectionViewCell {
    var contentBgView: UIView!
     
    override class var layerClass: AnyClass {
        return CAReplicatorLayer.self
    }
    
    override init(frame: CGRect) {
        contentBgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        
        super.init(frame: frame)
        setupView()
        setupReplicatorLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        contentBgView.backgroundColor = UIColor.clear
        
        addSubview(contentBgView)
        contentBgView.snp.makeConstraints {
            $0.top.right.left.bottom.equalToSuperview()
        }
    }
    
    func setupReplicatorLayer() {
        if let replicatorLayer = self.layer as? CAReplicatorLayer {
            replicatorLayer.instanceCount = 2
            var transform = CATransform3DIdentity
            
            // 使用transform
            replicatorLayer.instanceTransform = transform
            replicatorLayer.instanceRedOffset -= 0.2
            replicatorLayer.instanceGreenOffset -= 0.2
            replicatorLayer.instanceBlueOffset -= 0.2
            replicatorLayer.instanceAlphaOffset -= 0.5
        }
        
        
        
    }
    
    
}











 

