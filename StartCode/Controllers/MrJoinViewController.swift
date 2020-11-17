//
//  MrJoinViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/14.
//

import UIKit
enum JoinType {
    case normal, sns
}

class MrJoinViewController: BaseViewController {
    @IBOutlet weak var svUserId: UIStackView!
    @IBOutlet weak var svPassword: UIStackView!
    @IBOutlet weak var svPasswordConfirm: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tfEmail: CTextField!
    @IBOutlet weak var btnCheckId: UIButton!
    @IBOutlet weak var lbHintId: UILabel!
    @IBOutlet weak var tfPassword: CTextField!
    @IBOutlet weak var btnEyePassword: UIButton!
    @IBOutlet weak var lbHintPassword: UILabel!
    @IBOutlet weak var tfPasswordConfirm: CTextField!
    @IBOutlet weak var btnEyePasswordConfirm: UIButton!
    @IBOutlet weak var lbHintPasswordConfirm: UILabel!
    @IBOutlet weak var tfNickName: CTextField!
    @IBOutlet weak var btnCheckNickName: UIButton!
    @IBOutlet weak var lbHintNickName: UILabel!
    
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var btnMail: SelectedButton!
    @IBOutlet weak var btnFemail: SelectedButton!
    
    @IBOutlet weak var btnBirthDay: UIButton!
    @IBOutlet weak var tfBirthday: CTextField!
    @IBOutlet weak var lbHintBirthday: UILabel!
    @IBOutlet weak var tvEssay: CTextView!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var bottomContainer: NSLayoutConstraint!
    
    var type:JoinType = .normal
    let accessoryView = CToolbar.init(barItems: [.up, .down, .keyboardDown], itemColor: ColorAppDefault)
    
    var arrFocuce:[AnyObject]?
    var focuseObj: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tmp = "(일반)"
        var result = "회원가입 \(tmp)"
        if type == .sns {
            tmp = "(SNS)"
            result = "회원가입 \(tmp)"
        }
        
        let attr = NSMutableAttributedString.init(string: result, attributes: [NSAttributedString.Key.foregroundColor: UIColor.label])
        attr.addAttribute(.foregroundColor, value: RGB(155, 155, 155), range: (result as NSString).range(of: tmp))
        attr.addAttribute(.font, value: UIFont.systemFont(ofSize: 18, weight: .medium), range: NSMakeRange(0, result.length))
        CNavigationBar.drawBackButton(self, attr, #selector(onClickedBtnActions(_:)))
        
        if type == .normal {
            self.arrFocuce = [tfEmail, tfPassword, tfPasswordConfirm, tfNickName, tvEssay]
        }
        else {
            svUserId.isHidden = true
            svPassword.isHidden = true
            svPasswordConfirm.isHidden = true
            self.arrFocuce = [tfNickName, tvEssay]
        }
        
        self.addTapGestureKeyBoardDown()
        accessoryView.addTarget(self, selctor: #selector(onClickedBtnActions(_:)))
        for view in self.arrFocuce! {
            if let view = view as? UITextField {
                view.inputAccessoryView = accessoryView
            }
            else if let view = view as? CTextField {
                view.inputAccessoryView = accessoryView
            }
            else if let view = view as? CTextView {
                view.inputAccessoryView = accessoryView
            }
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.addKeyboardNotification()
        self.tvEssay.placeholderLabel?.isHidden = !tvEssay.text.isEmpty
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotification()
    }
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender.tag == TAG_NAVI_BACK {
            self.navigationController?.popViewController(animated: true)
        }
        else if sender.tag == TAG_TOOL_KEYBOARD_DOWN {
            self.view.endEditing(true)
        }
        else if sender.tag == TAG_TOOL_BAR_UP {
            if let arrFocuce = arrFocuce, let focusObj = self.focuseObj {
                let index:Int = arrFocuce.firstIndex { (obj) -> Bool in
                    obj as! NSObject == focusObj as! NSObject
                } ?? 0
                
                if index-1 >= 0 {
                    let newFocusObj = arrFocuce[index-1]
                    if newFocusObj.becomeFirstResponder() {}
                    
                }
            }
        }
        else if sender.tag == TAG_TOOL_BAR_DOWN {
            if let arrFocuce = arrFocuce, let focusObj = self.focuseObj {
                let index:Int = arrFocuce.firstIndex { (obj) -> Bool in
                    obj as! NSObject == focusObj as! NSObject
                } ?? 0
                
                if index+1 < arrFocuce.count {
                    let newFocusObj = arrFocuce[index+1]
                    if newFocusObj.becomeFirstResponder() {}
                }
            }
        }
        else if sender == btnMail {
            btnMail.isSelected = true
            btnFemail.isSelected = false
            genderView.bringSubviewToFront(btnMail)
        }
        else if sender == btnFemail {
            btnMail.isSelected = false
            btnFemail.isSelected = true
            genderView.bringSubviewToFront(btnFemail)
        }
        else if sender == btnCheckId {
            sender.isSelected = true
        }
        else if sender == btnEyePassword {
            sender.isSelected = !sender.isSelected
            tfPassword.isSecureTextEntry = !sender.isSelected
        }
        else if sender == btnEyePasswordConfirm {
            sender.isSelected = !sender.isSelected
            tfPasswordConfirm.isSecureTextEntry = !sender.isSelected
        }
        else if sender == btnCheckNickName {
            sender.isSelected = true
        }
        else if sender == btnBirthDay {
            self.view.endEditing(true)
            let todaysDate = Date()
            let minDate = todaysDate.getStartDate(withYear: -70)
            let maxDate = todaysDate
            let apoint = todaysDate.getStartDate(withYear: -30)
            
            let picker = CDatePickerView.init(type: .yearMonthDay, minDate: minDate, maxDate: maxDate, apointDate: apoint) { (strDate, date) in
                if let strDate = strDate {
                    self.tfBirthday.text = strDate
                }
            }
            picker?.local = Locale(identifier: "ko_KR")
            picker?.show()
        }
        else if sender == btnOk {
            lbHintId.isHidden = true
            lbHintNickName.isHidden = true
            lbHintPassword.isHidden = true
            lbHintPasswordConfirm.isHidden = true
            lbHintBirthday.isHidden = true
            
            
            var isOk = true
            if type == .normal {
                if tfEmail.text?.isEmpty == true || (tfEmail.text?.validateEmail() == false) {
                    isOk = false
                    lbHintId.text = "이메일 형식이 아닙니다."
                    lbHintId.isHidden = false
                }
                if btnCheckId.isSelected {
                    lbHintId.text = "아이디 중복 체크를 해주세요."
                    lbHintId.isHidden = false
                    isOk = false
                }
                
                if (tfPassword.text?.count == 0) || (tfPassword.text?.validatePassword() == false) {
                    lbHintPassword.isHidden = false
                    isOk = false
                }
                
                if tfPassword.text != tfPasswordConfirm.text {
                    lbHintPasswordConfirm.isHidden = false
                    isOk = false
                }
                
                if tfNickName.text?.isEmpty == true {
                    lbHintNickName.isHidden = false
                    lbHintNickName.text = "닉네임을 입력해주세요."
                    isOk = false
                }
                if btnCheckNickName.isSelected == false {
                    lbHintNickName.isHidden = false
                    lbHintNickName.text = "닉네임 중복 확인을 해주세요."
                    isOk = false
                }

                if tfBirthday.text?.isEmpty == true {
                    lbHintBirthday.isHidden = false
                    isOk = false
                }
                
                if btnMail.isSelected == false && btnFemail.isSelected == false {
                    self.view.makeToast("성별을 선택해주세요.")
                    isOk = false
                }
                
                if isOk == false {
                    return
                }
                
                //회원가입 진행
                
            }
            else {
                
                if tfNickName.text?.isEmpty == true {
                    lbHintNickName.isHidden = false
                    lbHintNickName.text = "닉네임을 입력해주세요."
                    isOk = false
                }

                if btnCheckNickName.isSelected == false {
                    lbHintNickName.isHidden = false
                    lbHintNickName.text = "닉네임 체크를 해주세요."
                    isOk = false
                }

                if btnMail.isSelected == false && btnFemail.isSelected == false {
                    self.view.makeToast("성별을 선택해주세요.")
                    isOk = false
                }
                
                if tfBirthday.text?.isEmpty == true {
                    lbHintBirthday.isHidden = false
                    isOk = false
                }
                
                if isOk == false {
                    return
                }
            }
            
            let vc = MrCompleteViewController.init()
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

extension MrJoinViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.focuseObj = textField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let arrFocuce = arrFocuce {
            let index:Int = arrFocuce.firstIndex { (obj) -> Bool in
                obj as! NSObject == textField
            } ?? (arrFocuce.count-1)
            
            if index+1 < arrFocuce.count {
                let newFocusObj = arrFocuce[index+1]
                if newFocusObj.becomeFirstResponder() {}
            }
        }
        return true
    }
}

extension MrJoinViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.focuseObj = textView
        self.scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.height), animated: true)
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        if let textView = textView as? CTextView {
            textView.placeholderLabel?.isHidden = !textView.text.isEmpty
        }
    }
}
