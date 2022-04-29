//
//  UIView+ScreenShot.swift
//  Alertift
//
//  Created by Joe on 2020/5/5.
//

import Foundation
extension UIView {
    func takeScreenshot(targetScreenView: UIView?) -> UIImage {
        var imageSize = CGSize.zero
        var screenSize = UIScreen.main.bounds.size
        if let targetView = targetScreenView {
            screenSize = targetView.bounds.size
        }
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation.isPortrait {
            imageSize = screenSize
        } else {
            imageSize = CGSize(width: screenSize.height, height: screenSize.width)
        }
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            
            if let targetView = targetScreenView {
                // view
                if targetView.responds(to: #selector(UIView.drawHierarchy(in:afterScreenUpdates:))) {
                    targetView.drawHierarchy(in: targetView.bounds, afterScreenUpdates: true)
                } else {
                    targetView.layer.render(in: context)
                }
                
            } else {
                // window
                for window in UIApplication.shared.windows {
                    context.saveGState()
                    context.translateBy(x: window.center.x, y: window.center.y)
                    context.concatenate(window.transform)
                    context.translateBy(x: -window.bounds.size.width * window.layer.anchorPoint.x, y: -window.bounds.size.height * window.layer.anchorPoint.y)
                    
                    if orientation == UIInterfaceOrientation.landscapeLeft {
                        context.rotate(by: .pi / 2)
                        context.translateBy(x: 0, y: -imageSize.width)
                    } else if orientation == UIInterfaceOrientation.landscapeRight {
                        context.rotate(by: -.pi / 2)
                        context.translateBy(x: -imageSize.height, y: 0)
                    } else if orientation == UIInterfaceOrientation.portraitUpsideDown {
                        context.rotate(by: .pi)
                        context.translateBy(x: -imageSize.width, y: -imageSize.height)
                    }
                    if window.responds(to: #selector(UIView.drawHierarchy(in:afterScreenUpdates:))) {
                        window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
                    } else {
                        window.layer.render(in: context)
                    }
                    context.restoreGState()
                }
            }
            
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image {
            return image
        } else {
            return UIImage()
        }
    }
}
