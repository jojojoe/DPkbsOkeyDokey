//
//  String+utf8Encoded.swift
//  GRGetReport
//
//  Created by JOJO on 2019/9/12.
//  Copyright © 2019 JOJO. All rights reserved.
//

import Foundation
// MARK: - Helpers
public
extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}

//extension String {
//    func contains(find: String) -> Bool{
//        return self.range(of: find) != nil
//    }
//
//    func containsIgnoringCase(find: String) -> Bool{
//        return self.range(of: find, options: .caseInsensitive) != nil
//    }
//}
