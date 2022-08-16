//
//  AppDelegate.swift
//  DPbsOkeyDokey
//
//  Created by nataliya on 2022/4/18.
//

import UIKit
import AppTrackingTransparency
import SnapKit
import SwiftyStoreKit
import TPInAppReceipt
import StoreKit


// com.feeddesign.igstorymaker
// com.xx.test.888888
let AppName: String = "InstaMate"
let purchaseUrl = ""
let TermsofuseURLStr = "http://plausible-visitor.surge.sh/Terms_of_use.html"
let PrivacyPolicyURLStr = "http://likeable-lip.surge.sh/Facial_Privacy_Policy.html"

let feedbackEmail: String = "missyoumickey009@gmail.com"
let AppAppStoreID: String = "1619053569"
 


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var isForceLandscape:Bool = false
    var isForcePortrait:Bool = false
    var isForceAllDerictions:Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupIAP()
        registerNotifications(application)
         
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
         
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
         
    }


}


extension AppDelegate {
    // 注册远程推送通知
    func registerNotifications(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.getNotificationSettings { (setting) in
            if setting.authorizationStatus == .notDetermined {
                center.requestAuthorization(options: [.badge,.sound,.alert]) { (result, error) in
                    if (result) {
                        if !(error != nil) {
                            // 注册成功
                            DispatchQueue.main.async {
                                application.registerForRemoteNotifications()
                            }
                        }
                    } else {
                        //用户不允许推送
                    }
                }
            } else if (setting.authorizationStatus == .denied){
                // 申请用户权限被拒
            } else if (setting.authorizationStatus == .authorized){
                // 用户已授权（再次获取dt）
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                // 未知错误
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let body = notification.request.content.body
        notification.request.content.userInfo
        print(body)
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("")
        let categoryIdentifier = response.notification.request.content.categoryIdentifier
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
}

extension AppDelegate {
    /// 设置屏幕支持的方向
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if isForceAllDerictions == true {
            return .all
        } else if isForceLandscape == true {
            return .landscape
        } else if isForcePortrait == true {
            return .portrait
        }
        return .portrait
    }
    
    
}

extension AppDelegate {
    func setupIAP() {
        SwiftyStoreKit.completeTransactions(atomically: true) {[weak self] purchases in
            guard let `self` = self else {return}
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break
                }
            }
            self.checkSubscription()
        }
        
        SwiftyStoreKit.shouldAddStorePaymentHandler = { (payment, product) -> Bool in
            // TODO: Store page
            return false
        }
        
        
    }

    func checkSubscription() {
        
        DPksOkeyPurchaseManager.default.isPurchased { (status) in
            debugPrint("current is in purchased \(status)")
         
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: PurchaseNotificationKeys.success),
                object: nil,
                userInfo: nil
            )
        }
         
        
    }
}
