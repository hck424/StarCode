//
//  TalkWriteViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/17.
//

import UIKit
import Photos
enum TalkWriteType {
    case new, modify
}
protocol TalkWriteViewControllerDelegate {
    func didfinishTalkWriteCompletion(category:String)
}
class TalkWriteViewController: BaseViewController {
    @IBOutlet weak var btnCategory: CButton!
    @IBOutlet weak var tfCategory: CTextField!
    @IBOutlet weak var tfTitle: CTextField!
    @IBOutlet weak var tvContent: CTextView!
    @IBOutlet weak var photoScrollView: UIScrollView!
    @IBOutlet weak var svPhoto: UIStackView!
    @IBOutlet weak var btnAddPhoto: CButton!
    @IBOutlet weak var btnRegist: UIButton!
    var type:TalkWriteType = .new
    var delegate: TalkWriteViewControllerDelegate?
    var selCategory = "화장법"
    let accessoryView = CToolbar.init(barItems: [.keyboardDown])
    var data:[String:Any]? 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CNavigationBar.drawBackButton(self, "글 등록", #selector(actionPopViewCtrl))
        tfCategory.text = selCategory
        tfTitle.inputAccessoryView = accessoryView
        tvContent.inputAccessoryView = accessoryView
        accessoryView.addTarget(self, selctor: #selector(actionKeybardDown))
        self.addTapGestureKeyBoardDown()
        
        if type == .modify && data != nil {
            self.view.layoutIfNeeded()
            self.configurationUi()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardNotification()
        self.showLoginPopupWithCheckSession()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotification()
    }
    func configurationUi() {
        guard let data = data else {
            return
        }
        
        if let post_category = data["post_category"] as? String {
            self.selCategory = post_category
            tfCategory.text = post_category
        }
        
        if let post_title = data["post_title"] as? String {
            tfTitle.text = post_title
        }
        if let post_content = data["post_content"] as? String {
            tvContent.text = post_content
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                let width = self.tvContent.bounds.width
                let height = self.tvContent.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
                self.tvContent.contentSize = CGSize(width: width, height: height)
            }
        }
        
        if let files = data["files"] as? Array<[String:Any]>, files.isEmpty == false {
            photoScrollView.isHidden = false
            for item in files {
                if let pfi_filename = item["pfi_filename"] as? String, pfi_filename.isEmpty == false {
                    let itemView = Bundle.main.loadNibNamed("PhotoView", owner: self, options: nil)?.first as! PhotoView
                    itemView.delegate = self
                    svPhoto.addArrangedSubview(itemView)
                    itemView.ivThumb.setImageCache(url: pfi_filename, placeholderImgName: nil)
                }
            }
        }
    }
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender == btnAddPhoto {
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
        else if sender == btnCategory {
            let vc = PopupViewController.init(type: .list, data: SharedData.instance.categorys, completion: { (vcs, selItem, index) in
                vcs.dismiss(animated: false, completion: nil)
                guard let selItem = selItem as? String else {
                    return
                }
                self.tfCategory.text = selItem
                self.selCategory = selItem
            })
            self.present(vc, animated: false, completion: nil)
        }
        else if sender == btnRegist {
            self.view.endEditing(true)
            guard let token = SharedData.instance.token else {
                return
            }
            guard let post_category = tfCategory.text, post_category.isEmpty == false else {
                self.showToast("카테고리를 선택해주세요.")
                return
            }
            guard let post_title = tfTitle.text, post_title.isEmpty == false else {
                self.showToast("제목을 입력해주세요.")
                return
            }
            guard let post_content = tvContent.text, post_content.isEmpty == false else {
                self.showToast("내용을 입력해주세요.")
                return
            }
            guard svPhoto.subviews.isEmpty == false else {
                self.showToast("이미지 한장은 필수입니다.")
                return
            }
            var arrImage:[UIImage] = []
            arrImage.removeAll()
            for photoView in svPhoto.subviews {
                if let photoView = photoView as? PhotoView, let img = photoView.ivThumb.image {
                    arrImage.append(img)
                }
            }
            if type == .new {
                let param:[String:Any] = ["token":token, "post_category":post_category, "post_title":post_title, "post_content":post_content, "post_file":arrImage]
                ApiManager.shared.requestTalkWrite(param: param) { (response) in
                    if let response = response, let code = response["code"] as? Int, let message = response["message"] as?String, code == 200 {
                        self.showToast(message)
                        self.delegate?.didfinishTalkWriteCompletion(category: post_category)
                        self.navigationController?.popViewController(animated: true)
                    }
                    else {
                        self.showErrorAlertView(response)
                    }
                } failure: { (error) in
                    self.showErrorAlertView(error)
                }
            }
            else if type == .modify {
                guard let data = data, let post_id = data["post_id"] else {
                    return
                }
                
                let param:[String:Any] = ["token":token, "post_id":post_id, "post_category":post_category, "post_title":post_title, "post_content":post_content, "post_file":arrImage]
                ApiManager.shared.requestTalkModify(param: param) { (response) in
                    if let response = response, let code = response["code"] as? Int, let message = response["message"] as?String, code == 200 {
                        self.showToast(message)
                        self.delegate?.didfinishTalkWriteCompletion(category: post_category)
                        self.navigationController?.popViewController(animated: true)
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
    func showCamera(_ sourceType: UIImagePickerController.SourceType) {
        let vc = CameraViewController.init()
        vc.delegate = self
        vc.sourceType = sourceType
        vc.maxCount = 10
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

extension TalkWriteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let textView = textView as? CTextView {
            textView.placeholderLabel?.isHidden = !textView.text.isEmpty
        }
    }
    
}

extension TalkWriteViewController: CameraViewControllerDelegate {
    func didFinishImagePicker(origin: UIImage?, crop: UIImage?) {
        
        guard let crop = crop else {
            return
        }
        let count = svPhoto.subviews.count
        if count >= 10 {
            return
        }
        
        photoScrollView.isHidden = false
        let picker = Bundle.main.loadNibNamed("PhotoView", owner: self, options: nil)?.first as! PhotoView
        picker.ivThumb.image = crop
        svPhoto.addArrangedSubview(picker)
        picker.delegate = self
    }
    
    func didFinishImagePickerAssets(_ assets: [PHAsset]?) {
        guard let assets = assets else {
            return
        }
        
        photoScrollView.isHidden = false
        
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
            picker.decoration()
            count += 1
        }
    }
}

extension TalkWriteViewController: PhotoViewDelegate {
    func didClickDelAction(object: Any?) {
        guard let object = object as? PhotoView else {
            return
        }
        object.removeFromSuperview()
        if svPhoto.subviews.count == 0 {
            photoScrollView.isHidden = true
        }
    }
}
