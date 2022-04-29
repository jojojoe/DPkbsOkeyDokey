//
//  UIView+Corner.swift
//  SEExtensionDemo
//
//  Created by JOJO on 2020/3/25.
//  Copyright © 2020 JOJO. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    func addCornerMask(corners: UIRectCorner, cornerRadii: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: 22, height: 22))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}







