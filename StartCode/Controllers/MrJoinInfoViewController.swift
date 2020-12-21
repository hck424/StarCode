//
//  MrJoinViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/14.
//

import UIKit
import FirebaseMessaging
enum JoinType {
    case normal, sns
}

class MrJoinInfoViewController: BaseViewController {
    @IBOutlet weak var svUserId: UIStackView!
    @IBOutlet weak var svPassword: UIStackView!
    @IBOutlet weak var svPasswordConfirm: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tfEmail: CTextField!
    @IBOutlet weak var btnCheckId: UIButton!
    @IBOutlet weak var lbHintId: UILabel!
    @IBOutlet weak var tfPassword: CTextField!
    @IBOutlet weak var lbHintPassword: UILabel!
    @IBOutlet weak var tfPasswordConfirm: CTextField!
    @IBOutlet weak var lbHintPasswordConfirm: UILabel!
    @IBOutlet weak var tfNickName: CTextField!
    @IBOutlet weak var btnCheckNickName: UIButton!
    @IBOutlet weak var lbHintNickName: UILabel!
    
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var btnMail: SelectedButton!
    @IBOutlet weak var btnFemail: SelectedButton!
    @IBOutlet weak var lbHintGender: UILabel!
    
    @IBOutlet weak var btnBirthDay: UIButton!
    @IBOutlet weak var tfBirthday: CTextField!
    @IBOutlet weak var lbHintBirthday: UILabel!
    @IBOutlet weak var tvEssay: CTextView!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var bottomContainer: NSLayoutConstraint!
    @IBOutlet weak var lbHintEssay: UILabel!
    @IBOutlet weak var seperatorEmail: UIView!
    @IBOutlet weak var seperatorNickName: UIView!
    @IBOutlet weak var seperatorBirthDay: UIView!
    
    @IBOutlet weak var svExpert: UIStackView!
    @IBOutlet weak var btnExpertSelect: UIButton!
    @IBOutlet weak var tfExpertSelect: CTextField!
    
    @IBOutlet weak var lbHitExpertSelect: UILabel!
    @IBOutlet weak var svArtist: UIStackView!
    @IBOutlet weak var svPhotoArtist: UIStackView!
    @IBOutlet weak var btnArtist: CButton!
    @IBOutlet weak var scrollViewArtist: UIScrollView!
    
    @IBOutlet weak var svCeleb: UIStackView!
    @IBOutlet weak var scrollViewCeleb: UIScrollView!
    @IBOutlet weak var btnCeleb: CButton!
    @IBOutlet weak var svPhotoCeleb: UIStackView!
    
    var type:JoinType = .normal
    let accessoryView = CToolbar.init(barItems: [.up, .down, .keyboardDown], itemColor: ColorAppDefault)
    
    var arrFocuce:[AnyObject]?
    var focuseObj: AnyObject?
    
    var user:UserInfo?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = user else {
            return
        }
        if user.join_type == "none" {
            self.type = .normal
        }
        else {
            self.type = .sns
        }
        
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
        self.hideRightNaviBarItem = true
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
        svExpert.isHidden = true
        scrollViewArtist.isHidden = true
        scrollViewCeleb.isHidden = true
        if appType == .expert {
            svExpert.isHidden = false
            svArtist.isHidden = true
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
            lbHintId.isHidden = true
            guard let user = user else {
                return
            }
            guard let email = tfEmail.text, email.isEmpty == false else {
                lbHintId.text = "이메일을 입력해주세요."
                lbHintId.isHidden = false
                return
            }
            if email.validateEmail() == false {
                lbHintId.text = "이메일을 형식이아닙니다."
                self.lbHintId.isHidden = false
                return
            }
            
            let param:[String:Any] = ["akey":akey, "user_id":email]
            ApiManager.shared.requestMemberIdCheck(param: param) { (response) in
                if let response = response, let code = response["code"] as? Int, let message = response["message"] as? String  {
                    if code == 200 {
                        self.btnCheckId.isSelected = true
                    }
                    else {
                        self.lbHintId.text = message
                        self.lbHintId.isHidden = false
                    }
                }
            } failure: { (error) in
                self.showErrorAlertView(error)
            }
        }
        else if sender == btnCheckNickName {
            lbHintNickName.isHidden = true
            guard let nickName = tfNickName.text, nickName.isEmpty == false else {
                lbHintNickName.text = "닉네임을 입력해주세요."
                lbHintNickName.isHidden = false
                return
            }
            let param:[String:Any] = ["akey":akey, "user_nickname":nickName]
            ApiManager.shared.requestMemberNickNameCheck(param: param) { (response) in
                if let response = response, let code = response["code"] as? Int, let message = response["message"] as? String  {
                    if code == 200 {
                        self.btnCheckNickName.isSelected = true
                    }
                    else {
                        self.lbHintNickName.text = message
                        self.lbHintNickName.isHidden = false
                    }
                }
            } failure: { (error) in
                self.showErrorAlertView(error)
            }
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
        else if sender == btnExpertSelect {
            let list = ["아티스트", "셀럽"]
            let vc = PopupViewController.init(type: .list, title: "전문가 선택", data: list) { (vcs, selItem, index) in
                vcs.dismiss(animated: false, completion: nil)
                guard let selItem = selItem as? String else {
                    return
                }
                if index == 0 {
                    self.svCeleb.isHidden = false
                }
                else {
                    self.svCeleb.isHidden = true
                }
                self.tfExpertSelect.text = selItem
            }
            self.present(vc, animated: true, completion: nil)
        }
        else if sender == btnOk {
            lbHintId.isHidden = true
            lbHintNickName.isHidden = true
            lbHintPassword.isHidden = true
            lbHintPasswordConfirm.isHidden = true
            lbHintBirthday.isHidden = true
            lbHintGender.isHidden = true
            lbHintEssay.isHidden = true
            
            self.view.endEditing(true)
            
            var isOk = true
            if type == .normal {
                if tfEmail.text?.isEmpty == true || (tfEmail.text?.validateEmail() == false) {
                    isOk = false
                    lbHintId.text = "이메일 입력해주세요."
                    lbHintId.isHidden = false
                }
                else if tfEmail.text!.validateEmail() == false {
                    isOk = false
                    lbHintId.text = "이메일 형식이 아닙니다."
                    lbHintId.isHidden = false
                }
                else if btnCheckId.isSelected == false {
                    lbHintId.text = "아이디 중복 체크를 해주세요."
                    lbHintId.isHidden = false
                    isOk = false
                }
                
                if let password = tfPassword.text, password.isEmpty == true {
                    lbHintPassword.isHidden = false
                    lbHintPassword.text = "비밀번호를 입력해주세요."
                    isOk = false
                }
                else if tfPassword.text!.validatePassword() == false {
                    lbHintPassword.isHidden = false
                    lbHintPassword.text = "비밀번호(숫자,영문,특수문자)8자이상 입력해주세요."
                    isOk = false
                }
                else if let pass = tfPassword.text, let pass2 = tfPasswordConfirm.text, pass != pass2 {
                    lbHintPasswordConfirm.isHidden = false
                    isOk = false
                }
                
                if tfNickName.text?.isEmpty == true {
                    lbHintNickName.isHidden = false
                    lbHintNickName.text = "닉네임을 입력해주세요."
                    isOk = false
                }
                else if btnCheckNickName.isSelected == false {
                    lbHintNickName.isHidden = false
                    lbHintNickName.text = "닉네임 중복확인을 해주세요."
                    isOk = false
                }
                
                if btnMail.isSelected == false && btnFemail.isSelected == false {
                    lbHintGender.isHidden = false
                    isOk = false
                }
                if let birthday = tfBirthday.text, birthday.isEmpty == true {
                    lbHintBirthday.isHidden = false
                    isOk = false
                }
                
                
                if isOk == false {
                    return
                }
                
                //회원가입 진행
                user?.mem_userid = tfEmail.text!
                user?.mem_password = tfPassword.text!
                user?.mem_nickname = tfNickName.text!
                user?.mem_birthday = tfBirthday.text!
                if let essay = tvEssay.text, essay.isEmpty == false {
                    user?.mem_profile_content = essay
                }
                if btnMail.isSelected {
                    user?.mem_sex = 1
                }
                else {
                    user?.mem_sex = 0
                }
                if let token = Messaging.messaging().fcmToken {
                    user?.push_token = token
                }
                user?.platform = "ios"
                user?.mem_device_id = Utility.getUUID()
                user?.akey = akey
                
                SharedData.setObjectForKey(user?.mem_password!, kMemPassword)
                
                guard let user = user, let param = user.toJSON() as?[String:Any] else {
                    print("object mapper convert to diction error")
                    return
                }
                
                ApiManager.shared.requestMemberSignUp(param: param) { (response) in
                    if let response = response, let code = response["code"] as? Int {
                        if code == 200 {
                            guard let user = response["user"] as? [String:Any] else {
                                return
                            }
                            SharedData.instance.saveUserInfo(user: user)
                            let vc = MrCompleteViewController.init()
                            self.navigationController?.pushViewController(vc, animated:true)
                        }
                        else {
                            if let message = response["message"] as? String {
                                self.showToast(message)
                            }
                        }
                    }
                } failure: { (error) in
                    self.showErrorAlertView(error)
                }
            }
            else {
                if tfNickName.text?.isEmpty == true {
                    lbHintNickName.isHidden = false
                    lbHintNickName.text = "닉네임을 입력해주세요."
                    isOk = false
                }
                else if btnCheckNickName.isSelected == false {
                    lbHintNickName.isHidden = false
                    lbHintNickName.text = "닉네임 중복확인을 해주세요."
                    isOk = false
                }
                
                if btnMail.isSelected == false && btnFemail.isSelected == false {
                    lbHintGender.isHidden = false
                    isOk = false
                }
                
                if let birthday = tfBirthday.text, birthday.isEmpty == true {
                    lbHintBirthday.isHidden = false
                    isOk = false
                }
                
                if let essay = tvEssay.text, essay.isEmpty == false {
                    user?.mem_profile_content = essay
                }
                if isOk == false {
                    return
                }
             
                
            }
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

extension MrJoinInfoViewController: UITextFieldDelegate {
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.focuseObj = textField
        if textField == tfEmail {
            seperatorEmail.backgroundColor = ColorAppDefault
        }
        else if textField == tfNickName {
            seperatorNickName.backgroundColor = ColorAppDefault
        }
        else if textField == tfBirthday {
            seperatorBirthDay.backgroundColor = ColorAppDefault
        }
        else if let textField = textField as? CTextField {
            textField.borderColor = ColorAppDefault
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tfEmail {
            seperatorEmail.backgroundColor = ColorBorderDefault
        }
        else if textField == tfNickName {
            seperatorNickName.backgroundColor = ColorBorderDefault
        }
        else if textField == tfBirthday {
            seperatorBirthDay.backgroundColor = ColorBorderDefault
        }
        else if let textField = textField as? CTextField {
            textField.borderColor = ColorBorderDefault
        }
    }
}

extension MrJoinInfoViewController: UITextViewDelegate {
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
