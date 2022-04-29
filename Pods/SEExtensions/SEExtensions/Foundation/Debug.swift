//
//  Debug.swift
//  BaseExtensions
//
//  Created by kemchenj on 2018/9/26.
//

import SwifterSwift

/// Debug 专用的函数，只有在 debug 模式下才会执行传入的闭包
///
/// - Parameters:
///   - action: debug 下才会执行
public func debugOnly(_ action: () -> Void) {
    assert(
        {
            action()
            return true
        }()
    )
}

public func debugLog(_ things: Any) {
    debugOnly {
        print("[\(UIApplication.shared.displayName ?? "DebugLog")]\(things)")
    }
}
