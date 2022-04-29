//
//  VC+Interface.swift
//  PhotoWatermark
//
//  Created by Conver on 5/7/19.
//  Copyright © 2019 Conver. All rights reserved.
//

import SwifterSwift

// MARK: - InterFaceLoad

public protocol InterFaceLoad {}

extension UIViewController: InterFaceLoad {}

public extension InterFaceLoad where Self: UIViewController {
    static func loadFromIB(_ ibNameOrNil: String? = nil) -> Self {
        let ibName = ibNameOrNil ?? className
        let controller = UIStoryboard(name: ibName, bundle: nil)
            .instantiateInitialViewController() as! Self
        return controller
    }
}







