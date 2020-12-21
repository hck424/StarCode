//
//  MrInfoModifyViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit
import PhoneNumberKit

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
    @IBOutlet weak var seperatorPhoneNumber: UIView!
    
    @IBOutlet weak var svAuth: UIStackView!
    @IBOutlet weak var tfAuth: CTextField!
    @IBOutlet weak var lbHintAuth: UILabel!
    
    @IBOutlet weak var svEmail: UIStackView!
    @IBOutlet weak var tfEmail: CTextField!
    @IBOutlet weak var lbHintEmail: UILabel!
    
    @IBOutlet weak var svCurPw: UIStackView!
    @IBOutlet weak var tfCurPw: CTextField!
    @IBOutlet weak var lbHintCurPw: UILabel!
    
    @IBOutlet weak var svNewPw: UIStackView!
    @IBOutlet weak var tfNewPw: CTextField!
    @IBOutlet weak var lbHintNewPw: UILabel!
    
    @IBOutlet weak var svNewPwConfirm: UIStackView!
    @IBOutlet weak var tfNewPwConfirm: CTextField!
    @IBOutlet weak var lbHintConfirmPw: UILabel!
    
//    let phoneNumberKit = PhoneNumberKit()
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
        svNewPwConfirm.isHidden = true
        
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
            svNewPwConfirm.isHidden = false
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
    
    @IBAction func textFieldEdtingChanged(_ sender: UITextField) {
        if sender == tfPhoneNum {
            guard let text = sender.text, text.isEmpty == false else {
                return
            }
//            do {
//                let phoneNumber = try phoneNumberKit.parse(text, ignoreType: true)
//                let newNum = self.phoneNumberKit.format(phoneNumber, toType: .national)
//                self.tfPhoneNum.text = newNum
//            } catch {
//                self.tfPhoneNum.text = text
//            }
            btnPhoneAuth.isSelected = false
        }
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
                lbHintPhone.text = "휴대폰 번호를 입력하세요."
                return
            }
            if phone.validateKorPhoneNumber() == false {
                lbHintPhone.isHidden = false
                lbHintPhone.text = "휴대폰 번호형식이 아닙니다."
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
        else if sender == btnOk {
            
            if self.checkValidata() == false {
                return
            }
            
            self.view.endEditing(true)
            if type == .findId || type == .findPw {
                guard let intAuthCode = Int(tfAuth.text!) else {
                    return
                }
                guard let phone = tfPhoneNum.text!.getNumberString() else {
                    return
                }
                var param:[String:Any] = ["akey":akey, "phone":phone, "authkey":authKey, "code":intAuthCode]
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
                self.view.endEditing(true)
                guard let curPw = tfCurPw.text else {
                    return
                }
                guard let newPw = tfNewPw.text else {
                    return
                }
                guard let token = SharedData.instance.token else {
                    return
                }
                let param:[String:Any] = ["token":token, "c_password": curPw, "n_password":newPw]
                ApiManager.shared.requestModifyPassword(param: param) { (response) in
                    if let response = response, let code = response["code"] as? Int, code == 200, let message = response["message"] as? String{
                        self.showToast(message)
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
        lbHintPhone.isHidden = true
        lbHintAuth.isHidden = true
        lbHintEmail.isHidden = true
        lbHintCurPw.isHidden = true
        lbHintNewPw.isHidden = true
        lbHintConfirmPw.isHidden = true
        
        var isOk = true
        if type == .findId || type == .findPw {
            if let phone = tfPhoneNum.text, phone.isEmpty == true {
                lbHintPhone.isHidden = false
                lbHintPhone.text = "휴대폰 번호를 입력하세요."
                isOk = false
            }
            else if tfPhoneNum.text!.validateKorPhoneNumber() == false {
                lbHintPhone.isHidden = false
                lbHintPhone.text = "휴대폰 번호형식이 아닙니다."
                isOk = false
            }
            else if btnPhoneAuth.isSelected == false {
                lbHintPhone.isHidden = false
                lbHintPhone.text = "휴대폰 인증번호를 요청해주세요."
                isOk = false
            }
            
            if let auth = tfAuth.text, auth.isEmpty == true {
                lbHintAuth.isHidden = false
                isOk = false
            }
            
            if type == .findPw {
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
            
            if let curPw = tfCurPw.text, curPw.isEmpty {
                lbHintCurPw.isHidden = false
                isOk = false
            }
            
            if let newPw = tfNewPw.text, newPw.isEmpty == true {
                lbHintNewPw.text = "새로운 비밀번호를 입력하세요."
                lbHintNewPw.isHidden = false
                isOk = false
            }
            else if tfNewPw.text!.validatePassword() == false {
                lbHintNewPw.text = "비밀번호 형식이 아닙니다."
                lbHintNewPw.isHidden = false
                isOk = false
            }
            else if let confirmPw = tfNewPwConfirm.text, confirmPw != tfNewPw.text! {
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

extension MrInfoModifyViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if type == .findId {
            if textField == tfPhoneNum {
                tfAuth.becomeFirstResponder()
            }
            else {
                self.view.endEditing(true)
            }
        }
        else if type == .findPw {
            if textField == tfPhoneNum {
                tfAuth.becomeFirstResponder()
            }
            else if textField == tfAuth {
                tfEmail.becomeFirstResponder()
            }
            else {
                self.view.endEditing(true)
            }
        }
        else if type == .modifyPw {
            if textField == tfCurPw {
                tfNewPw.becomeFirstResponder()
            }
            else if textField == tfNewPw {
                tfNewPwConfirm.becomeFirstResponder()
            }
            else {
                self.view.endEditing(true)
            }
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tfPhoneNum {
            seperatorPhoneNumber.backgroundColor = ColorAppDefault
        }
        else if let textField = textField as? CTextField {
            textField.borderColor = ColorAppDefault
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tfPhoneNum {
            seperatorPhoneNumber.backgroundColor = ColorBorderDefault
        }
        else if let textField = textField as? CTextField {
            textField.borderColor = ColorBorderDefault
        }
    }
}
