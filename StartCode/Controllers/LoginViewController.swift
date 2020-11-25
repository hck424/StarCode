//
//  LoginViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/13.
//

import UIKit
import FirebaseMessaging

class LoginViewController: BaseViewController {

    @IBOutlet weak var tfUserId: CTextField!
    @IBOutlet weak var tfPassword: CTextField!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnFindId: UIButton!
    @IBOutlet weak var btnFindPw: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnAndroid: CButton!
    @IBOutlet weak var btnIos: CButton!
    @IBOutlet weak var lbHitId: UILabel!
    @IBOutlet weak var lbHitPassword: UILabel!
    @IBOutlet weak var bottomContainer: NSLayoutConstraint!
    
    var focusTf: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTapGestureKeyBoardDown()
        btnCheck.isSelected = true
        
        if let joinType = SharedData.instance.memJoinType, joinType == "none" {
            if let userId = SharedData.instance.memUserId {
                tfUserId.text = userId
            }
            if let password = SharedData.objectForKey(kMemPassword) as? String {
                tfPassword.text = password
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.addKeyboardNotification()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotification()
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender == btnCheck {
            sender.isSelected = !sender.isSelected
        }
        else if sender == btnFindId {
            let vc = MrInfoModifyViewController.init(type: .findId)
            self.present(vc, animated: false, completion: nil)
        }
        else if sender == btnFindPw {
            let vc = MrInfoModifyViewController.init(type: .findPw)
            self.present(vc, animated: false, completion: nil)
        }
        else if sender == btnAndroid {
            
        }
        else if sender == btnIos {
            
        }
        else if sender == btnSignIn {
            var isOk = true
            lbHitId.isHidden = true
            lbHitPassword.isHidden = true
            if let userId = tfUserId.text, userId.isEmpty == true {
                isOk = false
                lbHitId.isHidden = false
            }
            if let password = tfPassword.text, password.isEmpty == true {
                isOk = false
                lbHitPassword.isHidden = false
            }
            
            if isOk == false {
                return
            }
            
            var param:[String:Any] = ["akey":akey, "userid": tfUserId.text!, "password": tfPassword.text!, "platform":"ios", "device_id":Utility.getUUID(),"join_type":"none"]
            
            if let fcmToken = Messaging.messaging().fcmToken {
                param["push_token"] = fcmToken
            }
            
            ApiManager.shared.requestMemberSignIn(param: param) { (response) in
                if let response = response, let code = response["code"] as? Int {
                    if code == 200 {
                        guard let user = response["user"] as? [String:Any] else {
                            return
                        }
                        SharedData.instance.saveUserInfo(user: user)
                        SharedData.setObjectForKey(self.tfPassword.text!, kMemPassword)
                        AppDelegate.instance()?.callMainVc()
                    }
                    else {
                        if let message = response["message"] as? String {
                            self.view.makeToast(message)
                        }
                    }
                }
            } failure: { (error) in
                self.showErrorAlertView(error)
            }
        }
        else if sender == btnSignUp {
            let vc = MrTermsViewController.init()
            vc.user = UserInfo.init(JSON: ["join_type":"none"])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func notificationHandler(_ notification: NSNotification) {
        let heightKeyboard = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size.height
        let duration = CGFloat((notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue ?? 0.0)
 
        if notification.name == UIResponder.keyboardWillShowNotification {
            bottomContainer.constant = heightKeyboard - (AppDelegate.instance()?.window?.safeAreaInsets.bottom ?? 0)
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
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if focusTf == tfUserId {
            self.tfPassword.becomeFirstResponder()
        }
        else {
            self.view.endEditing(true)
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.focusTf = textField
        return true
    }
    
}
