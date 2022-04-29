//
//  Device+Util.swift
//  BMBlurMask
//
//  Created by JOJO on 2019/5/29.
//  Copyright © 2019 JOJO. All rights reserved.
//

import Foundation
import SwifterSwift


public protocol DeviceUtilProtocol {}

extension UIDevice: DeviceUtilProtocol {}

public extension DeviceUtilProtocol where Self: UIDevice {
    
    static func isPad() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        } else {
            return false
        }
    }
    

    static func isZHLanguage() -> Bool {
        let language: String = UIDevice.currentLanguage()
        
        if language.contains("zh") {
            return true
        }
        return false
    }
    
    static func currentLanguage() -> String {
        
        return NSLocale.preferredLanguages.first ?? "en"
        
//        [[NSLocale preferredLanguages] objectAtIndex:0])
//
//        // 中文语言
//        #define DEF_CurrentLanguage_ZH [DEF_CurrentLanguage containsString:@"zh"]
    }
    
}

