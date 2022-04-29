//
//  UIView+PatternColor.swift
//  Alamofire
//
//  Created by Joe on 2020/6/7.
//

import Foundation
import UIKit

extension UIColor {
    public class func seCustomGradientColor(colorSize: CGSize, gradientColors : [String] = ["2F2F2F" , "D3D3D3" ], _ position: Int = 0) -> UIColor {
        // Create size of intrinsic size for the label with current text.
        // Otherwise the gradient textColor will repeat when text is changed.
        let size = CGSize(width: colorSize.width, height: colorSize.height)
        
        // Begin image context
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        // Always remember to close the image context when leaving
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return UIColor.white; }
        
        // Create the gradient
        var  colors : [CGColor] = []
        for colorName in gradientColors {
            let color = UIColor.init(hex: colorName)
            colors.append(color.cgColor)
        }
        guard let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: colors as CFArray,
            locations: nil
            ) else { return UIColor.white; }
        
        // Draw the gradient in image context
        // 0: 左->右 1: 上->下 2:左上->右下
        var positionEndSize: CGPoint = CGPoint(x: size.width, y: 0)
        if position == 0 {
            positionEndSize = CGPoint(x: size.width, y: 0)
        } else if position == 1 {
            positionEndSize = CGPoint(x: 0, y: size.height)
        } else if position == 2 {
            positionEndSize = CGPoint(x: size.width, y: size.height)
        }
        
        
        context.drawLinearGradient(
            gradient,
            start: CGPoint.zero,
            end: positionEndSize, // Horizontal gradient
            options: []
        )
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            // Set the textColor to the new created gradient color
            return UIColor(patternImage: image)
        } else {
            return UIColor.white
        }
        
    }
    
    public class func seCustomPatternColor
        (colorSize: CGSize, patternImg : UIImage, _ position: Int = 0) -> UIColor {
        // postion 0:左、上对齐。1:居中对齐。2:右、下对齐
        
        
        
        let imageRatio = patternImg.size.width / patternImg.size.height
        let colorSizeRatio = colorSize.width / colorSize.height
        var imageTargetSize: CGSize = patternImg.size
        
        // Begin image context
        UIGraphicsBeginImageContextWithOptions(colorSize, false, UIScreen.main.scale)
        // Always remember to close the image context when leaving
        defer { UIGraphicsEndImageContext() }
//        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        
        if imageRatio > colorSizeRatio {
            // image width > colorSize width
            
            let patternImg_M = patternImg.scaled(toHeight: colorSize.height) ?? patternImg
            
            imageTargetSize.height = colorSize.height
            imageTargetSize.width = imageRatio * (colorSize.height)
            if position == 0 {
                let originalX: CGFloat = 0
                patternImg_M.draw(in: CGRect(x: originalX, y: 0, width: imageTargetSize.width, height: imageTargetSize.height))
            } else if position == 1 {
                let originalX: CGFloat = -((imageTargetSize.width - colorSize.width) / 2)
                patternImg_M.draw(in: CGRect(x: originalX, y: 0, width: imageTargetSize.width, height: imageTargetSize.height))
            } else if position == 2 {
                let originalX: CGFloat = -(imageTargetSize.width - colorSize.width)
                patternImg_M.draw(in: CGRect(x: originalX, y: 0, width: imageTargetSize.width, height: imageTargetSize.height))
            }
        } else {
            // image width < colorSize width
            let patternImg_M = patternImg.scaled(toWidth: colorSize.height) ?? patternImg
            
            imageTargetSize.width = colorSize.width
            imageTargetSize.height = colorSize.width / imageRatio
            if position == 0 {
                let originalY: CGFloat = 0
                patternImg_M.draw(in: CGRect(x: 0, y: originalY, width: imageTargetSize.width, height: imageTargetSize.height))
            } else if position == 1 {
                let originalY: CGFloat = -((imageTargetSize.height - colorSize.height) / 2)
                patternImg_M.draw(in: CGRect(x: 0, y: originalY, width: imageTargetSize.width, height: imageTargetSize.height))
            } else if position == 2 {
                let originalY: CGFloat = -(imageTargetSize.height - colorSize.height)
                patternImg_M.draw(in: CGRect(x: 0, y: originalY, width: imageTargetSize.width, height: imageTargetSize.height))
            }
        }
        
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            // Set the textColor to the new created gradient color
            return UIColor(patternImage: image)
        } else {
            return UIColor.white
        }
        
        
    }
    
    
    
    
}



extension UIColor {
    public class func seCustomGradientColorImage(colorSize: CGSize, gradientColors : [String] = ["2F2F2F" , "D3D3D3" ], _ position: Int = 0) -> UIImage? {
        // Create size of intrinsic size for the label with current text.
        // Otherwise the gradient textColor will repeat when text is changed.
        let size = CGSize(width: colorSize.width, height: colorSize.height)
        
        // Begin image context
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        // Always remember to close the image context when leaving
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil;
            
        }
        
        // Create the gradient
        var  colors : [CGColor] = []
        for colorName in gradientColors {
            let color = UIColor.init(hex: colorName)
            colors.append(color.cgColor)
        }
        guard let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: colors as CFArray,
            locations: nil
            ) else { return nil; }
        
        // Draw the gradient in image context
        // 0: 左->右 1: 上->下 2:左上->右下
        var positionEndSize: CGPoint = CGPoint(x: size.width, y: 0)
        if position == 0 {
            positionEndSize = CGPoint(x: size.width, y: 0)
        } else if position == 1 {
            positionEndSize = CGPoint(x: 0, y: size.height)
        } else if position == 2 {
            positionEndSize = CGPoint(x: size.width, y: size.height)
        }
        
        
        context.drawLinearGradient(
            gradient,
            start: CGPoint.zero,
            end: positionEndSize, // Horizontal gradient
            options: []
        )
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            // Set the textColor to the new created gradient color
            return image
        } else {
            return nil
        }
        
    }
    
    public class func seCustomPatternColorImage(colorSize: CGSize, patternImg : UIImage, _ position: Int = 0) -> UIImage? {
        // postion 0:左、上对齐。1:居中对齐。2:右、下对齐
        
        let imageRatio = patternImg.size.width / patternImg.size.height
        let colorSizeRatio = colorSize.width / colorSize.height
        var imageTargetSize: CGSize = patternImg.size
        
        // Begin image context
        UIGraphicsBeginImageContextWithOptions(colorSize, false, UIScreen.main.scale)
        // Always remember to close the image context when leaving
        defer { UIGraphicsEndImageContext() }
//        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        
        if imageRatio > colorSizeRatio {
            // image width > colorSize width
            let patternImg_M = patternImg.scaled(toHeight: colorSize.height) ?? patternImg
            
            imageTargetSize.height = colorSize.height
            imageTargetSize.width = imageRatio * (colorSize.height)
            if position == 0 {
                let originalX: CGFloat = 0
                patternImg_M.draw(in: CGRect(x: originalX, y: 0, width: imageTargetSize.width, height: imageTargetSize.height))
            } else if position == 1 {
                let originalX: CGFloat = -((imageTargetSize.width - colorSize.width) / 2)
                patternImg_M.draw(in: CGRect(x: originalX, y: 0, width: imageTargetSize.width, height: imageTargetSize.height))
            } else if position == 2 {
                let originalX: CGFloat = -(imageTargetSize.width - colorSize.width)
                patternImg_M.draw(in: CGRect(x: originalX, y: 0, width: imageTargetSize.width, height: imageTargetSize.height))
            }
        } else {
            // colorSize width
            let patternImg_M = patternImg.scaled(toWidth: colorSize.height) ?? patternImg
            
            imageTargetSize.width = colorSize.width
            imageTargetSize.height = colorSize.width / imageRatio
            if position == 0 {
                let originalY: CGFloat = 0
                patternImg_M.draw(in: CGRect(x: 0, y: originalY, width: imageTargetSize.width, height: imageTargetSize.height))
            } else if position == 1 {
                let originalY: CGFloat = -((imageTargetSize.height - colorSize.height) / 2)
                patternImg_M.draw(in: CGRect(x: 0, y: originalY, width: imageTargetSize.width, height: imageTargetSize.height))
            } else if position == 2 {
                let originalY: CGFloat = -(imageTargetSize.height - colorSize.height)
                patternImg_M.draw(in: CGRect(x: 0, y: originalY, width: imageTargetSize.width, height: imageTargetSize.height))
            }
        }
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            // Set the textColor to the new created gradient color
            return image
        } else {
            return nil
        }
    }
    
    public class func seCustomRGBColorImage(colorSize: CGSize, colorHex : String) -> UIImage? {
        // postion 0:左、上对齐。1:居中对齐。2:右、下对齐
        // Begin image context
        UIGraphicsBeginImageContextWithOptions(colorSize, false, UIScreen.main.scale)
        // Always remember to close the image context when leaving
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil; }
        let color = UIColor.init(hex: colorHex)
        
        context.setFillColor(color.cgColor)
         
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            // Set the textColor to the new created gradient color
            return image
        } else {
            return nil
        }
    }
    
    
    
}

extension UIColor {
    public convenience init(hex: String) {

        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex:   String = hex

        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }

        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
            print("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}

extension UILabel {
    
    public func updateGradientTextColor(gradientColors : [UIColor] = [UIColor(white: 0, alpha: 0.95) ,  UIColor(white: 0, alpha: 0.6) ]) {
        // Create size of intrinsic size for the label with current text.
        // Otherwise the gradient textColor will repeat when text is changed.
        let size = CGSize(width: intrinsicContentSize.width, height: 1)
        
        // Begin image context
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        // Always remember to close the image context when leaving
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Create the gradient
        var  colors : [CGColor] = []
        for color in gradientColors {
            colors.append(color.cgColor)
        }
        guard let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: colors as CFArray,
            locations: nil
            ) else { return }
        
        // Draw the gradient in image context
        context.drawLinearGradient(
            gradient,
            start: CGPoint.zero,
            end: CGPoint(x: size.width, y: 0), // Horizontal gradient
            options: []
        )
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            // Set the textColor to the new created gradient color
            self.textColor = UIColor(patternImage: image)
        }
        
    }
    
    
}
 
