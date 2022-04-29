//
//  UIImage+RoundedCorner.swift
//  GRGetReport
//
//  Created by JOJO on 2019/9/10.
//  Copyright © 2019 JOJO. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func imageAddCornerWithRadius(radius:CGFloat, imageSize:CGSize) -> UIImage {
        let rect:CGRect = CGRect.init(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
        let ctx:CGContext = UIGraphicsGetCurrentContext()!
        let path : UIBezierPath = UIBezierPath.init(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize.init(width: radius, height: radius))
        ctx.addPath(path.cgPath)
        ctx.clip()
        self.drawHierarchy(in: rect, afterScreenUpdates: true)
        ctx.drawPath(using: CGPathDrawingMode.fillStroke)
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        return newImage
        
    }
}




