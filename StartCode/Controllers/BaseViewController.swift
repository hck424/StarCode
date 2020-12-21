//
//  BaseViewController.swift
//  PetChart
//
//  Created by 김학철 on 2020/09/26.
//

import UIKit
import Toast_Swift
import JWTDecode
//import SystemConfiguration.CaptiveNetwork
import Photos

enum SessionType: String {
    case empty = "empty"
    case expire = "expire"
    case valid = "valid"
}

class BaseViewController: UIViewController {
    var hideRightNaviBarItem = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if hideRightNaviBarItem == false {
            self.addRightNaviMyChuButton()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    func checkSession(completion:@escaping(_ type:SessionType) ->Void) {
        if let token = SharedData.instance.token {
            do {
                let jwt = try decode(jwt: token)
                print ("=== token: \(token)")
                print ("=== jwt expire date: \(String(describing: jwt.expiresAt))")
                if jwt.expired {
                    completion(.expire)
                }
                else {
                    completion(.valid)
                }
            } catch {
                completion(.expire)
            }
        }
        else {
            completion(.empty)
        }
    }
    func showToast(_ message:String?) {
        guard let message = message, message.isEmpty == false else {
            return
        }
        AppDelegate.instance()?.window?.rootViewController?.view.makeToast(message, position:.bottom)
    }
    func showLoginPopupWithCheckSession() {
        self.checkSession { (type) in
            if type == .empty || type == .empty {
                
                let vc = PopupViewController.init(type: .alert, title: "로그인 안내", message: "로그인 세션이 만료되었습니다.\n 다시로그인 해주세요.") { (vcs, selItem, index) in
                    vcs.dismiss(animated: false, completion: nil)
                    AppDelegate.instance()?.callLoginVc()
                }
                vc.addAction(.ok, "확인")
                self.present(vc, animated: true, completion: nil)
                vc.btnFullClose.isUserInteractionEnabled = false
                vc.btnClose.isHidden = true
            }
        }
    }
    func addRightNaviMyChuButton() {
        let memChu = SharedData.instance.memChu
        let chu = "\(memChu)".addComma()
        CNavigationBar.drawRight(self, chu, UIImage(named: "ic_chu"), 999, #selector(actionShowChuVc))
    }
    @objc public func actionPopViewCtrl() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc public func actionShowChuVc() {
        let vc = ChuPurchaseViewController.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func addTapGestureKeyBoardDown() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureHandler(_ :)))
        self.view.addGestureRecognizer(tap)
    }
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationHandler(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationHandler(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func tapGestureHandler(_ gesture: UITapGestureRecognizer) {
        if gesture.view == self.view {
            self.view.endEditing(true)
        }
    }
    @objc func actionKeybardDown() {
        self.view.endEditing(true)
    }
    func findBottomConstraint(_ view: UIView) -> NSLayoutConstraint? {
        
        var findConst:NSLayoutConstraint? = nil
        for const in view.constraints {
            if const.identifier == "bottom" {
                findConst = const
                break
            }
        }
        return findConst
    }
    //키보드 노티 피케이션 핸들러
    @objc func notificationHandler(_ notification: NSNotification) {
        let heightKeyboard = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size.height
        let duration = CGFloat((notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue ?? 0.0)
 
        //scrollView bottom constraint identyfier "bottom" 정의해야한다.
        let findConst = self.findBottomConstraint(self.view)
        guard let bottomContainer = findConst else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            var tabBarHeight:CGFloat = 0.0
            if self.navigationController?.tabBarController?.tabBar.isHidden == false {
                tabBarHeight = self.navigationController?.toolbar.bounds.height ?? 0.0
            }
            
            let safeBottom:CGFloat = self.view.window?.safeAreaInsets.bottom ?? 0
            bottomContainer.constant = heightKeyboard - safeBottom - tabBarHeight
            UIView.animate(withDuration: TimeInterval(duration), animations: { [self] in
                self.view.layoutIfNeeded()
            })
        }
        else if notification.name == UIResponder.keyboardWillHideNotification {
            bottomContainer.constant = 0
            UIView.animate(withDuration: TimeInterval(duration)) {
                self.view.layoutIfNeeded()
            }
        }
    }

}

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
