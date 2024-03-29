//
//  DPbsExtensionTool.swift
//  DPbsOkeyDokey
//
//  Created by nataliya on 2022/4/18.
//

import UIKit
import Alertift
import ZKProgressHUD


public func MyColorFunc(_ red:CGFloat,_ gren:CGFloat,_ blue:CGFloat,_ alpha:CGFloat) -> UIColor? {
    let color:UIColor = UIColor(red: red/255.0, green: gren/255.0, blue: blue/255.0, alpha: alpha)
    return color
}


extension UIImage {
    func imageAtRect(rect: CGRect) -> UIImage{
        var rect = rect
        rect.origin.x *= self.scale
        rect.origin.y *= self.scale
        rect.size.width *= self.scale
        rect.size.height *= self.scale
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
}



public extension UIView {
    var safeArea: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return safeAreaInsets
        } else {
            return .zero
        }
    }

    @discardableResult
    func gradientBackground(_ colorOne: UIColor, _ colorTwo: UIColor,
                            startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0),
                            endPoint: CGPoint = CGPoint(x: 0.0, y: 1.0)) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        layer.insertSublayer(gradientLayer, at: 0)
//        layer.addSublayer(gradientLayer)
        return gradientLayer
    }
}

//自定义字体
let def_fontName = "Helvetica-Bold"
func customFont(fontName: String, size: CGFloat) -> UIFont {
    if fontName.count <= 0 || fontName == def_fontName{
        return UIFont(name: def_fontName, size: size)!
    }
    let stringArray: Array = fontName.components(separatedBy: ".")
    let path = Bundle.main.path(forResource: stringArray[0], ofType: stringArray[1])
    let fontData = NSData.init(contentsOfFile: path ?? "")
    
    let fontdataProvider = CGDataProvider(data: CFBridgingRetain(fontData) as! CFData)
    let fontRef = CGFont.init(fontdataProvider!)!
    
    var fontError = Unmanaged<CFError>?.init(nilLiteral: ())
    CTFontManagerRegisterGraphicsFont(fontRef, &fontError)
    
    let fontName: String =  fontRef.postScriptName as String? ?? ""
    
    let font = UIFont(name: fontName, size: size)
    
    return font ?? UIFont(name: def_fontName, size: size)!
}


extension String {
   /// range转换为NSRange
   func nsRange(from range: Range<String.Index>) -> NSRange {
       return NSRange(range, in: self)
   }
}

extension String {
    func getLableHeigh(font:UIFont, width:CGFloat) -> CGFloat {
        
        let size = CGSize.init(width: width, height:  CGFloat(MAXFLOAT))
        
        //        let dic = [NSAttributedStringKey.font:font] // swift 4.0
        let dic = [NSAttributedString.Key.font:font] // swift 3.0
        
        let strSize = self.boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: dic, context:nil).size
        
        return ceil(strSize.height) + 1
    }
    ///获取字符串的宽度
    func getLableWidth(font:UIFont, height:CGFloat) -> CGFloat {
        
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width)
    }
}

public extension UIViewController {
    var rootVC: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }

    var visibleVC: UIViewController? {
        return topMost(of: rootVC)
    }

    var visibleTabBarController: UITabBarController? {
        return topMost(of: rootVC)?.tabBarController
    }

    var visibleNavigationController: UINavigationController? {
        return topMost(of: rootVC)?.navigationController
    }

    private func topMost(of viewController: UIViewController?) -> UIViewController? {
        if let presentedViewController = viewController?.presentedViewController {
            return topMost(of: presentedViewController)
        }

        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return topMost(of: selectedViewController)
        }

        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return topMost(of: visibleViewController)
        }

        return viewController
    }

    func present(_ controller: UIViewController) {
        self.modalPresentationStyle = .fullScreen
        
        present(controller, animated: true, completion: nil)
    }
    
    func pushVC(_ controller: UIViewController ,animate: Bool) {
        if let navigationController = self.navigationController {
            navigationController.pushViewController(controller, animated: animate)
        } else {
            present(controller, animated: animate, completion: nil)
        }
    }
    
    func popVC() {
        if let navigationController = self.navigationController {
            navigationController.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func presentDissolve(_ controller: UIViewController, completion: (() -> Void)? = nil) {
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: completion)
    }
    
    func presentFullScreen(_ controller: UIViewController, completion: (() -> Void)? = nil) {
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: completion)
    }
    
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
}


func newDiviceIsFullScreen() -> (Bool) {
    
    guard var myKeyWindow = UIApplication.shared.keyWindow else {
        
        guard UIApplication.shared.windows.count != 0 else {
            return false
        }
        
        let keyWindow = UIApplication.shared.windows[0]
        return keyWindow.safeAreaInsets.top > CGFloat(20) ? true : false
    }
    
    myKeyWindow = UIApplication.shared.keyWindow!
    return myKeyWindow.safeAreaInsets.top > CGFloat(20) ? true : false
}

//UIView 转 UIimage
func getImageFromView(view: UIView) -> UIImage{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
    let content = UIGraphicsGetCurrentContext()!
    content.setFillColor(UIColor.clear.cgColor)
    view.layer.render(in: content)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
    
}

func getImageFromView(view: UIView, size: CGSize) -> UIImage{
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    let content = UIGraphicsGetCurrentContext()!
    content.setFillColor(UIColor.clear.cgColor)
    view.layer.render(in: content)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
    
}

extension UIImage {
    
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UIView {
    func changeToImage() -> UIImage {
        let size = self.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        self.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func changeToTranslucentImage() -> UIImage {
        let size = self.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

public class Once {
    var already: Bool = false
    
    public init() {}
    
    public func run(_ block: () -> Void) {
        guard !already else {
            return
        }
        
        block()
        already = true
    }
}

extension UIApplication {
    @objc
    public static var rootController: UIViewController? {
        return shared.keyWindow?.rootViewController
    }
}

public struct Alert {
    public static func error(_ value: String?, title: String? = "Error", success: (() -> Void)? = nil) {
        
        HUD.hide()
        Alertift
            .alert(title: title, message: value)
            .action(.cancel("OK"), handler: { _, _, _ in
                success?()
            })
            .show(on: UIApplication.rootController?.visibleVC, completion: nil)
    }

    public static func message(_ value: String?, success: (() -> Void)? = nil) {
        
        HUD.hide()
        Alertift
            .alert(message: value)
            .action(.cancel("OK"), handler: { _, _, _ in
                success?()
            })
            .show(on: UIApplication.rootController?.visibleVC, completion: nil)
    }
}
public struct HUD {
    public static func show() {
        guard !ZKProgressHUD.isShowing else { return }
        ZKProgressHUD.show()
    }
    
    public static func hide() {
        ZKProgressHUD.dismiss()
    }
    
    
    public static func error(_ value: String? = nil) {
        hide()
        ZKProgressHUD.showError(value, autoDismissDelay: 2.0)
    }
    
    public static func success(_ value: String? = nil) {
        hide()
        ZKProgressHUD.showSuccess(value, autoDismissDelay: 2.0)
    }
    
    public static func progress(_ value: CGFloat?) {
        ZKProgressHUD.showProgress(value)
    }
    
    public static func progress(_ value: CGFloat?, status: String? = nil) {
        
        ZKProgressHUD.showProgress(value, status: status, onlyOnceFont: UIFont(name: "Avenir-Black", size: 14))
    }
}


extension UITextView {
    
    private struct RuntimeKey {
        static let hw_placeholderLabelKey = UnsafeRawPointer.init(bitPattern: "hw_placeholderLabelKey".hashValue)
        /// ...其他Key声明
    }
    /// 占位文字
    @IBInspectable public var placeholder: String {
        get {
            return self.placeholderLabel.text ?? ""
        }
        set {
            self.placeholderLabel.text = newValue
        }
    }
    
    /// 占位文字颜色
    @IBInspectable public var placeholderColor: UIColor {
        get {
            return self.placeholderLabel.textColor
        }
        set {
            self.placeholderLabel.textColor = newValue
        }
    }
    
    private var placeholderLabel: UILabel {
        get {
            var label = objc_getAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!) as? UILabel
            if label == nil { // 不存在是 创建 绑定
                if (self.font == nil) { // 防止没大小时显示异常 系统默认设置14
                    self.font = UIFont.systemFont(ofSize: 14)
                }
                label = UILabel.init(frame: self.bounds)
                label?.numberOfLines = 0
                label?.font = UIFont.systemFont(ofSize: 14)//self.font
                label?.textColor = UIColor.lightGray
                label?.textAlignment = self.textAlignment
                self.addSubview(label!)
                self.setValue(label!, forKey: "_placeholderLabel")
                objc_setAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!, label!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.sendSubviewToBack(label!)
            } else {
                label?.font = self.font
                label?.textColor = label?.textColor.withAlphaComponent(0.6)
            }
            return label!
        }
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

@objc
public class HUDClass: NSObject {
    @objc
    public static func show() {
        guard !ZKProgressHUD.isShowing else { return }
        ZKProgressHUD.show()
    }
    
    @objc
    public static func hide() {
        ZKProgressHUD.dismiss()
    }
}


public extension UIApplication {
    @discardableResult
    func openURL(url: URL) -> Bool {
        guard UIApplication.shared.canOpenURL(url) else { return false }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        return true
    }
    
    @discardableResult
    func openURL(url: String?) -> Bool {
        guard let str = url, let url = URL(string: str) else { return false }
        return openURL(url: url)
    }
}



extension UIDevice {
    
    ///The device model name, e.g. "iPhone 6s", "iPhone SE", etc
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iphone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}




public extension String {
    
    var toDictionary: [String:AnyObject]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)]) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    var toArray: [[String: AnyObject]]? {
        if let jsonData:Data = self.data(using: String.Encoding.utf8) {
            do {
                let array = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [[String: AnyObject]]
                return array
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
}

public extension Dictionary {
    var toDictionary: String {
        var result:String = ""
        do {
            //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                result = JSONString
            }
            
        } catch {
            result = ""
        }
        return result
    }
    
    
}

public extension Array {
    
    var toString: String {
        var result:String = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                result = JSONString
            }
            
        } catch {
            result = ""
        }
        return result
    }
    
}



public extension UIView {
    @discardableResult
    func crop() -> Self {
        contentMode()
        clipsToBounds()
        return self
    }
    
    @discardableResult
    func alpha(_ value: CGFloat) -> Self {
        alpha = value
        return self
    }
    
    @discardableResult
    func hidden(_ value: Bool = true) -> Self {
        isHidden = value
        return self
    }
    
    @discardableResult
    func show(_ value: Bool = true) -> Self {
        isHidden = !value
        return self
    }
    
    @discardableResult
    func cornerRadius(_ value: CGFloat, masksToBounds: Bool = true) -> Self {
        layer.cornerRadius = value
        layer.masksToBounds = masksToBounds
        return self
    }
    
    @discardableResult
    func borderColor(_ value: UIColor, width: CGFloat = 1) -> Self {
        layer.borderColor = value.cgColor
        layer.borderWidth = width
        return self
    }
    
    @discardableResult
    func contentMode(_ value: UIView.ContentMode = .scaleAspectFill) -> Self {
        contentMode = value
        return self
    }
    
    @discardableResult
    func clipsToBounds(_ value: Bool = true) -> Self {
        clipsToBounds = value
        return self
    }
    
    @discardableResult
    func tag(_ value: Int) -> Self {
        tag = value
        return self
    }
    
    @discardableResult
    func tintColor(_ value: UIColor) -> Self {
        tintColor = value
        return self
    }
    
    @discardableResult
    func backgroundColor(_ value: UIColor) -> Self {
        backgroundColor = value
        return self
    }
    
    @discardableResult
    func isUserInteractionEnabled(_ value: Bool = true) -> Self {
        isUserInteractionEnabled = value
        return self
    }
}

public extension UIFont {
    enum FontNames: String {
        case AvenirNextCondensedDemiBold = "AvenirNextCondensed-DemiBold"
        case AvenirNextDemiBold = "AvenirNext-DemiBold "
        case AvenirNextBold = "AvenirNext-Bold"
        case AvenirHeavy = "Avenir-Heavy"
        case AvenirMedium = "Avenir-Medium"
        case GillSans
        case GillSansSemiBold = "GillSans-SemiBold"
        case GillSansSemiBoldItalic = "GillSans-SemiBoldItalic"
        case GillSansBold = "GillSans-Bold"
        case GillSansBoldItalic = "GillSans-BoldItalic"
        case MontserratMedium = "Montserrat-Medium"
        case MontserratSemiBold = "Montserrat-SemiBold"
        case MontserratBold = "Montserrat-Bold"
        case MontserratRegular = "Montserrat-Regular"
    }
    
    static func custom(_ value: CGFloat, name: FontNames) -> UIFont {
        return UIFont(name: name.rawValue, size: value) ?? UIFont.systemFont(ofSize: value)
    }
}

public extension UILabel {
    @discardableResult
    func text(_ value: String?) -> Self {
        text = value
        return self
    }
    
    @discardableResult
    func color(_ value: UIColor) -> Self {
        textColor = value
        return self
    }
    
    @discardableResult
    func font(_ value: CGFloat, _ bold: Bool = false) -> Self {
        font = bold ? UIFont.boldSystemFont(ofSize: value) : UIFont.systemFont(ofSize: value)
        return self
    }
    
    @discardableResult
    func font(_ value: CGFloat, _ name: UIFont.FontNames) -> Self {
        font = UIFont(name: name.rawValue, size: value)
        return self
    }
    
    @discardableResult
    func fontName(_ value: CGFloat, _ name: String) -> Self {
        font = UIFont(name: name, size: value)
        return self
    }
    
    @discardableResult
    func numberOfLines(_ value: Int = 0) -> Self {
        numberOfLines = value
        return self
    }
    
    @discardableResult
    func adjustsFontSizeToFitWidth(_ value: Bool = true) -> Self {
        adjustsFontSizeToFitWidth = value
        return self
    }
    
    
    @discardableResult
    func textAlignment(_ value: NSTextAlignment) -> Self {
        textAlignment = value
        return self
    }
    
    @discardableResult
    func lineBreakMode(_ value: NSLineBreakMode = .byTruncatingTail) -> Self {
        lineBreakMode = value
        return self
    }
}

public extension CGSize {
    init(sideLength: Int) {
        self.init(width: sideLength, height: sideLength)
    }

    init(sideLength: Double) {
        self.init(width: sideLength, height: sideLength)
    }

    init(sideLength: CGFloat) {
        self.init(width: sideLength, height: sideLength)
    }

    var longSide: CGFloat {
        return max(width, height)
    }

    var shortSide: CGFloat {
        return min(width, height)
    }
}
 
public extension UIImage {
    static func with(
        color: UIColor,
        size: CGSize = CGSize(sideLength: 1),
        opaque: Bool = false,
        scale: CGFloat = 0
    ) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)

        UIGraphicsBeginImageContextWithOptions(rect.size, opaque, scale)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        context.setFillColor(color.cgColor)
        context.fill(rect)

        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func tinted(with color: UIColor, opaque: Bool = false) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, opaque, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }

        guard
            let context = UIGraphicsGetCurrentContext(),
            let cgImage = self.cgImage
        else { return nil }

        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)

        let rect = CGRect(origin: .zero, size: size)

        context.setBlendMode(.normal)
        context.draw(cgImage, in: rect)

        context.setBlendMode(.sourceIn)
        context.setFillColor(color.cgColor)
        context.fill(rect)

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
public extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        setBackgroundImage(UIImage.with(color: color), for: state)
    }
}

public extension UIButton {
    @discardableResult
    func title(_ value: String?, _ state: UIControl.State = .normal) -> Self {
        setTitle(value, for: state)
        return self
    }
    
    @discardableResult
    func titleColor(_ value: UIColor, _ state: UIControl.State = .normal) -> Self {
        setTitleColor(value, for: state)
        return self
    }
    
    @discardableResult
    func image(_ value: UIImage?, _ state: UIControl.State = .normal) -> Self {
        setImage(value, for: state)
        return self
    }
    
    @discardableResult
    func backgroundImage(_ value: UIImage?, _ state: UIControl.State = .normal) -> Self {
        setBackgroundImage(value, for: state)
        return self
    }
    
    @discardableResult
    func backgroundColor(_ value: UIColor, _ state: UIControl.State = .normal) -> Self {
        setBackgroundColor(value, for: state)
        return self
    }
    
    @discardableResult
    func font(_ value: CGFloat, _ bold: Bool = false) -> Self {
        titleLabel?.font(value, bold)
        return self
    }
    @discardableResult
    func font(_ value: CGFloat, _ name: String) -> Self {
        titleLabel?.fontName(value, name)
        return self
    }
    @discardableResult
    func font(_ value: CGFloat, _ name: UIFont.FontNames) -> Self {
        titleLabel?.font(value, name)
        return self
    }
    
    @discardableResult
    func lineBreakMode(_ value: NSLineBreakMode = .byTruncatingTail) -> Self {
        titleLabel?.lineBreakMode(value)
        return self
    }
    
    @discardableResult
    func isEnabled(_ value: Bool = false) -> Self {
        isEnabled = value
        return self
    }
    
    @discardableResult
    func showsTouch(_ value: Bool = true) -> Self {
        showsTouchWhenHighlighted = value
        return self
    }
}

public extension UIImageView {
    @discardableResult
    func image(_ value: String?, _: Bool = false) -> Self {
        guard let value = value else { return self }
        image = UIImage(named: value)
        return self
    }
    
    func image(_ valueImg: UIImage?) -> Self {
        guard let valueImg = valueImg else { return self }
        image = valueImg
        return self
    }
    
}


public extension UIDevice {
    static var isPad: Bool {
        return current.userInterfaceIdiom == .pad
    }
    
    static var isPhone: Bool {
        return current.userInterfaceIdiom == .phone
    }
}


public protocol ViewChainable {}

public extension ViewChainable where Self: AnyObject {
    @discardableResult
    func config(_ config: (Self) -> Void) -> Self {
        config(self)
        return self
    }
    
    @discardableResult
    func set<T>(_ keyPath: ReferenceWritableKeyPath<Self, T>, to value: T) -> Self {
        self[keyPath: keyPath] = value
        return self
    }
}


extension UIView: ViewChainable {
    @discardableResult
    public func config(cornerRadius: CGFloat, masksToBounds: Bool = true) -> Self {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = masksToBounds
        
        return self
    }
    
    @discardableResult
    public func configBorder(color: UIColor, width: CGFloat? = nil) -> Self {
        layer.borderColor = color.cgColor
        if let borderWidth = width {
            layer.borderWidth = borderWidth
        }
        
        return self
    }
    
    @discardableResult
    public func configShadow(
        color: UIColor?,
        radius: CGFloat? = nil,
        opacity: Float? = nil,
        offset: CGSize? = nil,
        path: CGPath? = nil
    ) -> Self {
        layer.shadowColor = color?.cgColor
        
        if let radius = radius {
            layer.shadowRadius = radius
        }
        
        if let opacity = opacity {
            layer.shadowOpacity = opacity
        }
        
        if let offset = offset {
            layer.shadowOffset = offset
        }
        
        if let path = path {
            layer.shadowPath = path
        }
        
        return self
    }
    
    @discardableResult
    public func adhere(toSuperview superview: UIView) -> Self {
        superview.addSubview(self)
        return self
    }
    
    @discardableResult
    public func adhere(toSuperview superview: UIView, below siblingView: UIView) -> Self {
        superview.insertSubview(self, belowSubview: siblingView)
        return self
    }
    
    @discardableResult
    public func adhere(toSuperview superview: UIView, above siblingView: UIView) -> Self {
        superview.insertSubview(self, aboveSubview: siblingView)
        return self
    }
    
    @discardableResult
    public func layout(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    
    @discardableResult
    public func layout(x: CGFloat? = nil, y: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        var newFrame = frame
        
        if let x = x {
            newFrame.origin.x = x
        }
        if let y = y {
            newFrame.origin.y = y
        }
        if let width = width {
            newFrame.size.width = width
        }
        if let height = height {
            newFrame.size.height = height
        }
        
        return layout(newFrame)
    }
}


extension UIColor {
    
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}

extension UIImage {
    
    class func createImage(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
        //            self.init(cgImage: (image?.cgImage)!)
    }
    
    
    func scaleImage(scaleSize: CGFloat) -> UIImage  {
        let reSize = CGSize(width: self.size.width * scaleSize,  height: self.size.height * scaleSize)
        return  reSizeImage(reSize: reSize)
    }
    
    func reSizeImage(reSize: CGSize) -> UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize, false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    func myImageWithTintColor(color: UIColor, rect: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: rect.size.width, height: rect.size.height), false, 0.0)
        color.setFill()
        UIRectFill(rect)
        
        self.draw(in: rect, blendMode: .screen, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return tintedImage
    }
    
    /**
     * 改变UIimage 的 imageOrientation 为 .up
     */
    func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        
        var transform = CGAffineTransform.identity
        
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
            break
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi / 2)
            break
            
        default:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1)
            break
            
        default:
            break
        }
        
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.height), height: CGFloat(size.width)))
            break
            
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height)))
            break
        }
        
        let cgimg: CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)
        
        return img
    }
    
    func originImageToScaleSize(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage ?? UIImage()
    }
}


// MARK: - Methods
public extension UIViewController {

     
    /// SwifterSwift: Helper method to display an alert on any UIViewController subclass. Uses UIAlertController to show an alert
    ///
    /// - Parameters:
    ///   - title: title of the alert
    ///   - message: message/body of the alert
    ///   - buttonTitles: (Optional)list of button titles for the alert. Default button i.e "OK" will be shown if this paramter is nil
    ///   - highlightedButtonIndex: (Optional) index of the button from buttonTitles that should be highlighted. If this parameter is nil no button will be highlighted
    ///   - completion: (Optional) completion block to be invoked when any one of the buttons is tapped. It passes the index of the tapped button as an argument
    /// - Returns: UIAlertController object (discardable).
    @discardableResult
    func showAlert(title: String?, message: String?, buttonTitles: [String]? = nil, highlightedButtonIndex: Int? = nil, completion: ((Int) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var allButtons = buttonTitles ?? [String]()
        if allButtons.count == 0 {
            allButtons.append("OK")
        }

        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                completion?(index)
            })
            alertController.addAction(action)
            // Check which button to highlight
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                alertController.preferredAction = action
            }
        }
        present(alertController, animated: true, completion: nil)
        return alertController
    }

  

}


public extension UIScreen {
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }

    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
}

public extension UIScreen {
    static var isWidthLessThen4_7inch: Bool {
        return UIScreen.main.bounds.width < 375
    }

    static var isHeightLessThen4_7inch: Bool {
        return UIScreen.main.bounds.height < 667
    }

    static var isLessThen4_7inch: Bool {
        return isWidthLessThen4_7inch || isHeightLessThen4_7inch
    }

    static var minLineWidth: CGFloat {
        return 1 / UIScreen.main.scale
    }
}

extension UIColor {
//    public class func seCustomGradientColorImage(colorSize: CGSize, gradientColors : [String] = ["2F2F2F" , "D3D3D3" ], _ position: Int = 0) -> UIImage? {
//        // Create size of intrinsic size for the label with current text.
//        // Otherwise the gradient textColor will repeat when text is changed.
//        let size = CGSize(width: colorSize.width, height: colorSize.height)
//
//        // Begin image context
//        UIGraphicsBeginImageContextWithOptions(size, false, 0)
//        // Always remember to close the image context when leaving
//        defer { UIGraphicsEndImageContext() }
//        guard let context = UIGraphicsGetCurrentContext() else {
//            return nil;
//
//        }
//
//        // Create the gradient
//        var  colors : [CGColor] = []
//        for colorName in gradientColors {
//            let color = UIColor.init(hex: colorName)
//            colors.append(color.cgColor)
//        }
//        guard let gradient = CGGradient(
//            colorsSpace: CGColorSpaceCreateDeviceRGB(),
//            colors: colors as CFArray,
//            locations: nil
//            ) else { return nil; }
//
//        // Draw the gradient in image context
//        // 0: 左->右 1: 上->下 2:左上->右下
//        var positionEndSize: CGPoint = CGPoint(x: size.width, y: 0)
//        if position == 0 {
//            positionEndSize = CGPoint(x: size.width, y: 0)
//        } else if position == 1 {
//            positionEndSize = CGPoint(x: 0, y: size.height)
//        } else if position == 2 {
//            positionEndSize = CGPoint(x: size.width, y: size.height)
//        }
//
//
//        context.drawLinearGradient(
//            gradient,
//            start: CGPoint.zero,
//            end: positionEndSize, // Horizontal gradient
//            options: []
//        )
//        if let image = UIGraphicsGetImageFromCurrentImageContext() {
//            // Set the textColor to the new created gradient color
//            return image
//        } else {
//            return nil
//        }
//
//    }
    
//    public class func seCustomPatternColorImage(colorSize: CGSize, patternImg : UIImage, _ position: Int = 0) -> UIImage? {
//        // postion 0:左、上对齐。1:居中对齐。2:右、下对齐
//
//        let imageRatio = patternImg.size.width / patternImg.size.height
//        let colorSizeRatio = colorSize.width / colorSize.height
//        var imageTargetSize: CGSize = patternImg.size
//
//        // Begin image context
//        UIGraphicsBeginImageContextWithOptions(colorSize, false, UIScreen.main.scale)
//        // Always remember to close the image context when leaving
//        defer { UIGraphicsEndImageContext() }
////        guard let context = UIGraphicsGetCurrentContext() else { return }
//
//
//        if imageRatio > colorSizeRatio {
//            // image width > colorSize width
//            let patternImg_M = patternImg.scaled(toHeight: colorSize.height) ?? patternImg
//
//            imageTargetSize.height = colorSize.height
//            imageTargetSize.width = imageRatio * (colorSize.height)
//            if position == 0 {
//                let originalX: CGFloat = 0
//                patternImg_M.draw(in: CGRect(x: originalX, y: 0, width: imageTargetSize.width, height: imageTargetSize.height))
//            } else if position == 1 {
//                let originalX: CGFloat = -((imageTargetSize.width - colorSize.width) / 2)
//                patternImg_M.draw(in: CGRect(x: originalX, y: 0, width: imageTargetSize.width, height: imageTargetSize.height))
//            } else if position == 2 {
//                let originalX: CGFloat = -(imageTargetSize.width - colorSize.width)
//                patternImg_M.draw(in: CGRect(x: originalX, y: 0, width: imageTargetSize.width, height: imageTargetSize.height))
//            }
//        } else {
//            // colorSize width
//            let patternImg_M = patternImg.scaled(toWidth: colorSize.height) ?? patternImg
//
//            imageTargetSize.width = colorSize.width
//            imageTargetSize.height = colorSize.width / imageRatio
//            if position == 0 {
//                let originalY: CGFloat = 0
//                patternImg_M.draw(in: CGRect(x: 0, y: originalY, width: imageTargetSize.width, height: imageTargetSize.height))
//            } else if position == 1 {
//                let originalY: CGFloat = -((imageTargetSize.height - colorSize.height) / 2)
//                patternImg_M.draw(in: CGRect(x: 0, y: originalY, width: imageTargetSize.width, height: imageTargetSize.height))
//            } else if position == 2 {
//                let originalY: CGFloat = -(imageTargetSize.height - colorSize.height)
//                patternImg_M.draw(in: CGRect(x: 0, y: originalY, width: imageTargetSize.width, height: imageTargetSize.height))
//            }
//        }
//
//        if let image = UIGraphicsGetImageFromCurrentImageContext() {
//            // Set the textColor to the new created gradient color
//            return image
//        } else {
//            return nil
//        }
//    }
    
//    public class func seCustomRGBColorImage(colorSize: CGSize, colorHex : String) -> UIImage? {
//        // postion 0:左、上对齐。1:居中对齐。2:右、下对齐
//        // Begin image context
//        UIGraphicsBeginImageContextWithOptions(colorSize, false, UIScreen.main.scale)
//        // Always remember to close the image context when leaving
//        defer { UIGraphicsEndImageContext() }
//        guard let context = UIGraphicsGetCurrentContext() else { return nil; }
//        let color = UIColor.init(hex: colorHex)
//        
//        context.setFillColor(color.cgColor)
//         
//        if let image = UIGraphicsGetImageFromCurrentImageContext() {
//            // Set the textColor to the new created gradient color
//            return image
//        } else {
//            return nil
//        }
//    }
    
    
    
}

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
 






