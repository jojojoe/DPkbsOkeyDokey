//
//  Font+CustomFile.swift
//  SEExtensionDemo
//
//  Created by JOJO on 2020/3/23.
//  Copyright © 2020 JOJO. All rights reserved.
//

import Foundation
import UIKit

//public extension UIFont {
//    static func customFont(fileName: String, fontPoint: CGFloat) -> UIFont {
//        // 字体Ref没有释放 造成内存泄露 慎用！！！！！
//        let subString = "."
//
//        if let name = fileName.components(separatedBy: subString).first,
//            let type = fileName.components(separatedBy: subString).last,
//            let path = Bundle.main.path(forResource: name, ofType: type) {
//
//            debugPrint("*** font name = \(name)")
//            debugPrint("*** font type = \(type)")
//            debugPrint("*** font path = \(path)")
//
//            let fontData = NSData.init(contentsOfFile: path)
//            // ...通过CGDataProvider承载生成CGFont对象
//            let fontDataProvider = CGDataProvider(data: CFBridgingRetain(fontData) as! CFData)
//            let fontRef = CGFont.init(fontDataProvider!)!
//            // ...注册字体
//            var fontError = Unmanaged<CFError>?.init(nilLiteral: ())
//            CTFontManagerRegisterGraphicsFont(fontRef, &fontError)
//            // ...获取了字体实际名字
////            let fontName:String =  fontRef.fullName! as String
//            let fontName:String =  fontRef.postScriptName! as String
//            return UIFont.init(name: fontName, size: fontPoint) ?? UIFont.systemFont(ofSize: fontPoint)
//
//        } else {
//            return UIFont.systemFont(ofSize: fontPoint)
//        }
//    }
//}


//public extension UIFont {
//    enum FontNames: String {
//        case AvenirNextCondensedDemiBold = "AvenirNextCondensed-DemiBold"
//        case AvenirNextDemiBold = "AvenirNext-DemiBold "
//        case AvenirNextBold = "AvenirNext-Bold"
//        case AvenirHeavy = "Avenir-Heavy"
//        case AvenirMedium = "Avenir-Medium"
//        case GillSans
//        case GillSansSemiBold = "GillSans-SemiBold"
//        case GillSansSemiBoldItalic = "GillSans-SemiBoldItalic"
//        case GillSansBold = "GillSans-Bold"
//        case GillSansBoldItalic = "GillSans-BoldItalic"
//        case MontserratMedium = "Montserrat-Medium"
//        case MontserratSemiBold = "Montserrat-SemiBold"
//        case MontserratBold = "Montserrat-Bold"
//        case MontserratRegular = "Montserrat-Regular"
//    }
//
//    static func custom(_ value: CGFloat, name: FontNames) -> UIFont {
//        return UIFont(name: name.rawValue, size: value) ?? UIFont.systemFont(ofSize: value)
//    }
//}

extension String {
    ///（如果backwards参数设置为true，则返回最后出现的位置）
    func positionOf(sub:String, backwards:Bool = false)->Int {
        // 如果没有找到就返回-1
        var pos = -1
        if let range = range(of:sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = self.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
}
