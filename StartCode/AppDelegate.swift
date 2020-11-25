//
//  AppDelegate.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/13.
//

import UIKit
import Firebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var loadingView: UIView? = nil
    
    class func instance() -> AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    func mainTabbarCtrl() -> MainTabBarController? {
        return self.window?.rootViewController as? MainTabBarController
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        FirebaseApp.configure()
        let dfs = UserDefaults.standard
        
        let pushFlag = SharedData.objectForKey(kPushSetting)
        if let _ = pushFlag {
            self.registApnsPushKey()
        }
        SharedData.instance.pToken = SharedData.objectForKey(kToken) as? String
        SharedData.instance.memUserId = SharedData.objectForKey(kMemUserid) as? String
        SharedData.instance.memId = SharedData.objectForKey(kMemId) as? String
        SharedData.instance.memJoinType = SharedData.objectForKey(kMemJoinType) as? String
        SharedData.instance.memChu = SharedData.objectForKey(kMemChu) as? Int
        
//        첫째 멤버에 id가 있으면 메인으로 간다.
        if let userId = dfs.object(forKey: kMemUserid) as? String, let token = SharedData.instance.pToken {
            print("userid: \(userId), token: \(token)")
            self.requestUpdateToken()
            self.callMainVc()
        }
        else {
            if let _ = dfs.object(forKey: kMemJoinType) as? String {
                self.callLoginVc()
            }
            else {
                self.callLgoinSelectVc()
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
        window?.rootViewController = mainTabVc
        window?.makeKeyAndVisible()
    }
    func requestUpdateToken() {
        guard let token = SharedData.objectForKey(kToken) else {
            return
        }
        let param:[String:Any] = ["akey":akey, "token":token]
        ApiManager.shared.requestUpdateToken(param: param) { (response) in
            if let response = response, let code = response["code"] as? Int {
                if code == 200 {
                    guard let user = response["user"] as?[String:Any], let token = user["token"] as? String else {
                        return
                    }
                    SharedData.instance.pToken = token
                    SharedData.setObjectForKey(token, kToken)
                }
            }
        } failure: { (error) in
            
        }
    }
    func startIndicator() {
        DispatchQueue.main.async(execute: {
            if self.loadingView == nil {
                self.loadingView = UIView(frame: UIScreen.main.bounds)
            }
            self.window!.addSubview(self.loadingView!)
            self.loadingView?.tag = 100000
            self.loadingView?.startAnimation(raduis: 25.0)
            
            //혹시라라도 indicator 계속 돌고 있으면 강제로 제거 해준다. 10초후에
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+60) {
                if let loadingView = AppDelegate.instance()?.window?.viewWithTag(100000) {
                    loadingView.removeFromSuperview()
                }
            }
        })
    }
    
    func stopIndicator() {
        DispatchQueue.main.async(execute: {
            if self.loadingView != nil {
                self.loadingView!.stopAnimation()
                self.loadingView?.removeFromSuperview()
            }
        })
    }
    
    func openUrl(_ url:String, completion: ((_ success:Bool) -> Void)?) {
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let requestUrl = URL.init(string: encodedUrl) else {
            return
        }
        UIApplication.shared.open(requestUrl, options: [:]) { (success) in
            completion?(success)
        }
    }
    
    func removeApnsPushKey() {
        Messaging.messaging().delegate = nil
    }
    func registApnsPushKey() {
        Messaging.messaging().delegate = self
        self.registerForRemoteNoti()
    }
    func registerForRemoteNoti() {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (granted: Bool, error:Error?) in
            if error == nil {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        if deviceToken.count == 0 {
            return
        }
        print("==== apns token:\(deviceToken.hexString)")
        //파이어베이스에 푸쉬토큰 등록
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // 앱이 백그라운드에있는 동안 알림 메시지를 받으면
    //이 콜백은 사용자가 애플리케이션을 시작하는 알림을 탭할 때까지 실행되지 않습니다.
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("=== apn token regist failed")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    //앱이 켜진상태, Forground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        guard let aps = userInfo["aps"] as? [String:Any], let alert = aps["alert"] as? [String:Any] else {
            return
        }
        guard let title = alert["title"] as? String else {
            return
        }
        
        var message:String?
        if let body = alert["body"] as? String {
            message = body
        }
        else if let body = alert["body"] as? [String:Any] {
            
        }
        
        guard let msg = message else {
            return
        }
        
//        AlertView.showWithOk(title: title, message: msg) { (index) in
//        }
    }
    
    //앱이 백그라운드 들어갔을때 푸쉬온것을 누르면 여기 탄다.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        guard let aps = userInfo["aps"] as? [String:Any], let alert = aps["alert"] as? [String:Any] else {
            return
        }
        //푸쉬 데이터를 어느화면으로 보낼지 판단 한고 보내 주는것 처리해야한다.
        //아직 화면 푸쉬 타입에 따른 화면 정리 안됨
        SharedData.setObjectForKey(alert, kPushUserData)
    }
}
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else {
            print("===== error: fcm token key not receive")
            return
        }
//        //uniqe한 키이다. 장비 바뀌면 바뀜, 앱지웠다 설치해다 키는 항상 같다 키체인에 저장
//        guard let udid = SharedData.objectForKey(kAPPLECATION_UUID) else {
//            return
//        }
//
//        print("==== fcm token: \(fcmToken)")
//        //앱서버에 fcmkey 올려준다.
//
//        let param = ["deviceUID":udid, "p_token":fcmToken]
//        ApiManager.shared.requestUpdateFcmToken(param: param) { (response) in
//            if let response = response as? [String:Any], let success = response["success"] as? Bool, success == true {
//                print("===== success: fcm token app server upload")
//            }
//            else {
//                print("===== fail: fcm token app server upload")
//            }
//        } failure: { (error) in
//            print("===== fail: fcm token app server upload")
//        }
    }
}

