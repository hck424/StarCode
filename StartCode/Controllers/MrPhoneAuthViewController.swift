//
//  MrPhoneAuthViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/15.
//

import UIKit
import PhoneNumberKit

class MrPhoneAuthViewController: BaseViewController {
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var tfPhone: CTextField!
    @IBOutlet weak var btnAuth: UIButton!
    @IBOutlet weak var tfAuthNumber: CTextField!
    @IBOutlet weak var btnAuthComfirm: UIButton!
    @IBOutlet weak var lbHitPhone: UILabel!
    @IBOutlet weak var lbHitAuthNum: UILabel!
    @IBOutlet weak var seperatorPhone: UIView!
    @IBOutlet weak var seperatorAuth: UIView!
    
    let MIN_AUTH_TIMEOUT:TimeInterval = 3.0
    var timerAuth:Timer?
    var endTime:TimeInterval = 0.0

    let accessoryView = CToolbar.init(barItems: [.keyboardDown])
//    let phoneNumberKit = PhoneNumberKit()
    var user: UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "휴대폰 인증", #selector(actionPopViewCtrl))
        self.hideRightNaviBarItem = true
        tfPhone.inputAccessoryView = accessoryView
        tfAuthNumber.inputAccessoryView = accessoryView
        accessoryView.addTarget(self, selctor: #selector(actionKeybardDown))
        self.addTapGestureKeyBoardDown()
        self.btnAuth.setTitleColor(ColorAppDefault, for: .normal)
        self.btnAuth.setTitleColor(RGB(146, 146, 146), for: .disabled)
        self.addTapGestureKeyBoardDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardNotification()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopAuthTimer()
        self.removeKeyboardNotification()
    }
    func startAuthTimer() {
        let stTime = Date.timeIntervalSinceReferenceDate
        self.endTime = 60*MIN_AUTH_TIMEOUT + stTime
        
        let diff:Int = Int(self.endTime - stTime)
        let minute:Int = Int(diff/60)
        let second:Int = Int(diff%60)
        lbHitPhone.text = String(format: "%02d:%02d", minute, second)
        lbHitPhone.isHidden = false
        tfPhone.isUserInteractionEnabled = false
        btnAuth.isEnabled = false
        tfAuthNumber.becomeFirstResponder()
        self.stopAuthTimer()
        
        self.timerAuth = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            
            let diff:Int = Int(self.endTime - Date.timeIntervalSinceReferenceDate)
            if diff <= 0 {
                self.timeOut()
            }
            else {
                let minute:Int = Int(diff/60)
                let second:Int = Int(diff%60)
                self.lbHitPhone.text = String(format: "%02d:%02d", minute, second)
            }
        })
    }
    func stopAuthTimer() {
        timerAuth?.invalidate()
        timerAuth = nil
    }
    func timeOut() {
        btnAuth.isEnabled = true
        tfPhone.isUserInteractionEnabled = true
        self.stopAuthTimer()
        lbHitPhone.text = "인증시간이 초과되었습니다."
        lbHitPhone.isHidden = false
    }
    @IBAction func textFiledViewEdtingChanged(_ textField: UITextField) {
        if textField == tfPhone {
            btnAuth.isSelected = false
        }
    }
    
    @IBAction func onClickedBtnActions(_ sender:UIButton) {
        if sender == btnAuth {
            
            lbHitPhone.isHidden = true
            guard let phonenumber = tfPhone.text, phonenumber.isEmpty == false else {
                lbHitPhone.isHidden = false
                lbHitPhone.text = "휴대폰 번호를 입력해주세요."
                return
            }
            if phonenumber.validateKorPhoneNumber() == false {
                lbHitPhone.isHidden = false
                lbHitPhone.text = "휴대폰 번호형식이 아닙니다."
                return
            }
            self.user?.authkey = nil
            let param:[String:Any] = ["akey":akey, "phone":phonenumber]
            ApiManager.shared.requestPhoneAuthCode(param: param) { (response) in
                if let response = response, let key = response["key"] as? String {
                    self.user?.authkey = key
                    self.user?.mem_phone = phonenumber.getNumberString()
                    self.startAuthTimer()
                }
                else {
                    self.showErrorAlertView(response)
                }
            } failure: { (error) in
                self.showErrorAlertView(error)
            }
        }
        else if sender == btnAuthComfirm {
            self.view.endEditing(true)
            lbHitAuthNum.isHidden = true
            self.btnAuthComfirm.isSelected = false
            guard let authCode = tfAuthNumber.text, authCode.isEmpty == false else {
                lbHitAuthNum.isHidden = false
                lbHitAuthNum.text = "인증번호를 입력해주세요."
                return
            }
            
            guard let intAuthCode:Int = Int(authCode) else {
                return
            }
            
            guard let phone = user?.mem_phone, phone.isEmpty == false else {
                return
            }
            guard let user = user, let authkey = user.authkey else {
                return
            }
            
            let param:[String:Any] = ["akey":akey, "phone":phone, "authkey":authkey, "code":intAuthCode]
            ApiManager.shared.requestPhoneAuthCheck(param: param) { (response) in
                if let response = response, let map_id = response["map_id"] as? String {
                    self.user?.map_id = map_id
                    self.btnAuthComfirm.isSelected = true
                    self.view.endEditing(true)
                    self.stopAuthTimer()
                    self.lbHitPhone.isHidden = true
                    let vc = MrJoinInfoViewController.init()
                    vc.user = user
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    self.showErrorAlertView(response)
                }
            } failure: { (error) in
                self.showErrorAlertView(error)
            }
            
        }
        else if sender == btnOk {
            self.view.endEditing(true)
            lbHitPhone.isHidden = true
            guard let phonenumber = tfPhone.text, phonenumber.isEmpty == false else {
                lbHitPhone.isHidden = false
                lbHitPhone.text = "휴대폰 번호를 입력해주세요."
                return
            }
            if phonenumber.validateKorPhoneNumber() == false {
                lbHitPhone.isHidden = false
                lbHitPhone.text = "휴대폰 형식이 아닙니다."
                return
            }
            guard let authkey = self.user?.authkey, authkey.isEmpty == false, btnAuth.isEnabled == false else {
                lbHitPhone.isHidden = false
                lbHitPhone.text = "휴대폰 인증해주세요."
                return
            }
            
            lbHitAuthNum.isHidden = true
            guard let authCode = tfAuthNumber.text, authCode.isEmpty == false else {
                lbHitAuthNum.isHidden = false
                lbHitAuthNum.text = "인증번호를 입력해주세요."
                return
            }
            if btnAuthComfirm.isSelected == false {
                lbHitAuthNum.text = "휴대폰 인증번호 확인을 해주세요."
                lbHitAuthNum.isHidden = false
                return
            }
     
            let vc = MrJoinInfoViewController.init()
            vc.user = user
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MrPhoneAuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfPhone {
            tfAuthNumber.becomeFirstResponder()
        }
        else {
            self.view.endEditing(true)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tfPhone {
            seperatorPhone.backgroundColor = ColorAppDefault
        }
        else if textField == tfAuthNumber {
            seperatorAuth.backgroundColor = ColorAppDefault
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tfPhone {
            seperatorPhone.backgroundColor = ColorBorderDefault
        }
        else if textField == tfAuthNumber {
            seperatorAuth.backgroundColor = ColorBorderDefault
        }
    }
    
}
