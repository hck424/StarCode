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
    @IBOutlet weak var svField1: UIStackView!
    @IBOutlet weak var svField2: UIStackView!
    @IBOutlet weak var svField3: UIStackView!
    
    
    var type: MrModifyType = .findId
    
    let accessoryView = CToolbar.init(barItems: [.keyboardDown])
    
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
        
        
        if type == .findId || type == .findPw {
            svField1.isHidden = false
            svField2.isHidden = false
            svField3.isHidden = true
            lbTitle.text = "아이디 찾기"
            if let lbFieldTitle = svField1.viewWithTag(100) as? UILabel {
                lbFieldTitle.text = "휴대폰 번호"
            }
            if let tfField = svField1.viewWithTag(101) as? CTextField {
                tfField.placeholder = "휴대폰번호를 입력해주세요."
                tfField.keyboardType = .phonePad
                tfField.delegate = self
                tfField.inputAccessoryView = accessoryView
            }
            if let lbHit = svField1.viewWithTag(102) as? UILabel {
                lbHit.text = "휴대폰번호 형식이 아닙니다."
            }
            if let btnAuth = svField1.viewWithTag(103) as? UIButton {
                btnAuth.setTitle("인증번호", for: .normal)
                btnAuth.setImage(nil, for: .normal)
            }
            
            //sv2
            if let lbFieldTitle = svField2.viewWithTag(100) as? UILabel {
                lbFieldTitle.text = "인증번호"
            }
            if let lbHit = svField2.viewWithTag(102) as? UILabel {
                lbHit.text = "00:00"
                lbHit.textColor = UIColor.label
            }
            if let tfField = svField2.viewWithTag(101) as? CTextField {
                tfField.placeholder = "인증번호를 입력해주세요."
                tfField.keyboardType = .numberPad
                tfField.delegate = self
                tfField.inputAccessoryView = accessoryView
            }
            if let btnAuth = svField2.viewWithTag(203) as? UIButton {
                btnAuth.isHidden = true
            }
            
            if type == .findPw {
                lbTitle.text = "비밀번호 찾기"
                svField3.isHidden = false
                if let lbFieldTitle = svField3.viewWithTag(100) as? UILabel {
                    lbFieldTitle.text = "이메일"
                }
                if let lbHit = svField2.viewWithTag(102) as? UILabel {
                    lbHit.text = "이메일 형식이 아닙니다."
                }
                if let tfField = svField3.viewWithTag(101) as? CTextField {
                    tfField.placeholder = "이메일을 입력해주세요"
                    tfField.delegate = self
                    tfField.keyboardType = .emailAddress
                    tfField.inputAccessoryView = accessoryView
                }
                if let btnAuth = svField3.viewWithTag(303) as? UIButton {
                    btnAuth.isHidden = true
                }
            }
        }
        else if (type == .modifyPw) {
            svField1.isHidden = false
            svField2.isHidden = false
            svField3.isHidden = false
            lbTitle.text = "비밀번호 변경"
            let imgBlindEye = UIImage(systemName: "eye.slash.fill")
            let imgEye = UIImage(systemName: "eye.fill")
            
            if let lbFieldTitle = svField1.viewWithTag(100) as? UILabel {
                lbFieldTitle.text = "현재 비밀번호"
            }
            if let tfField = svField1.viewWithTag(101) as? CTextField {
                tfField.placeholder = "현재 암호를 입력해주세요."
                tfField.keyboardType = .default
                tfField.isSecureTextEntry = true
                tfField.delegate = self
                tfField.inputAccessoryView = accessoryView
            }
            if let lbHit = svField1.viewWithTag(102) as? UILabel {
                lbHit.text = "암호가 틀렸습니다."
            }
            if let btnAuth = svField1.viewWithTag(103) as? UIButton {
                btnAuth.setImage(imgBlindEye, for: .normal)
                btnAuth.setImage(imgEye, for: .selected)
                btnAuth.setTitle(nil, for: .normal)
                btnAuth.setTitle(nil, for: .selected)
            }
            
            if let lbFieldTitle = svField2.viewWithTag(100) as? UILabel {
                lbFieldTitle.text = "새로운 비밀번호"
            }
            if let tfField = svField2.viewWithTag(101) as? CTextField {
                tfField.placeholder = "새로운 암호를 입력하세요"
                tfField.keyboardType = .default
                tfField.isSecureTextEntry = true
                tfField.delegate = self
                tfField.inputAccessoryView = accessoryView
            }
            if let lbHit = svField2.viewWithTag(102) as? UILabel {
                lbHit.text = "비밀번호 형식이 아닙니다.(숫자, 영문, 특수문자 조합 6자리이상)"
            }
            
            
            if let lbFieldTitle = svField3.viewWithTag(100) as? UILabel {
                lbFieldTitle.text = "새로운 비밀번호 확인"
            }
            if let tfField = svField3.viewWithTag(101) as? CTextField {
                tfField.placeholder = "새로운 암호를 다시한번 입력하세요."
                tfField.keyboardType = .default
                tfField.isSecureTextEntry = true
                tfField.delegate = self
                tfField.inputAccessoryView = accessoryView
            }
            if let lbHit = svField3.viewWithTag(102) as? UILabel {
                lbHit.text = "비밀번호가 일치하지 않습니다."
            }
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
        self.view.endEditing(true)
        if sender == btnClose {
            self.dismiss(animated: true, completion: nil)
        }
        else if sender == btnFullClose {
            self.view.endEditing(true)
        }
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
