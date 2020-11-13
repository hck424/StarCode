//
//  AppDelegate.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/13.
//

import UIKit
#if Cust
let baseUrl = "Dev base url"
#else
let baseUrl = "Pro base url"
#endif
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var loadingView: UIView? = nil
    
    class func instance() -> AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
//    func mainTabbarCtrl() -> MainTabBarController? {
//        return self.window?.rootViewController as? MainTabBarController
//    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        print("\(baseUrl)")
        return true
    }

//    func callTutorialVc() {
//        let vc: TutorialViewController = TutorialViewController.init()
//        window?.rootViewController = vc;
//        window?.makeKeyAndVisible()
//    }
//    func callMainVc() {
//        let mainTabVc = MainTabBarController.init()
//        window?.rootViewController = mainTabVc
//        window?.makeKeyAndVisible()
//    }
    
}

