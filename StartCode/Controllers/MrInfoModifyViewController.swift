//
//  MrInfoModifyViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit
enum MrModifyType {
    case findId, findPw, modifyPw
}

class MrInfoModifyViewController: BaseViewController {

    @IBOutlet weak var heightContentView: NSLayoutConstraint!
    @IBOutlet weak var btnFullClose: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var svContentView: UIStackView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var svTitle: UIStackView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var svActions: UIStackView!
    @IBOutlet weak var bottomContainer: NSLayoutConstraint!
    @IBOutlet weak var btnCancel: CButton!
    @IBOutlet weak var btnOk: CButton!
    
    @IBOutlet weak var svPhoneNum: UIStackView!
    @IBOutlet weak var tfPhoneNum: CTextField!
    @IBOutlet weak var btnPhoneAuth: UIButton!
    @IBOutlet weak var lbHintPhone: UILabel!
    
    @IBOutlet weak var svAuth: UIStackView!
    @IBOutlet weak var tfAuth: CTextField!
    @IBOutlet weak var lbHintAuth: UILabel!
    
    @IBOutlet weak var svEmail: UIStackView!
    @IBOutlet weak var tfEmail: CTextField!
    @IBOutlet weak var lbHintEmail: UILabel!
    
    @IBOutlet weak var svCurPw: UIStackView!
    @IBOutlet weak var tfCurPw: CTextField!
    @IBOutlet weak var btnCurPw: UIButton!
    @IBOutlet weak var lbHintCurPw: UILabel!
    
    @IBOutlet weak var svNewPw: UIStackView!
    @IBOutlet weak var tfNewPw: CTextField!
    @IBOutlet weak var btnNewPw: UIButton!
    @IBOutlet weak var lbHintNewPw: UILabel!
    
    @IBOutlet weak var svConfirmPw: UIStackView!
    @IBOutlet weak var tfConfirmPw: CTextField!
    @IBOutlet weak var btnConfirmPw: UIButton!
    @IBOutlet weak var lbHintConfirmPw: UILabel!
    
    var type: MrModifyType = .findId
    
    let accessoryView = CToolbar.init(barItems: [.keyboardDown])
    var authKey = ""
    
    convenience init(type:MrModifyType) {
        self.init()
        self.type = type
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = CACornerMask(TL: true, TR: true, BL: false, BR: false)
       
        svPhoneNum.isHidden = true
        svAuth.isHidden = true
        svEmail.isHidden = true
        svCurPw.isHidden = true
        svNewPw.isHidden = true
        svConfirmPw.isHidden = true
        
        if type == .findId {
            svPhoneNum.isHidden = false
            svAuth.isHidden = false
            lbTitle.text = "아이디 찾기"
        }
        else if type == .findPw {
            svPhoneNum.isHidden = false
            svAuth.isHidden = false
            svEmail.isHidden = false
            lbTitle.text = "비밀번호 찾기"
        }
        else if type == .modifyPw {
            svCurPw.isHidden = false
            svNewPw.isHidden = false
            svConfirmPw.isHidden = false
            lbTitle.text = "비밀번호 변경"
        }
        
        accessoryView.addTarget(self, selctor: #selector(actionKeybardDown))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotification()
        self.view.endEditing(true)
    }
    
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        
        if sender == btnClose || sender == btnCancel {
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        }
        else if sender == btnFullClose {
            self.view.endEditing(true)
        }
        else if sender == btnPhoneAuth {
            lbHintPhone.isHidden = true
            guard let phone = tfPhoneNum.text, phone.isEmpty == false else {
                lbHintPhone.isHidden = false
                return
            }
            
            var param:[String:Any] = ["akey":akey, "phone":phone]
            if type == .findId {
                param["map_type"] = 2
            }
            else if type == .findPw {
                param["map_type"] = 3
            }
            
            ApiManager.shared.requestPhoneReAuthCode(param: param) { (response) in
                if let response = response, let code = response["code"] as? Int, code == 200 {
                    if let key = response["key"] as? String {
                        self.authKey = key
                        self.btnPhoneAuth.isSelected = true
                    }
                }
                else {
                    self.showErrorAlertView(response)
                }
            } failure: { (error) in
                self.showErrorAlertView(error)
            }
        }
        else if sender == btnCurPw {
            tfCurPw.isSecureTextEntry = sender.isSelected
            sender.isSelected = !sender.isSelected
        }
        else if sender == btnNewPw {
            tfNewPw.isSecureTextEntry = sender.isSelected
            sender.isSelected = !sender.isSelected
        }
        else if sender == btnConfirmPw {
            tfConfirmPw.isSecureTextEntry = sender.isSelected
            sender.isSelected = !sender.isSelected
        }
        else if sender == btnOk {
            if self.checkValidata() == false {
                return
            }
            
            guard let authKey = authKey as? String else {
                return
            }
            self.view.endEditing(true)
            if type == .findId || type == .findPw {
                var param:[String:Any] = ["akey":akey, "phone":tfPhoneNum.text!, "authkey":authKey, "code":tfAuth.text!]
                if type == .findId {
                    param["type"] = "id"
                }
                else {
                    param["type"] = "pass"
                    param["email"] = tfEmail.text!
                }
                
                ApiManager.shared.requestFindIdOrPassword(param: param) { (respnse) in
                    if let respnse = respnse, let code = respnse["code"] as? Int, code == 200 {
                        self.dismiss(animated: true, completion: nil)
                    }
                    else {
                        self.showErrorAlertView(respnse)
                    }
                } failure: { (error) in
                    self.showErrorAlertView(error)
                }
            }
            else if type == .modifyPw {
                guard let curPw = tfCurPw.text else {
                    return
                }
                guard let newPw = tfNewPw.text else {
                    return
                }
                guard let token = SharedData.instance.pToken else {
                    return
                }
                let param:[String:Any] = ["token":token, "c_password": curPw, "n_password":newPw]
                ApiManager.shared.requestModifyPassword(param: param) { (response) in
                    if let response = response, let code = response["code"] as? Int, code == 200, let message = response["message"] as? String{
                        self.view.makeToast(message, duration:2.0, position:.top)
                        self.dismiss(animated: true, completion: nil)
                        SharedData.setObjectForKey(newPw, kMemPassword)
                        AppDelegate.instance()?.callLoginVc()
                    }
                    else {
                        self.showErrorAlertView(response)
                    }
                } failure: { (error) in
                    self.showErrorAlertView(error)
                }
            }
        }
    }
    
    func checkValidata() ->Bool {
        
        var isOk = true
        if type == .findId || type == .findPw {
            lbHintPhone.isHidden = true
            if let phone = tfPhoneNum.text, phone.isEmpty == true {
                lbHintPhone.isHidden = false
                lbHintPhone.text = "휴대폰 번호를 입력하세요."
                isOk = false
            }
            else if btnPhoneAuth.isSelected == false {
                lbHintPhone.isHidden = false
                lbHintPhone.text = "인증요청을 해주세요."
                isOk = false
            }
            
            lbHintAuth.isHidden = false
            if let auth = tfAuth.text, auth.isEmpty == true {
                lbHintAuth.isHidden = false
                isOk = false
            }
            
            if type == .findPw {
                lbHintEmail.isHidden = true
                if let email = tfEmail.text, email.isEmpty == true {
                    lbHintEmail.isHidden = false
                    lbHintEmail.text = "이메일을 입력하세요."
                    isOk = false
                }
                else if let email = tfEmail.text, email.validateEmail() == false {
                    lbHintEmail.isHidden = false
                    lbHintEmail.text = "이메일 형식이 아닙니다."
                    isOk = false
                }
            }
        }
        else if type == .modifyPw {
            lbHintCurPw.isHidden = true
            lbHintNewPw.isHidden = true
            lbHintConfirmPw.isHidden = true
            
            if let curPw = tfCurPw.text, curPw.isEmpty {
                lbHintCurPw.isHidden = false
                isOk = false
            }
            
            if let newPw = tfNewPw.text, newPw.isEmpty == true {
                lbHintNewPw.isHidden = false
                isOk = false
            }
            else if let confirmPw = tfConfirmPw.text, confirmPw != tfNewPw.text! {
                lbHintConfirmPw.isHidden = false
                isOk = false
            }
        }
        
        return isOk
    }
    
    ///mark notificationHandler
    @objc override func notificationHandler(_ notification: NSNotification) {
        
        if notification.name == UIResponder.keyboardWillShowNotification
            || notification.name == UIResponder.keyboardWillHideNotification {
            
            let heightKeyboard = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size.height
            let duration = CGFloat((notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue ?? 0.0)
     
            if notification.name == UIResponder.keyboardWillShowNotification {
                bottomContainer.constant = heightKeyboard
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
}

extension MrInfoModifyViewController: UISearchTextFieldDelegate {
    
}
