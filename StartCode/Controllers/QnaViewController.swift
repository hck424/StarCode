//
//  QnaViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/13.
//

import UIKit
import Photos

enum QnaType {
    case makeupQna, beautyQna, aiQna, faq
}

class QnaViewController: BaseViewController {

    @IBOutlet var arrBtnTab: [SelectedButton]!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tfTitle: CTextField!
    @IBOutlet weak var tvContent: CTextView!
    @IBOutlet weak var btnAddPhoto: CButton!
    @IBOutlet weak var scrollViewPhototo: UIScrollView!
    @IBOutlet weak var svPhoto: UIStackView!
    
    @IBOutlet weak var svSelectedContainer: UIStackView!
    @IBOutlet weak var lbSelectTitle: UILabel!
    @IBOutlet weak var svQna1: UIStackView!
    @IBOutlet weak var svQna2: UIStackView!
    @IBOutlet weak var svQna3: UIStackView!
    
    @IBOutlet var arrMakeupQna: [UIButton]!
    @IBOutlet weak var btnArtist: UIButton!
    @IBOutlet weak var btnCeleb: UIButton!
    @IBOutlet weak var btnRegist: UIButton!
    
    var type:QnaType = .makeupQna
    var selTabIdx = 0
    
    let accessoryView = CToolbar.init(barItems: [.keyboardDown], itemColor: ColorAppDefault)
    override func viewDidLoad() {
        super.viewDidLoad()

        CNavigationBar.drawBackButton(self, "전문가", false, nil)
        CNavigationBar.drawRight(self, "12,00", UIImage(named: "ic_chu"), 999, #selector(actionShowChuVc))
        
        for btn in arrMakeupQna {
            btn.addTarget(self, action: #selector(onClickedBtnActions(_:)), for: .touchUpInside)
        }
        
        for btn in arrBtnTab {
            btn.addTarget(self, action: #selector(onClickedBtnActions(_:)), for: .touchUpInside)
        }
        
        for btn in arrBtnTab {
            if btn.tag == selTabIdx {
                btn.sendActions(for: .touchUpInside)
                break
            }
        }
        
        let tmpStr = "(메이크업 전공자, 메이크업 아티스트 등)"
        let result = "아티스트 \(tmpStr)"
        let attr = NSMutableAttributedString(string: result)
        attr.addAttribute(.foregroundColor, value: RGB(165, 165, 165), range: (result as NSString).range(of: tmpStr))
        btnArtist.setAttributedTitle(attr, for: .normal)
        
        let tmpStr2 = "(뷰티유투버,  SNS스타, 연예인 등)"
        let result2 = "셀럽 \(tmpStr2)"
        let attr2 = NSMutableAttributedString(string: result2)
        attr2.addAttribute(.foregroundColor, value: RGB(165, 165, 165), range: (result2 as NSString).range(of: tmpStr2))
        btnCeleb.setAttributedTitle(attr2, for: .normal)
        
        tvContent.inputAccessoryView = accessoryView
        accessoryView.addTarget(self, selctor:#selector(onClickedBtnActions(_:)))
        self.addTapGestureKeyBoardDown()
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
    func decorationUi() {
        
        scrollViewPhototo.isHidden = true
        svQna1.isHidden = true
        svQna2.isHidden = true
        svQna3.isHidden = true
        tfTitle.isHidden = true
        svSelectedContainer.isHidden = true
        
        if type == .makeupQna {
            svSelectedContainer.isHidden = false
            lbTitle.text = "회원 여러분의 메이크업을 진단해드립니다."
            svQna3.isHidden = false
            lbSelectTitle.text = "솔루션을 받고 싶은 전문가를 선택하세요."
        }
        else if type == .beautyQna {
            svSelectedContainer.isHidden = false
            lbTitle.text = "화장품 추천, 피부고민, 닮은 연예인, 아이돌 화장법 등 뷰티에 관한 어떤 질문이든 뷰티 전문가가 1:1 맞춤 솔루션을 제공해 드립니다."
            
            svQna1.isHidden = false
            svQna2.isHidden = false
            lbSelectTitle.text = "원하시는 뷰티 질문을 선택해주세요."
        }
        else if type == .aiQna {
            lbTitle.text = "Ai로 메이크업 진단을 받아요."
        }
        else {
            lbTitle.text = "전문가에게 1:1로 상담 받을 수 있습니다.\n단, 욕설/비방글 등은 신고를 통해 고객님에게 불이익이 발생할 수 있습니다."
            tfTitle.isHidden = false
            tfTitle.setNeedsDisplay()
            
        }
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        self.view.endEditing(true)
        if let selBtn = sender as? SelectedButton {
            for btn in arrBtnTab {
                btn.isSelected = false
            }
            selBtn.isSelected = true
            
            if selBtn.tag == 0 {
                type = .makeupQna
            }
            else if selBtn.tag == 1 {
                type = .beautyQna
            }
            else if selBtn.tag == 2 {
                type = .aiQna
            }
            else {
                type = .faq
            }
            
            guard let title = selBtn.titleLabel?.text, title.isEmpty == false else {
                return
            }
            for btn in arrMakeupQna {
                btn.isSelected = false
            }
            btnArtist.isSelected = false
            btnCeleb.isSelected = false
            
            CNavigationBar.drawBackButton(self, title, false, nil)
            
            self.decorationUi()
        }
        else if sender == btnArtist {
            btnArtist.isSelected = true
            btnCeleb.isSelected = false
        }
        else if sender == btnCeleb {
            btnArtist.isSelected = false
            btnCeleb.isSelected = true
        }
        else if arrMakeupQna.contains(sender) == true {
            for btn in arrMakeupQna {
                btn.isSelected = false
            }
            sender.isSelected = true
        }
        else if sender == btnAddPhoto {
            let list = ["갤러리에서 사진 가져오기", "카메라로 사진 촬영하기"]
            let vc = PopupViewController.init(type: .list, data: list, keys: nil) { (vcs, selData, index) in
                
                vcs.dismiss(animated: true, completion: nil)
                guard let selData = selData else {
                    return
                }
                if index == 0 {
                    self.showCamera(.photoLibrary)
                }
                else if index == 1 {
                    self.showCamera(.camera)
                }
            }
            
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
            
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

extension QnaViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let textView = textView as? CTextView {
            textView.placeholderLabel?.isHidden = !textView.text.isEmpty
        }
    }
}
extension QnaViewController: CameraViewControllerDelegate {
    func didFinishImagePicker(origin: UIImage?, crop: UIImage?) {
        
        guard let crop = crop else {
            return
        }
        let count = svPhoto.subviews.count
        if count >= 10 {
            return
        }
        
        scrollViewPhototo.isHidden = false
        let picker = Bundle.main.loadNibNamed("ImgPickerView", owner: self, options: nil)?.first as! ImgPickerView
        picker.ivThumb.image = crop
        svPhoto.addArrangedSubview(picker)
        picker.delegate = self
    }
    
    func didFinishImagePickerAssets(_ assets: [PHAsset]?) {
        guard let assets = assets else {
            return
        }
        
        self.scrollViewPhototo.isHidden = false
        
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

extension QnaViewController: ImgPickerViewDelegate {
    func didClickDelAction(object: Any?) {
        guard let object = object as? ImgPickerView else {
            return
        }
        object.removeFromSuperview()
        if svPhoto.subviews.count == 0 {
            scrollViewPhototo.isHidden = true
        }
    }
}
