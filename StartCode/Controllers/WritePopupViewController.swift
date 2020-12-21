//
//  WritePopupViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/26.
//

import UIKit
import Photos
enum WritePopupType {
    case comentWrite, commentModify
}

typealias WritePopupClosure = (_ vcs:UIViewController, _ content:String?, _ images:[UIImage]?, _ actionIdx:Int) ->Void

class WritePopupViewController: BaseViewController {
    
    @IBOutlet weak var btnUpDown: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var textView: CTextView!
    @IBOutlet weak var heightTextView: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var svPhoto: UIStackView!
    
    @IBOutlet weak var heightContainer: NSLayoutConstraint!
    @IBOutlet weak var btnFullClose: UIButton!
    @IBOutlet weak var btnGallery: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var svHideItem: UIStackView!
    
    var type:WritePopupType = .comentWrite
    var completion:WritePopupClosure?
    var isKeyboardDown = false
    convenience init(type:WritePopupType, completion:WritePopupClosure?) {
        self.init()
        self.type = .comentWrite
        self.completion = completion
        
        self.modalPresentationStyle = .formSheet
        self.modalTransitionStyle = .coverVertical
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isHidden = true
        heightContainer.constant = 34
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardNotification()
        textView.becomeFirstResponder()
        btnUpDown.isSelected = false
        textView.placeholderLabel?.isHidden = !textView.text.isEmpty
        textView.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotification()
    }
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender == btnFullClose {
            isKeyboardDown = true
            self.view.endEditing(true)
        }
        else if sender == btnUpDown {
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                self.view.endEditing(true)
            }
            else {
                textView.becomeFirstResponder()
            }
        }
        else if sender == btnCamera {
            self.showCamera(.camera)
        }
        else if sender == btnGallery {
            self.showCamera(.photoLibrary)
        }
        else if sender == btnSend {
            guard let text = textView.text, text.isEmpty == false else {
                return
            }
            
            var images:[UIImage] = []
            for itemView in svPhoto.subviews {
                if let itemView = itemView as? PhotoView {
                    if let image = itemView.ivThumb.image {
                        images.append(image)
                    }
                }
            }
            
            completion?(self, text, images, 100)
        }
    }
    
    func showCamera(_ sourceType: UIImagePickerController.SourceType) {
        let vc = CameraViewController.init()
        vc.delegate = self
        vc.sourceType = sourceType
        vc.maxCount = 10
        self.present(vc, animated: true, completion: nil)
    }
    
    override func notificationHandler(_ notification: NSNotification) {
        let heightKeyboard:CGFloat = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size.height
        let duration = CGFloat((notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue ?? 0.0)
 
        if notification.name == UIResponder.keyboardWillShowNotification {
            var tabBarHeight:CGFloat = 0.0
            if self.navigationController?.tabBarController?.tabBar.isHidden == false {
                tabBarHeight = self.navigationController?.toolbar.bounds.height ?? 0.0
            }
            
            heightContainer.constant = heightKeyboard
            UIView.animate(withDuration: TimeInterval(duration), animations: { [self] in
                self.view.layoutIfNeeded()
            })
        }
        else if notification.name == UIResponder.keyboardWillHideNotification {
            if isKeyboardDown == true {
                isKeyboardDown = false
                heightContainer.constant = 34
                UIView.animate(withDuration: TimeInterval(duration)) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}

extension WritePopupViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            var height = textView.sizeThatFits(CGSize.init(width: textView.bounds.width - textView.contentInset.left - textView.contentInset.right, height: CGFloat.infinity)).height
            height = height + textView.contentInset.top + textView.contentInset.bottom
            heightTextView.constant = height
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let textView = textView as? CTextView {
            textView.placeholderLabel?.isHidden = !textView.text.isEmpty
        }
        
        var height = textView.sizeThatFits(CGSize.init(width: textView.bounds.width - textView.contentInset.left - textView.contentInset.right, height: CGFloat.infinity)).height
        height = height + textView.contentInset.top + textView.contentInset.bottom
        heightTextView.constant = height
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        btnUpDown.isSelected = false
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        btnUpDown.isSelected = true
        return true
    }
}

extension WritePopupViewController: CameraViewControllerDelegate {
    func didFinishImagePicker(origin: UIImage?, crop: UIImage?) {
        
        guard let crop = crop else {
            return
        }
        let count = svPhoto.subviews.count
        if count >= 10 {
            return
        }
        
        scrollView.isHidden = false
        let picker = Bundle.main.loadNibNamed("PhotoView", owner: self, options: nil)?.first as! PhotoView
        picker.ivThumb.image = crop
        svPhoto.addArrangedSubview(picker)
        picker.delegate = self
        textView.becomeFirstResponder()
    }
    
    func didFinishImagePickerAssets(_ assets: [PHAsset]?) {
        guard let assets = assets else {
            return
        }
        
        scrollView.isHidden = false
        
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
        textView.becomeFirstResponder()
    }
}

extension WritePopupViewController: PhotoViewDelegate {
    func didClickDelAction(object: Any?) {
        guard let object = object as? PhotoView else {
            return
        }
        object.removeFromSuperview()
        if svPhoto.subviews.count == 0 {
            scrollView.isHidden = true
        }
    }
}
