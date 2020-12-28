//
//  MrJoinViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/14.
//

import UIKit
import Photos
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
    @IBOutlet weak var scrollViewArtist: UIScrollView!
    @IBOutlet weak var svPhotoArtist: UIStackView!
    @IBOutlet weak var btnArtist: CButton!
    
    @IBOutlet weak var svProfile: UIStackView!
    @IBOutlet weak var scrollViewProfile: UIScrollView!
    @IBOutlet weak var svPhotoProfile: UIStackView!
    @IBOutlet weak var btnProfile: CButton!
    
    
    var type:JoinType = .normal
    let accessoryView = CToolbar.init(barItems: [.up, .down, .keyboardDown], itemColor: ColorAppDefault)
    
    var arrFocuce:[AnyObject]?
    var focuseObj: AnyObject?
    
    var user:UserInfo?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user?.join_type == "none" {
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
//        self.removeRightChuNaviBarItem()
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
        scrollViewProfile.isHidden = true
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
                    self.svArtist.isHidden = false
                    self.svProfile.isHidden = false
                    self.btnArtist.setNeedsDisplay()
                }
                else {
                    self.svArtist.isHidden = true
                    self.svProfile.isHidden = false
                }
                self.tfExpertSelect.text = selItem
            }
            self.present(vc, animated: true, completion: nil)
        }
        else if sender == btnProfile || sender == btnArtist {
            btnProfile.isSelected = false
            btnArtist.isSelected = false
            sender.isSelected = true
            
            let list = ["갤러리에서 사진 가져오기", "카메라로 사진 촬영하기"]
            let vc = PopupViewController.init(type: .list, data: list, completion: { (vcs, selItem, index) in
                vcs.dismiss(animated: false, completion: nil)
                if index == 0 {
                    self.showCamera(.photoLibrary)
                }
                else if index == 1 {
                    self.showCamera(.camera)
                }
            })
            self.present(vc, animated: false, completion: nil)
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
                
                guard let user = user, var param = user.toJSON() as?[String:Any] else {
                    print("object mapper convert to diction error")
                    return
                }
                
                if appType == .expert {
                    lbHitExpertSelect.isHidden = true
                    guard let expertType = tfExpertSelect.text, expertType.isEmpty == false else {
                        lbHitExpertSelect.isHidden = false
                        return
                    }
//                    ["아티스트", "셀럽"]
                    let isArtist:Bool = (expertType == "아티스트")
                    if isArtist {
                        if svPhotoArtist.subviews.count == 0 {
                            self.view.makeToast("아티스트인 경우, 메이크업 관련 자격증 or 메이크업 관련 학과 학생증을 사진으로 올려주셔야 합니다.")
                            return
                        }
                    }
                    
                    if svPhotoProfile.subviews.count == 0 {
                        self.view.makeToast("프로필 이미지 필수입니다.")
                        return
                    }
                    
                    if isArtist {
                        var arrImgArtist:[UIImage] = []
                        for subView in svPhotoArtist.subviews {
                            if let subView = subView as? PhotoView, let img = subView.ivThumb.image {
                                arrImgArtist.append(img)
                            }
                        }
                        param["post_file1"] = arrImgArtist
                    }
                    
                    var arrImgProfile:[UIImage] = []
                    for subView in svPhotoProfile.subviews {
                        if let subView = subView as? PhotoView, let img = subView.ivThumb.image{
                            arrImgProfile.append(img)
                        }
                    }
                    param["post_file"] = arrImgProfile
                }
                
                ApiManager.shared.requestMemberSignUp(param: param) { (response) in
                    if let response = response, let code = response["code"] as? Int {
                        if code == 200 {
                            guard let memInfo = response["user"] as? [String:Any] else {
                                return
                            }
                            SharedData.setObjectForKey(user.mem_password!, kMemPassword)
                            SharedData.instance.saveUserInfo(user: memInfo)
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
    func showCamera(_ sourceType: UIImagePickerController.SourceType) {
        let vc = CameraViewController.init()
        vc.delegate = self
        vc.sourceType = sourceType
        vc.maxCount = 6
        self.navigationController?.pushViewController(vc, animated: false)
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

extension MrJoinInfoViewController: CameraViewControllerDelegate {
    func didFinishImagePicker(origin: UIImage?, crop: UIImage?) {
        guard let cropImage = crop else {
            return
        }
        if btnArtist.isSelected {
            scrollViewArtist.isHidden = false
            if svPhotoArtist.subviews.count > 5 {
                return
            }
            let itemView = Bundle.main.loadNibNamed("PhotoView", owner: self, options: nil)?.first as! PhotoView
            svPhotoArtist.addArrangedSubview(itemView)
            itemView.ivThumb.image = cropImage
            itemView.delegate = self
        }
        else {
            scrollViewProfile.isHidden = false
            if svPhotoProfile.subviews.count > 5 {
                return
            }
            let itemView = Bundle.main.loadNibNamed("PhotoView", owner: self, options: nil)?.first as! PhotoView
            svPhotoProfile.addArrangedSubview(itemView)
            itemView.ivThumb.image = cropImage
            itemView.delegate = self
        }
    }
    func didFinishImagePickerAssets(_ assets: [PHAsset]?) {
        guard let assets = assets, assets.isEmpty == false else {
            return
        }
        if btnArtist.isSelected {
            scrollViewArtist.isHidden = false
            if svPhotoArtist.subviews.count > 5 {
                return
            }
            var k = svPhotoArtist.subviews.count
            for asset in assets {
                k += 1
                if k > 6 {
                    break
                }
                let itemView = Bundle.main.loadNibNamed("PhotoView", owner: self, options: nil)?.first as! PhotoView
                svPhotoArtist.addArrangedSubview(itemView)
                itemView.asset = asset
                itemView.delegate = self
            }
        }
        else {
            scrollViewProfile.isHidden = false
            if svPhotoProfile.subviews.count > 5 {
                return
            }
            var k = svPhotoProfile.subviews.count
            for asset in assets {
                k += 1
                if k > 6 {
                    break
                }
                let itemView = Bundle.main.loadNibNamed("PhotoView", owner: self, options: nil)?.first as! PhotoView
                svPhotoProfile.addArrangedSubview(itemView)
                itemView.asset = asset
                itemView.delegate = self
            }
        }
    }
    
}
extension MrJoinInfoViewController: PhotoViewDelegate {
    func didClickDelAction(object: Any?) {
        guard let object = object as? PhotoView else {
            return
        }
        if let scrollView = object.superview?.superview as? UIScrollView,
           let svContent = object.superview as? UIStackView {
            if svContent.subviews.count == 1 {
                scrollView.isHidden = true
            }
        }
        object.removeFromSuperview()
    }
}
