//
//  AppDelegate.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/13.
//

import UIKit

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
        
        let dfs = UserDefaults.standard
        if let showTutorial = dfs.object(forKey: IsShowTutorial) as? String, showTutorial == "Y" {
            self.callTutorialVc()
            dfs.setValue("Y", forKey: IsShowTutorial)
            dfs.synchronize()
        }
        else {
            //첫째 멤버에 id가 있으면 메인으로 간다.
            if let userId = dfs.object(forKey: kUserId) as? String {
                self.callMainVc()
            }
            else {
                if let joginType = dfs.object(forKey: kJoinType) as? String {
                    self.callLoginVc()
                }
                else {
                    self.callLgoinSelectVc()
                }
            }
        }
        
        return true
    }

    func callTutorialVc() {
        let vc: TutorialViewController = TutorialViewController.init()
        window?.rootViewController = vc;
        window?.makeKeyAndVisible()
    }
    
    func callLgoinSelectVc() {
        let vc = LoginSelectViewController.init()
        window?.rootViewController = BaseNavigationController.init(rootViewController: vc)
        window?.makeKeyAndVisible()
    }
    
    func callLoginVc() {
        let vc = LoginViewController.init()
        window?.rootViewController = BaseNavigationController.init(rootViewController: vc)
        window?.makeKeyAndVisible()
    }
    func callMainVc() {
        let mainTabVc = MainTabBarController.init()
        window?.rootViewController = BaseNavigationController.init(rootViewController: mainTabVc)
        window?.makeKeyAndVisible()
    }
    
}

