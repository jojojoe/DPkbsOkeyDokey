//
//  SceneDelegate.swift
//  DPbsOkeyDokey
//
//  Created by nataliya on 2022/4/18.
//

import UIKit
import AppTrackingTransparency
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var mainVC: DPkbsPreviewVC = DPkbsPreviewVC()

    func initMainVC() {
    
        let nav = UINavigationController.init(rootViewController: mainVC)
        nav.isNavigationBarHidden = true
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        
        
        
        #if DEBUG
        for fy in UIFont.familyNames {
            let fts = UIFont.fontNames(forFamilyName: fy)
            for ft in fts {
                debugPrint("***fontName = \(ft)")
            }
        }
        #endif
    }
    
    func appTrackingPermission() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    
                })
            } else {
                
            }
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
         
        guard let _ = (scene as? UIWindowScene) else { return }
        initMainVC()
        forceOrientationLandscape()
        
    }
    func sceneDidDisconnect(_ scene: UIScene) {
         
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        appTrackingPermission()
    }

    func sceneWillResignActive(_ scene: UIScene) {
         
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
         
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
         
    }


}

extension SceneDelegate {
    // 强制旋转横屏
    func forceOrientationLandscape() {
        let appdelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appdelegate.isForceLandscape = true
        appdelegate.isForcePortrait = false
        _ = appdelegate.application(UIApplication.shared, supportedInterfaceOrientationsFor: mainVC.view.window)
        let oriention = UIInterfaceOrientation.landscapeRight // 设置屏幕为横屏
        UIDevice.current.setValue(oriention.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    // 强制旋转竖屏
    func forceOrientationPortrait() {
        let appdelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.isForceLandscape = false
        appdelegate.isForcePortrait = true
        _ = appdelegate.application(UIApplication.shared, supportedInterfaceOrientationsFor: mainVC.view.window)
        let oriention = UIInterfaceOrientation.portrait // 设置屏幕为竖屏
        UIDevice.current.setValue(oriention.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
}


/*
 
 超赞的打Call表白神器！
 让你的手机秒变移动的弹幕LED发射器！
 手持手机弹幕LED，在演唱会上让爱豆一眼就能在人群中看到你！
 无论是在演唱会，酒吧，生日派对，机场接机，搭讪表白，夜店打Call，只需在手持弹幕中输入文字，举起手机，就能怒刷一波存在感！
 
 产品特点：
 -丰富的字体、颜色，让手机弹幕来替你传达爱意吧
 -滚动LED字幕更炫丽，百变弹幕不重样，十余种背景特效任你挑选
 -支持英文、中文、日文字体
 
 应用场景：
 1.LED灯牌
 2.应援灯牌
 3.表白广告
 4.夜店打Call
 5.机场接人手持广告牌
 
 
 关键词：
 灯牌 弹幕 led 嗨弹幕 字幕 应援 显示屏 表白 提词器 投屏 爱追星 滚动字幕 特效 手持弹幕 led显示屏 滚动 打call 演唱会
 
 关键词：
 
 led lights,led hue,led,led dmx,led ble,led mood light,idol,effect,aura led,ge lights,billboard for iphone,
 banner,led scroller,placard,concert call,跑馬燈,powerled,弹幕
 
 
 */

/*
 
 The awesome call confession artifact!
  Turn your phone into a mobile barrage LED launcher in seconds!
  Holding the mobile phone barrage LED, at the concert, idols can see you in the crowd at a glance!
  Whether it's at a concert, bar, birthday party, airport pick-up, pick up a conversation, or make a call in a nightclub, just enter text in the hand-held barrage, hold up the phone, and you can get a wave of presence!
  
  Features:
  - Rich fonts and colors, let the mobile phone barrage convey love for you
  - The scrolling LED subtitles are more dazzling, the ever-changing barrage is not repeated, and there are more than ten background effects for you to choose from
  - Support English, Chinese, Japanese fonts
  
  Application scenarios:
  1. LED lights
  2. Aid light sign
  3. Confession advertising
  4. Call the nightclub
  5. Pick up people at the airport and hold billboards
  
 
 */

