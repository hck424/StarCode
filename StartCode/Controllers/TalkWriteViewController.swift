//
//  TalkWriteViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/17.
//

import UIKit
import Photos
enum TalkWriteType {
    case write, modify
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
    
    let arrCategory = ["연예", "패션", "헤어", "픽!쳐톡", "화장법", "다이어트"]
    var selCategory = "화장법"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CNavigationBar.drawBackButton(self, "글 등록", #selector(actionPopViewCtrl))
        CNavigationBar.drawRight(self, "12,00", UIImage(named: "ic_chu"), 999, #selector(actionShowChuVc))
        tfCategory.text = selCategory
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tvContent.delegate = self
        tvContent.placeholderLabel?.isHidden = !tvContent.text.isEmpty
        self.addKeyboardNotification()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotification()
    }

    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender == btnAddPhoto {
            let list = ["갤러리에서 사진 가져오기", "카메라로 사진 촬영하기"]
            let vc = PopupViewController.init(type: .list, data: list)
            vc.didSelectRowAtItem = {(vcs, selData, index) ->Void in
                vcs.dismiss(animated: false, completion: nil)
                if index == 0 {
                    self.showCamera(.photoLibrary)
                }
                else if index == 1 {
                    self.showCamera(.camera)
                }
            }
            self.present(vc, animated: false, completion: nil)
        }
        else if sender == btnCategory {
            let vc = PopupViewController.init(type: .list, data: arrCategory)
            vc.didSelectRowAtItem = {(vcs, selData, index) ->Void in
                vcs.dismiss(animated: false, completion: nil)
                guard let selData = selData as? String else {
                    return
                }
                self.tfCategory.text = selData
                self.selCategory = selData
            }
            self.present(vc, animated: false, completion: nil)
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
        let picker = Bundle.main.loadNibNamed("ImgPickerView", owner: self, options: nil)?.first as! ImgPickerView
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
            let picker = Bundle.main.loadNibNamed("ImgPickerView", owner: self, options: nil)?.first as! ImgPickerView
            self.svPhoto.addArrangedSubview(picker)
            picker.delegate = self
            picker.asset = asset
            picker.decoration()
            count += 1
        }
    }
}

extension TalkWriteViewController: ImgPickerViewDelegate {
    func didClickDelAction(object: Any?) {
        guard let object = object as? ImgPickerView else {
            return
        }
        object.removeFromSuperview()
        if svPhoto.subviews.count == 0 {
            photoScrollView.isHidden = true
        }
    }
}
