//
//  MyInfoViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class MyInfoViewController: BaseViewController {

    @IBOutlet weak var tfPassword: CTextField!
    @IBOutlet weak var btnChangePW: UIButton!
    @IBOutlet weak var lbHitPw: UILabel!
    @IBOutlet weak var tfNickName: CTextField!
    @IBOutlet weak var btnChangeNickName: UIButton!
    @IBOutlet weak var lbHitNickName: UILabel!
    @IBOutlet weak var textView: CTextView!
    @IBOutlet weak var btnOk: CButton!
    @IBOutlet weak var btnCancel: CButton!
    @IBOutlet weak var lbHintEssay: UILabel!
    
    var userInfo:[String:Any] = [:]
    
    let accessoryView = CToolbar.init(barItems: [.keyboardDown])
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CNavigationBar.drawBackButton(self, "계정 관리", #selector(actionPopViewCtrl))
        
        tfPassword.inputAccessoryView = accessoryView
        tfNickName.inputAccessoryView = accessoryView
        textView.inputAccessoryView = accessoryView
        accessoryView.addTarget(self, selctor: #selector(actionKeybardDown))
        self.addTapGestureKeyBoardDown()
        
        self.requestMyInfo()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardNotification()
        textView.delegate = self
        textView.placeholderLabel?.isHidden = !textView.text.isEmpty
        self.showLoginPopupWithCheckSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotification()
    }
    
    func requestMyInfo() {
        guard let token = SharedData.instance.token else {
            return
        }
        let param = ["token":token]
        ApiManager.shared.requestMyInfo(param: param) { (response) in
            if let response = response, let code = response["code"] as? Int, code == 200, let user = response["user"] as? [String:Any] {
                self.userInfo = user
                self.decortionUi()
            }
            else {
                self.showErrorAlertView(response)
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
    
    func decortionUi() {
        if let mem_nickname = userInfo["mem_nickname"] as? String {
            tfNickName.text = mem_nickname
        }
        if let mem_profile_content = userInfo["mem_profile_content"] as? String {
            textView.text = mem_profile_content
            self.textViewDidChange(self.textView)
        }
    }
    
    @IBAction func onClickedBtnAction(_ sender: UIButton) {
        if sender == btnCancel {
            self.navigationController?.popViewController(animated: true)
        }
        else if sender == btnChangePW {
            let vc = MrInfoModifyViewController.init(type: .modifyPw)
            self.present(vc, animated: true, completion: nil)
        }
        else if sender == btnChangeNickName {
            lbHitNickName.isHidden = true
            guard let nickName = tfNickName.text, nickName.isEmpty == false else {
                lbHitNickName.text = "닉네임을 입력해주세요."
                lbHitNickName.isHidden = false
                return
            }
            
            let param:[String:Any] = ["akey":akey, "user_nickname":nickName]
            ApiManager.shared.requestMemberNickNameCheck(param: param) { (response) in
                if let response = response, let code = response["code"] as? Int, code == 200 {
                    self.btnChangeNickName.isSelected = true
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
            var isOk = true
            lbHitNickName.isHidden = true
            if let nickName = tfNickName.text, nickName.isEmpty == true {
                lbHitNickName.text = "닉네임을 입력해주세요."
                lbHitNickName.isHidden = false
                isOk = false
            }
            else if let mem_nickname = userInfo["mem_nickname"] as? String, mem_nickname != tfNickName.text!, btnChangeNickName.isSelected == false {
                lbHitNickName.text = "닉네임을 체크해주세요."
                lbHitNickName.isHidden = false
                isOk = false
            }
            
            lbHintEssay.isHidden = true
            if let essay = textView.text, essay.isEmpty == true {
                lbHintEssay.isHidden = false
                isOk = false
            }
            
            if isOk == false {
                return
            }
            guard let token = SharedData.instance.token else {
                return
            }
            let param:[String:Any] = ["token":token, "mem_nickname":tfNickName.text!, "mem_profile_content":textView.text!]
            ApiManager.shared.requestModifyMyInfo(param: param) { (response) in
                if let response = response, let code = response["code"] as? Int, let message = response["message"] as? String, code == 200 {
                    let vc = PopupViewController.init(type: .alert, title: "회원정보 변경", message:message) { (vcs, selItem, index) in
                        vcs.dismiss(animated: true, completion: nil)
                        self.navigationController?.popViewController(animated: true)
                    }
                    vc.addAction(.ok, "확인")
                    self.present(vc, animated: true, completion: nil)
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

extension MyInfoViewController: UITextFieldDelegate {
    
}

extension MyInfoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let textView = textView as? CTextView {
            textView.placeholderLabel?.isHidden = !textView.text.isEmpty
        }
    }
    
    
}
