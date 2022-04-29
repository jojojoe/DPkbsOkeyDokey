//
//  View+Interface.swift
//  BMBlurMask
//
//  Created by JOJO on 2019/5/22.
//  Copyright © 2019 JOJO. All rights reserved.
//

import Foundation
import UIKit

public protocol ViewInterFaceLoad {}

extension UIView: ViewInterFaceLoad {}

public extension ViewInterFaceLoad where Self: UIView {
    static func loadNib(_ nibNmae :String? = nil) -> Self{
        return Bundle.main.loadNibNamed(nibNmae ?? "\(self)", owner: nil, options: nil)?.first as! Self
    }
    
}
