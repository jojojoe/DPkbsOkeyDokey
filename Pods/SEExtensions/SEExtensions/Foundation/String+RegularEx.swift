//
//  String+RegularEx.swift
//  SEExtensionDemo
//
//  Created by JOJO on 2020/4/26.
//  Copyright © 2020 JOJO. All rights reserved.
//

import Foundation

extension String {

    /**
     根据 正则表达式 截取字符串

     - parameter regex: 正则表达式

     - returns: 字符串数组
     */
    public func matchesForRegex(regex: String) -> [String]? {

        do {
            let regularExpression = try NSRegularExpression(pattern: regex, options: [])
            let range = NSMakeRange(0, self.count)
            let results = regularExpression.matches(in: self, options: [], range: range)
            let string = self as NSString
            return results.map { string.substring(with: $0.range)}
        } catch {
            return nil
        }
    }
}
