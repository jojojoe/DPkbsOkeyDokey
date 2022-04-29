//
//  UIApplicationExtension.swift
//  TagPost
//
//  Created by Di on 2019/3/18.
//  Copyright © 2019 Di. All rights reserved.
//

import UIKit

public extension UIApplication {
    func openURL(url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    func openURL(url: String?) {
        if let str = url,
            let url = URL(string: str) {
            openURL(url: url)
        }
    }
}
