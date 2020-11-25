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
    
    let accessoryView = CToolbar.init(barItems: [.keyboardDown])
    let phoneNumberKit = PhoneNumberKit()
    var user: UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "휴대폰 인증", #selector(actionPopViewCtrl))
        tfPhone.inputAccessoryView = accessoryView
        tfAuthNumber.inputAccessoryView = accessoryView
        accessoryView.addTarget(self, selctor: #selector(actionKeybardDown))
        self.addTapGestureKeyBoardDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func textFiledViewEdtingChanged(_ sender: UITextField) {
        guard let text = sender.text, text.isEmpty == false else {
            return
        }
        do {
            let phoneNumber = try phoneNumberKit.parse(text, ignoreType: true)
            let newNum = self.phoneNumberKit.format(phoneNumber, toType: .national)
            self.tfPhone.text = newNum
        } catch {
            self.tfPhone.text = text
        }
    }
    
    @IBAction func onClickedBtnActions(_ sender:UIButton) {
        if sender == btnAuth {
            lbHitPhone.isHidden = true
            guard let phonenumber = tfPhone.text, phonenumber.isEmpty == false else {
                lbHitPhone.isHidden = false
                return
            }
            let numericNum = phonenumber.getNumberString()!
            self.requestPhoneAuth(phone: numericNum)
            
        }
        else if sender == btnAuthComfirm {
            lbHitAuthNum.isHidden = true
            guard let authCode = tfAuthNumber.text, authCode.isEmpty == false, let intAuth:Int = Int(authCode) else {
                lbHitAuthNum.isHidden = false
                return
            }
            self.requestPhoneAuthCheck(code: intAuth)
        }
        else if sender == btnOk {
            guard let authKey = user?.authkey else {
                self.view.makeToast("휴대폰 인증을해주세요.")
                return
            }
            guard let map_id = user?.map_id else {
                self.view.makeToast("휴대폰 인증이 완료되지 않았습니다.")
                return
            }
        }
    }
    
    func requestPhoneAuth(phone:String) {
        let param:[String:Any] = ["akey":akey, "phone":phone]
        ApiManager.shared.requestPhoneAuthCode(param: param) { (response) in
            if let response = response, let key = response["key"] as? String {
                self.user?.authkey = key
                self.user?.mem_phone = phone
            }
            else {
                self.showErrorAlertView(response)
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
    func requestPhoneAuthCheck(code:Int) {
        guard let phone = user?.mem_phone, phone.isEmpty == false else {
            return
        }
        guard let user = user, let authkey = user.authkey else {
            return
        }
        
        let param:[String:Any] = ["akey":akey, "phone":phone, "authkey":authkey, "code":code]
        ApiManager.shared.requestPhoneAuthCheck(param: param) { (response) in
            if let response = response, let map_id = response["map_id"] as? String {
                self.user?.map_id = map_id
                let vc = MrJoinViewController.init()
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
}
