//
//  DPbsManager.swift
//  DPbsOkeyDokey
//
//  Created by JOJO on 2022/4/18.
//

import Foundation
import UIKit
import SpriteKit
import Magnetic

struct ODStyleItem: Codable {
    var templateId: String = ""
    var iapId: String = ""
    var bgEffect: String = ""
    var textColorStr: String = ""
}

struct SAFontPointSizeItem: Codable {
    var index: String? // = "1" // 2\3\4
    var title: String? // = "small" // big very big
    var pointSize: String? // 18  32  64 字号
}

struct SASpeedItem: Codable {
   var index: String? // = "1" // 2\3\4
   var title: String? // = "small" // big very big
   var speed: String? // 18  32  64 字号
}

struct YAColorItem: Codable {
    var type: String = "rgb" // img // gra
    var colorName: String = "F0F0F0"

    func itemColor(_ colorSize: CGSize = CGSize.zero) -> UIColor {
        if type == "rgb" {
            return UIColor.init(hexString: colorName) ?? UIColor.white
        } else if type == "img" {
            
            if let img = UIImage(named: colorName) {
                let imgColor = UIColor.seCustomPatternColor(colorSize: colorSize, patternImg: img, 0)
                
                return imgColor
            } else {
                return UIColor.white
            }
        } else if type == "gra" {
            let colorNames = colorName.components(separatedBy: ",")
            let size = CGSize.init(width: colorSize.width * 1.1, height: colorSize.height * 1.1)
            let color = UIColor.seCustomGradientColor(colorSize: size, gradientColors: colorNames, 0)
            return color
        } else {
            return UIColor.white
        }
    }
     
    func img(_ imgSize: CGSize = CGSize.zero) -> UIImage? {
        if type == "img" {
            if let image = UIImage(named: colorName) {
                
                let patternImg = UIColor.seCustomPatternColorImage(colorSize: imgSize, patternImg: image, 0)
                return patternImg
            } else {
                return nil
            }
            
        } else if type == "gra" {
            let colorNames = colorName.components(separatedBy: ",")
            let image = UIColor.seCustomGradientColorImage(colorSize: imgSize, gradientColors: colorNames)
            
            return image
        } else if type == "rgb" {
            let image = UIColor.seCustomRGBColorImage(colorSize: imgSize, colorHex: colorName)
            
            return image
        } else {
            return nil
        }
    }
}

class DPbsManager: NSObject {
    static let `default` = DPbsManager()
    
    var styleList_color: [ODStyleItem] {
        return DPbsManager.default.loadJson([ODStyleItem].self, name: "StyleTemplateList_color") ?? []
    }
    var styleList_effect: [ODStyleItem] {
        return DPbsManager.default.loadJson([ODStyleItem].self, name: "StyleTemplateList_effect") ?? []
    }
    var styleList_photo: [ODStyleItem] {
        return DPbsManager.default.loadJson([ODStyleItem].self, name: "StyleTemplateList_photo") ?? []
    }
    
    var fontList_zh: [String] { DPbsManager.default.loadJson([String].self, name: "DPfont_zh") ?? []
    }
    var fontList_en: [String] { DPbsManager.default.loadJson([String].self, name: "DPfont_en") ?? []
    }
    var fontList_jp: [String] { DPbsManager.default.loadJson([String].self, name: "DPfont_jp") ?? []
    }
    
    
    /*
    var fontPointSizeList: [SAFontPointSizeItem] { DPbsManager.default.loadJson([SAFontPointSizeItem].self, name: "FontPointSizeList") ?? []
    }
    var fontColorList_TypeA: [YAColorItem] { DPbsManager.default.loadJson([YAColorItem].self, name: "FontColorList_TypeA") ?? []
    }
    var speedList: [SASpeedItem] { DPbsManager.default.loadJson([SASpeedItem].self, name: "SpeedList") ?? []
    }
     */
}


extension DPbsManager {
    func loadJson<T: Codable>(_: T.Type, name: String, type: String = "json") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                return try! JSONDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                debugPrint(error)
            }
        }
        return nil
    }
    
    func loadJson<T: Codable>(_:T.Type, path:String) -> T? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            do {
                return try PropertyListDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                print(error)
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func loadPlist<T: Codable>(_:T.Type, name:String, type:String = "plist") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            return loadJson(T.self, path: path)
        }
        return nil
    }
}


// MARK: - ImageNode
class ImageNode: Node {
    override var image: UIImage? {
        didSet {
            texture = image.map { SKTexture(image: $0) }
            fillTexture = texture
        }
    }
    /**
     The animation to execute when the node is selected.
     */
    override func selectedAnimation() {
        run(.scale(to: 4/3, duration: 0.2))
        if let texture = texture {
            self.fillTexture = texture
        }
    }
    /**
     The animation to execute when the node is deselected.
     */
    override func deselectedAnimation() {
        run(.scale(to: 1, duration: 0.2))
//        self.fillTexture = nil
//        self.fillColor = color
    }
}


