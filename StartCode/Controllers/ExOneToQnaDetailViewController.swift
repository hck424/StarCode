//
//  ExOneToQnaDetailViewController.swift
//  StartCodePro
//
//  Created by 김학철 on 2020/12/27.
//

import UIKit
import Photos

class ExOneToQnaDetailViewController: BaseViewController {
    @IBOutlet weak var svContent: UIStackView!
    @IBOutlet weak var textView: CTextView!
    @IBOutlet weak var btnFile: CButton!
    @IBOutlet weak var svPhoto: UIStackView!
    @IBOutlet weak var scrollViewPhoto: UIScrollView!
    @IBOutlet weak var btnWarning: CButton!
    @IBOutlet weak var btnWrite: CButton!
    
    var data:[String:Any] = [:]
    var type:QnaType = .oneToQna
    let accessoryView = CToolbar.init(barItems: [.keyboardDown])
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tmpStr = "(1:1 질문)"
        let result = String(format: "내게 주어진 질문 %@", tmpStr)
        let attr = NSMutableAttributedString.init(string: result)
        attr.addAttribute(.foregroundColor, value: RGB(155, 155, 155), range: ((result as NSString).range(of: tmpStr)))
        CNavigationBar.drawBackButton(self, attr, #selector(onClickedBtnActions(_:)))
        textView.inputAccessoryView = accessoryView
        accessoryView.addTarget(self, selctor: #selector(actionKeybardDown))
        
        self.addTapGestureKeyBoardDown()
        
        self.requestAnswerDetail()
        
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
        if sender == btnFile {
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
        else if sender.tag == TAG_NAVI_BACK {
            let vc = PopupViewController.init(type: .alert, message:"답변을 취소할 경우 1CHU가 차감됩니다.") { (vcs, selData, index) in
                vcs.dismiss(animated: false, completion: nil)
                if index == 1 {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            vc.addAction(.cancel, "취소")
            vc.addAction(.ok, "확인")
            self.present(vc, animated: true, completion: nil)
        }
        else if sender == btnWarning {
            guard let token = SharedData.instance.token, let post_id = data["post_id"] as? String else {
                return
            }
            let param = ["token":token, "post_id":post_id]
            ApiManager.shared.requestAnswerBlame(param:param) { (response) in
                if let response = response, let message = response["message"] as? String {
                    self.showToast(message)
                }
            } failure: { (error) in
                self.showErrorAlertView(error)
            }
        }
        else if sender == btnWrite {
            self.view.endEditing(true)
            
            guard let token = SharedData.instance.token, let post_id = data["post_id"] else {
                return
            }
            guard let content = textView.text, content.isEmpty == false else {
                self.showToast("답변 내용을 입력해주세요.")
                return
            }
            guard let arrPhtoView = svPhoto.subviews as? [PhotoView], arrPhtoView.isEmpty == false else {
                self.showToast("사진을 선택해주세요.")
                return
            }
            
            
            var param: [String:Any] = [:]
            param["post_category"] = "1:1"
            param["cmt_content"] = content
            param["token"] = token
            param["post_id"] = post_id
            param["mode"] = "c"
            if let post_tag = data["post_tag"] as? String, post_tag.isEmpty == false {
                param["post_tag"] = post_tag
            }
            var arrImg:[UIImage] = []
            for photoview in arrPhtoView {
                if let photoview = photoview as? PhotoView, let img = photoview.ivThumb.image {
                    arrImg.append(img)
                }
            }
            if arrImg.isEmpty == false {
                param["post_file"] = arrImg
            }

            ApiManager.shared.requestAnswerComment(param: param) { (response) in
                if let response = response, let code = response["code"] as? NSNumber, let message = response["message"] as? String  {
                    if code.intValue == 200 {
                        self.showToast(message)
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
extension ExOneToQnaDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let textView = textView as? CTextView {
            textView.placeholderLabel?.isHidden = !textView.text.isEmpty
        }
    }
}
extension ExOneToQnaDetailViewController: CameraViewControllerDelegate {
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
        
        self.scrollViewPhoto.isHidden = false
        
        var count = svPhoto.subviews.count
        if count >= 10 {
            return
        }
        
        for asset in assets {
            if count >= 10 {
                break
            }
            let picker = Bundle.main.loadNibNamed("PhotoView", owner: self, options: nil)?.first as! PhotoView
            self.svPhoto.addArrangedSubview(picker)
            picker.delegate = self
            picker.asset = asset
            count += 1
        }
    }
}
extension ExOneToQnaDetailViewController: PhotoViewDelegate {
    func didClickDelAction(object: Any?) {
        guard let object = object as? PhotoView else {
            return
        }
        object.removeFromSuperview()
        if svPhoto.subviews.count == 0 {
            self.scrollViewPhoto.isHidden = true
        }
    }
}
