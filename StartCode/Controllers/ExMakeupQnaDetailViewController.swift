//
//  ExAnswerDetailViewController.swift
//  StartCodePro
//
//  Created by 김학철 on 2020/12/27.
//

import UIKit
import Photos
class ExMakeupQnaDetailViewController: BaseViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var svContent: UIStackView!
    @IBOutlet var arrBtnCategory: [SelectedButton]!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet var arrSvCategoryAnswer: [UIStackView]!
    @IBOutlet weak var scrollViewAnswer: UIScrollView!
    @IBOutlet weak var btnPass: CButton!
    @IBOutlet weak var btnWrite: CButton!
    @IBOutlet weak var scrollViewPhoto: UIScrollView!
    @IBOutlet weak var svPhoto: UIStackView!
    @IBOutlet weak var btnFile: CButton!
    
    var data:[String:Any] = [:]
    var type:QnaType = .makeupQna
    let accessoryView = CToolbar.init(barItems: [.keyboardDown])
    var selSvAnswer:UIStackView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "메이크업 진단", #selector(actionPopViewCtrl))
        
        self.requestAnswerDetail()
        self.arrBtnCategory.sort { (btn1, btn2) -> Bool in
            return btn1.tag < btn2.tag
        }
        self.arrSvCategoryAnswer.sort { (sv1, sv2) -> Bool in
            return sv1.tag < sv2.tag
        }
        
        for sv in arrSvCategoryAnswer {
            if let textView = sv.viewWithTag(100) as? CTextView {
                textView.inputAccessoryView = accessoryView
                accessoryView.addTarget(self, selctor: #selector(actionKeybardDown))
                textView.delegate = self
            }
            if let likeView = sv.viewWithTag(200) {
                for btn in likeView.subviews {
                    if let btn = btn as? SelectedButton {
                        btn.addTarget(self, action: #selector(onClickedBtnActions(_:)), for: .touchUpInside)
                    }
                }
            }
        }
        
        if let sender = arrBtnCategory[0] as? SelectedButton {
            sender.isSelected = true
            categoryView.bringSubviewToFront(sender)
            let index = sender.tag
            selSvAnswer = arrSvCategoryAnswer[index]
        }
        
        self.addTapGestureKeyBoardDown()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardNotification()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotification()
    }
    
    func requestAnswerDetail() {
        guard let token = SharedData.instance.token, let post_id = data["post_id"] else {
            return
        }
        let param = ["token":token, "post_id":post_id]
        ApiManager.shared.requestAnswerDetail(param: param) { (response) in
            if let response = response, let data = response["data"] as? [String:Any] {
                self.data = data
                print("=== post_id: \(data["post_id"])")
                self.configurationUi()
            }
            else {
                self.showErrorAlertView(response)
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
    func configurationUi() {
        self.view.layoutIfNeeded()
        let questView = Bundle.main.loadNibNamed("ExQuestionView", owner: self, options: nil)?.first as! ExQuestionView
        svContent.insertArrangedSubview(questView, at: 0)
        questView.configurationData(data, type)
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if let sender = sender as? SelectedButton, arrBtnCategory.contains(sender) == true {
            for btn in arrBtnCategory {
                btn.isSelected = false
            }
            sender.isSelected = true
            categoryView.bringSubviewToFront(sender)
            
            let index = sender.tag
            selSvAnswer = arrSvCategoryAnswer[index]
            if let selSvAnswer = selSvAnswer, let textView = selSvAnswer.viewWithTag(100) as? CTextView {
                textView.becomeFirstResponder()
            }
            let posX:CGFloat = CGFloat(index)*scrollViewAnswer.bounds.width
            scrollViewAnswer.setContentOffset(CGPoint(x: posX, y: 0), animated: true)
        }
        else if sender == sender as? SelectedButton, let selSvAnswer = selSvAnswer {
            guard let likeView = selSvAnswer.viewWithTag(200), let arrSelBtn = likeView.subviews as? [SelectedButton] else {
                return
            }
            
            for btn in arrSelBtn {
                btn.isSelected = false
                if let lbTitle = btn.viewWithTag(100) as? UILabel {
                    lbTitle.textColor = RGB(155, 155, 155)
                    lbTitle.font = UIFont.systemFont(ofSize: lbTitle.font.pointSize, weight: .regular)
                }
            }
            sender.isSelected = true
            likeView.bringSubviewToFront(sender)
            if let lbTitle = sender.viewWithTag(100) as? UILabel {
                lbTitle.textColor = RGB(128, 0, 255)
                lbTitle.font = UIFont.systemFont(ofSize: lbTitle.font.pointSize, weight: .bold)
            }
        }
        else if sender == btnFile {
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
        else if sender == btnPass {
            let vc = PopupViewController.init(type: .alert, message: "PASS 사유를 입력해주세요.") { (vcs, selItem, index) in
                
                if index == 1 {
                    if let textView = vcs.arrTextView.first, let text = textView.text, text.isEmpty == false {
                        vcs.dismiss(animated: false, completion: nil)
                        self.requestAnswerPass(comment: text)
                    }
                }
                else {
                    vcs.dismiss(animated: false, completion: nil)
                }
            }
            vc.addTextView("500자 이내로 작성해주세요.")
            vc.addAction(.cancel, "취소")
            vc.addAction(.ok, "확인")
            self.present(vc, animated: true, completion: nil)
        }
        else if sender == btnWrite {
            guard let token = SharedData.instance.token, let post_id = data["post_id"] else {
                return
            }
            
            var param:[String:Any] = [:]
            for sv in arrSvCategoryAnswer {
                let index = sv.tag
                var category = ""
                var key = ""
                if index == 0 {
                    category = "눈"
                    key = "eye"
                }
                else if index == 1 {
                    category = "눈썹"
                    key = "eyebrow"
                }
                else if index == 2 {
                    category = "입술"
                    key = "lip"
                }
                else if index == 3 {
                    category = "피부"
                    key = "skin"
                }
                else if index == 4 {
                    category = "총평"
                    key = "etc"
                }
                
                guard let tv = sv.viewWithTag(100) as? CTextView, let text = tv.text, text.isEmpty == false else {
                    self.showToast("\(category)의 답변 내용을 입력해주세요.")
                    return
                }
                
                param["cmt_\(key)"] = text
                
                guard let likeView = sv.viewWithTag(200), let arrSubView = likeView.subviews as? [SelectedButton] else {
                    return
                }
                
                var selIndex:Int = -1
                for btn in arrSubView {
                    if btn.isSelected == true {
                        selIndex = btn.tag
                        break
                    }
                }
                
                if selIndex < 0 {
                    self.showToast("\(category)의 별점을 선택해주세요.")
                    return
                }
                param["cmt_\(key)_star"] = (selIndex+1)
            }
            
            var index = 0
            for photoView in svPhoto.subviews {
                var key = ""
                if index == 0 {
                    key = "eye"
                }
                else if index == 1 {
                    key = "eyebrow"
                }
                else if index == 2 {
                    key = "lip"
                }
                else if index == 3 {
                    key = "skin"
                }
                else {
                    key = "etc"
                }
                if let photoView = photoView as? PhotoView, let img = photoView.ivThumb.image {
                    param["cmt_\(key)_img"] = img
                }
                index += 1
            }
            
            
            print("abc")
            
            param["token"] = token
            param["post_id"] = post_id
            param["cmt_content"] = "none"
            param["mode"] = "c"
            
            ApiManager.shared.requestAnswerComment(param: param) { (response) in
                if let response = response, let code = response["code"] as? NSNumber, let message = response["message"] as? String  {
                    if code.intValue == 200 {
                        self.showToastMainView(message)
                        self.navigationController?.popViewController(animated: true)
                    }
                    else {
                        self.showToast(message)
                    }
                }
                else {
                    self.showErrorAlertView(response)
                }
            } failure: { (error) in
                self.showErrorAlertView(error)
            }
        }
    }
    func requestAnswerPass(comment:String) {
        guard let token = SharedData.instance.token, let post_id = data["post_id"] else {
            return
        }
        
        let param = ["token":token, "post_id":post_id, "cmt_content":comment, "mode":"pass"]
        ApiManager.shared.requestAnswerComment(param: param) { (response) in
            if let response = response, let code = response["code"] as? NSNumber, let message = response["message"] as? String  {
                if code.intValue == 200 {
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    self.showToast(message)
                }
            }
            else {
                self.showErrorAlertView(response)
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
    func showCamera(_ sourceType: UIImagePickerController.SourceType) {
        let vc = CameraViewController.init()
        vc.delegate = self
        vc.sourceType = sourceType
        vc.maxCount = 10
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

extension ExMakeupQnaDetailViewController: UITextViewDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height), animated: true)
//    }
    func textViewDidChange(_ textView: UITextView) {
        if let textView = textView as? CTextView {
            textView.placeholderLabel?.isHidden = !textView.text.isEmpty
        }
    }
}
extension ExMakeupQnaDetailViewController: CameraViewControllerDelegate {
    func didFinishImagePicker(origin: UIImage?, crop: UIImage?) {
        guard let crop = crop else {
            return
        }
        
        let count = svPhoto.subviews.count
        if count >= 10 {
            return
        }
        
        scrollViewPhoto.isHidden = false
        let picker = Bundle.main.loadNibNamed("PhotoView", owner: self, options: nil)?.first as! PhotoView
        picker.ivThumb.image = crop
        svPhoto.addArrangedSubview(picker)
        picker.delegate = self
    }
    
    func didFinishImagePickerAssets(_ assets: [PHAsset]?) {
        guard let assets = assets else {
            return
        }
        scrollViewPhoto.isHidden = false
        var count = svPhoto.subviews.count
        if count >= 10 {
            return
        }
        
        for asset in assets {
            if count >= 10 {
                break
            }
            let picker = Bundle.main.loadNibNamed("PhotoView", owner: self, options: nil)?.first as! PhotoView
            svPhoto.addArrangedSubview(picker)
            picker.delegate = self
            picker.asset = asset
            count += 1
        }
    }
}
extension ExMakeupQnaDetailViewController: PhotoViewDelegate {
    func didClickDelAction(object: Any?) {
        guard let object = object as? PhotoView else {
            return
        }
        object.removeFromSuperview()
        if svPhoto.subviews.count == 0 {
            scrollViewPhoto.isHidden = true
        }
    }
}
