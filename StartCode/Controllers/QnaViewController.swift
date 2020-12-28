//
//  QnaViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/13.
//

import UIKit
import Photos

class QnaViewController: BaseViewController {
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
    var type:QnaType = .oneToQna
    var passData:[String:Any]?
    
    let accessoryView = CToolbar.init(barItems: [.keyboardDown], itemColor: ColorAppDefault)
    override func viewDidLoad() {
        super.viewDidLoad()

        CNavigationBar.drawBackButton(self, "전문가", false, nil)
        
        for btn in arrMakeupQna {
            btn.addTarget(self, action: #selector(onClickedBtnActions(_:)), for: .touchUpInside)
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
        tfTitle.inputAccessoryView = accessoryView
        tvContent.inputAccessoryView = accessoryView
        accessoryView.addTarget(self, selctor:#selector(onClickedBtnActions(_:)))
        self.addTapGestureKeyBoardDown()
        
        self.changeTapMenu()
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
        SharedData.instance.enableChangeTabMenu = false
    }
    
    func changeTapMenu() {
        self.decorationUi()
    }
    
    func decorationUi() {
        self.view.layoutIfNeeded()
        for btn in arrMakeupQna {
            btn.isSelected = false
        }
        btnArtist.isSelected = false
        btnCeleb.isSelected = false
        
        scrollViewPhototo.isHidden = true
        for subView in svPhoto.subviews {
            subView.removeFromSuperview()
        }
        svQna1.isHidden = true
        svQna2.isHidden = true
        svQna3.isHidden = true
        tfTitle.isHidden = true
        svSelectedContainer.isHidden = true
        tvContent.text = ""
        if type == .makeupQna {
            svSelectedContainer.isHidden = false
            lbTitle.text = "회원 여러분의 메이크업을 진단해드립니다."
            svQna3.isHidden = false
            lbSelectTitle.text = "솔루션을 받고 싶은 전문가를 선택하세요."
            CNavigationBar.drawBackButton(self, "메이크업 진단", false, nil)
        }
        else if type == .beautyQna {
            svSelectedContainer.isHidden = false
            lbTitle.text = "화장품 추천, 피부고민, 닮은 연예인, 아이돌 화장법 등 뷰티에 관한 어떤 질문이든 뷰티 전문가가 1:1 맞춤 솔루션을 제공해 드립니다."
            
            svQna1.isHidden = false
            svQna2.isHidden = false
            lbSelectTitle.text = "원하시는 뷰티 질문을 선택해주세요."
            CNavigationBar.drawBackButton(self, "뷰티질문", false, nil)
        }
        else if type == .aiQna {
            lbTitle.text = "Ai로 메이크업 진단을 받아요."
            CNavigationBar.drawBackButton(self, "Ai 메이크업 진단", false, nil)
        }
        else {
            lbTitle.text = "전문가에게 1:1로 상담 받을 수 있습니다.\n단, 욕설/비방글 등은 신고를 통해 고객님에게 불이익이 발생할 수 있습니다."
            tfTitle.isHidden = false
            tfTitle.setNeedsDisplay()
            CNavigationBar.drawBackButton(self, "1:1 질문", true, #selector(actionPopViewCtrl))
        }
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender == btnArtist {
            btnArtist.isSelected = true
            btnCeleb.isSelected = false
        }
        else if sender == btnCeleb {
            btnArtist.isSelected = false
            btnCeleb.isSelected = true
        }
        else if arrMakeupQna.contains(sender) == true {
//            for btn in arrMakeupQna {
//                btn.isSelected = false
//            }
            sender.isSelected = !sender.isSelected
        }
        else if sender == btnAddPhoto {
            let list = ["갤러리에서 사진 가져오기", "카메라로 사진 촬영하기"]
            let vc = PopupViewController.init(type: .list, data: list) { (vcs, selItem, index) in
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
        else if sender == btnRegist {
            var param:[String:Any] = [:]
          
            if type  == .oneToQna {
                guard let title = tfTitle.text, title.isEmpty == false else {
                    self.showToast("제목을 입력해주세요.")
                    return
                }
                param["post_title"] = title
            }
            else if type == .makeupQna {
                if btnArtist.isSelected == false && btnCeleb.isSelected == false {
                    self.showToast("전문가를 선택해주세요.")
                    return
                }
                var tmpStr = ""
                if btnArtist.isSelected {
                    tmpStr = "아티스트"
                }
                else if btnCeleb.isSelected {
                    tmpStr = "셀럽"
                }
                param["post_tag"] = tmpStr
                
            }
            else if type == .beautyQna {
                var findSelected = false
                var tmpStr = ""
                for i in 0..<arrMakeupQna.count {
                    let btn = arrMakeupQna[i]
                    if let title:String = btn.titleLabel?.text, btn.isSelected {
                        if (findSelected == false) {
                            tmpStr.append(title)
                        }
                        else {
                            tmpStr.append(",\(title)")
                        }
                        findSelected = true
                    }
                }
                
                if findSelected == false {
                    self.showToast("뷰티 질문을 선택해주세요.")
                    return
                }
                
                param["post_tag"] = tmpStr
            }
            
            guard let content = tvContent.text, content.isEmpty == false else {
                self.showToast("질문 내용을 입력해주세요.")
                return
            }
            var images:[UIImage] = []
            for photoView in svPhoto.subviews {
                if let photoView = photoView as? PhotoView, let img = photoView.ivThumb.image {
                    images.append(img)
                }
            }
            if images.count == 0 || scrollViewPhototo.isHidden == true {
                self.showToast("사진을 선택해주세요.")
                return
            }
            guard let token = SharedData.instance.token else {
                return
            }
            
            param["token"] = token
            param["post_content"] = content
            if type == .oneToQna {
                param["post_category"] = "1:1"
            }
            else if type == .beautyQna {
                param["post_title"] = "뷰티질문"
                param["post_category"] = "뷰티질문"
                
            }
            else if type == .makeupQna {
                param["post_title"] = "메이크업진단"
                param["post_category"] = "메이크업진단"
            }
            else {
                param["post_title"] = "ai"
                param["post_category"] = "ai"
            }
            param["post_file"] = images
            
            if type == .oneToQna {
                
                guard let passData = passData else {
                    return
                }
                guard let recv_mem_id = passData["mem_id"] else {
                    return
                }
                guard let mem_nicknamemem_nickname = passData["mem_nickname"] as? String else {
                    return
                }
                guard let mem_chupay = passData["mem_chupay"] as? String else {
                    return
                }
                
                if SharedData.instance.memChu > Int(mem_chupay)! {
                    param["recv_mem_id"] = recv_mem_id
                    
                    let result = "\(mem_nicknamemem_nickname) 전문가에게 1:1 질문을 할 경우\n\(mem_chupay)개의 CHU가 소모됩니다."
                    let attr = NSMutableAttributedString.init(string: result)
                    attr.addAttribute(.foregroundColor, value: RGB(179, 0, 255), range: NSMakeRange(0, mem_nicknamemem_nickname.length))
                    attr.addAttribute(.foregroundColor, value: RGB(179, 0, 255), range: (result as NSString).range(of: "\(mem_chupay)"))
                    
                    let vc = PopupViewController.init(type: .alert, title:nil,  message: attr) { (vcs, selItem, index) in
                        vcs.dismiss(animated: false, completion: nil)
                        if index == 1 {
                            self.requestAskRegist(param)
                        }
                    }
                    vc.addAction(.cancel, "취소")
                    vc.addAction(.ok, "질문하기")
                    self.present(vc, animated: false, completion: nil)
                }
                else {
                    let result = "CHU가 부족합니다.\n지금 구매하러 가시겠습니까?"
                    let vc = PopupViewController.init(type: .alert, title:nil,  message: result) { (vcs, selItem, index) in
                        vcs.dismiss(animated: false, completion: nil)
                        let vc = ChuPurchaseViewController.init()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    vc.addAction(.ok, "CHU 구매하기")
                    self.present(vc, animated: false, completion: nil)
                }
            }
            else if type == .aiQna {
                self.requestAiAskRegist(param)
            }
            else {
                self.requestAskRegist(param)
            }
        }
    }
    
    func requestAskRegist(_ param:[String:Any]) {
        ApiManager.shared.requestAskRegist(param: param) { (response) in
            if let response = response, let code = response["code"] as? Int, code == 200, let message = response["message"] as? String, let last_chu = response["last_chu"] as? Int {
                SharedData.instance.memChu = last_chu
                SharedData.setObjectForKey(last_chu, kMemChu)
                self.updateChuNaviBarItem()
                do {
                    let attr = try NSAttributedString.init(htmlString: message)
                    let vc = PopupViewController.init(type: .alert, title: nil, message: attr) { (vcs, selItem, index) in
                        vcs.dismiss(animated: false, completion: nil)
                        if self.type == .oneToQna {
                            self.navigationController?.popViewController(animated: false)
                        }
                        else {
                            AppDelegate.instance()?.mainTabbarCtrl()?.selectedIndex = 0
                        }
                    }
                    vc.addAction(.ok, "확인")
                    self.present(vc, animated: false, completion: nil)
                } catch {
                    
                }
            }
            else {
                self.showErrorAlertView(response)
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
    func requestAiAskRegist(_ param:[String:Any]) {
        ApiManager.shared.requestAiAskRegist(param: param) { (response) in
            if let response = response, let code = response["code"] as? Int, code == 200 , let message = response["message"] as? String, let last_chu = response["last_chu"] as? Int {
                SharedData.instance.memChu = last_chu
                SharedData.setObjectForKey(last_chu, kMemChu)
                self.updateChuNaviBarItem()
                do {
                    let attr = try NSAttributedString.init(htmlString: message)
                    let vc = PopupViewController.init(type: .alert, title: nil, message: attr) { (vcs, selItem, index) in
                        vcs.dismiss(animated: false, completion: nil)
                        AppDelegate.instance()?.mainTabbarCtrl()?.selectedIndex = 0
                    }
                    vc.addAction(.ok, "확인")
                    self.present(vc, animated: false, completion: nil)
                } catch {
                    
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

extension QnaViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let textView = textView as? CTextView, let lbPlaceHolder = textView.placeholderLabel {
            lbPlaceHolder.isHidden = !textView.text.isEmpty
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
        let picker = Bundle.main.loadNibNamed("PhotoView", owner: self, options: nil)?.first as! PhotoView
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
            let picker = Bundle.main.loadNibNamed("PhotoView", owner: self, options: nil)?.first as! PhotoView
            self.svPhoto.addArrangedSubview(picker)
            picker.delegate = self
            picker.asset = asset
//            picker.decoration()
            count += 1
        }
    }
}

extension QnaViewController: PhotoViewDelegate {
    func didClickDelAction(object: Any?) {
        guard let object = object as? PhotoView else {
            return
        }
        object.removeFromSuperview()
        if svPhoto.subviews.count == 0 {
            scrollViewPhototo.isHidden = true
        }
    }
}
