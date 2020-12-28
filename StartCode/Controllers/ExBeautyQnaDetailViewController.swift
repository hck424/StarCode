//
//  ExAnswerDetailViewController.swift
//  StartCodePro
//
//  Created by 김학철 on 2020/12/27.
//

import UIKit
import Photos

class ExBeautyQnaDetailViewController: BaseViewController {
    @IBOutlet weak var svContent: UIStackView!
    @IBOutlet weak var textView: CTextView!
    @IBOutlet weak var btnFile: CButton!
    @IBOutlet weak var svPhoto: UIStackView!
    @IBOutlet weak var scrollViewPhoto: UIScrollView!
    @IBOutlet weak var btnPass: CButton!
    @IBOutlet weak var btnWrite: CButton!
    
    var data:[String:Any] = [:]
    var type:QnaType = .beautyQna
    
    let accessoryView = CToolbar.init(barItems: [.keyboardDown])
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CNavigationBar.drawBackButton(self, "뷰티질문", #selector(actionPopViewCtrl))
        
        self.requestAnswerDetail()
        textView.inputAccessoryView = accessoryView
        accessoryView.addTarget(self, selctor: #selector(actionKeybardDown))
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
        ApiManager.shared.requestAskDetail(param: param) { (response) in
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
        else if sender == btnPass {
            
        }
        else if sender == btnWrite {
            
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
extension ExBeautyQnaDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let textView = textView as? CTextView {
            textView.placeholderLabel?.isHidden = !textView.text.isEmpty
        }
    }
}
extension ExBeautyQnaDetailViewController: CameraViewControllerDelegate {
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
extension ExBeautyQnaDetailViewController: PhotoViewDelegate {
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
