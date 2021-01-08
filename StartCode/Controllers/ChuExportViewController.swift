//
//  ChuExportViewController.swift
//  StartCodePro
//
//  Created by 김학철 on 2020/12/29.
//

import UIKit

class ChuExportViewController: BaseViewController {
    @IBOutlet weak var lbNickName: UILabel!
    @IBOutlet weak var lbTotalChu: UILabel!
    
    @IBOutlet weak var tfName: CTextField!
    @IBOutlet weak var lbHintName: UILabel!
    @IBOutlet weak var btnBank: UIButton!
    @IBOutlet weak var tfBank: UITextField!
    @IBOutlet weak var lbHintBank: UILabel!
    @IBOutlet weak var btnExchange: UIButton!
    @IBOutlet weak var tfExchange: UITextField!
    @IBOutlet weak var lbHintExchange: UILabel!
    @IBOutlet weak var tfBankNumber: CTextField!
    @IBOutlet weak var lbHintBankNumber: UILabel!
    @IBOutlet weak var tfIdentifyNumber: CTextField!
    @IBOutlet weak var lbHintIdentifyNumber: UILabel!
    @IBOutlet weak var btnTerm: UIButton!
    @IBOutlet weak var btnOk: CButton!
    @IBOutlet weak var tvTerms: CTextView!
    var banks:[String]?
    var termsService:String?
    var selChu:Int = 0
    let accessoryView = CToolbar.init(barItems: [.keyboardDown])
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CNavigationBar.drawBackButton(self, "CHU 전환하기", #selector(actionPopViewCtrl))
        self.removeRightSettingNaviItem()
        self.decorationUi()
        tfName.inputAccessoryView = accessoryView
        tfBankNumber.inputAccessoryView = accessoryView
        tfIdentifyNumber.inputAccessoryView = accessoryView
        accessoryView.addTarget(self, selctor: #selector(actionKeybardDown))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardNotification()
        self.requestExchangeInfo()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotification()
    }
    func decorationUi() {
        lbHintName.text = ""
        lbTotalChu.text = ""
        
        if let nickName = SharedData.objectForKey(kMemNickname) as? String {
            lbNickName.text = nickName
        }
        let chu = SharedData.instance.memChu
        lbTotalChu.text = "\(chu.addComma())개"
        
        tvTerms.text = nil
        tvTerms.attributedText = nil
        if let termsService = termsService as? String {
            do {
                let attr = try NSAttributedString.init(htmlString: termsService)
                tvTerms.attributedText = attr
            }
            catch {
                
            }
        }
    }
    func requestExchangeInfo() {
        ApiManager.shared.requestExchangeInfo { (response) in
            if let response = response, let code = response["code"] as? NSNumber, code.intValue == 200 {
                if let banks = response["banks"] as? String {
                    if let arrBank = banks.components(separatedBy: ",") as? [String] {
                        self.banks = arrBank
                    }
                }
                if let terms_service = response["terms_service"] as? String {
                    self.termsService = terms_service
                }
                self.decorationUi()
            }
            else {
                self.showErrorAlertView(response)
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }

    }
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender == btnBank {
            self.view.endEditing(true)
            guard let banks = banks  else {
                return
            }
            let vc = PopupViewController.init(type: .list, data: banks) { (vcs, selItem, index) in
                vcs.dismiss(animated: false, completion: nil)
                guard let selItem = selItem as? String else {
                    return
                }
                self.tfBank.text = selItem
            }
            self.present(vc, animated: true, completion: nil)
        }
        else if sender == btnExchange {
            self.view.endEditing(true)
            
            let vc = PopupViewController.init(type: .alert) { (vcs, selItem, index) in
                vcs.dismiss(animated: false, completion: nil)
                self.selChu = vcs.slierVlaue
                self.tfExchange.text = "\(self.selChu)CHU"
            }
            vc.addAction(.cancel, "취소")
            vc.addAction(.ok, "확인")
            vc.addSliderBar(0, 200, 10)
            
            self.present(vc, animated: true, completion: nil)
        }
        else if sender == btnTerm {
            sender.isSelected = !sender.isSelected
        }
        else if sender == btnOk {
            lbHintName.isHidden = true
            lbHintBank.isHidden = true
            lbHintExchange.isHidden = true
            lbHintBankNumber.isHidden = true
            lbHintIdentifyNumber.isHidden = true
            
            var isOK = true
            if let name = tfName.text, name.isEmpty == true {
                isOK = false
                lbHintName.text = "이름을 입력해주세요."
                lbHintName.isHidden = false
            }
            if let bankName = tfBank.text, bankName.isEmpty == true {
                lbHintBank.text = "은행명을 선택해주세요."
                lbHintBank.isHidden = false
                isOK = false
            }
            if let exchange = tfExchange.text, exchange.isEmpty == true {
                lbHintExchange.text = "환전 요청할 CHU개수를 선택해주세요."
                lbHintExchange.isHidden = false
                isOK = false
            }
            if let bankNumber = tfBankNumber.text, bankNumber.isEmpty == true {
                lbHintBankNumber.text = "주민번호를 입력해주세요."
                lbHintBankNumber.isHidden = false
                isOK = false
            }
            if let identify = tfIdentifyNumber.text, identify.isEmpty == true {
                lbHintIdentifyNumber.isHidden = false
                isOK = false
            }
            
            if isOK == false {
                return
            }
            
            if btnTerm.isSelected == false {
                self.showToast("약관을 동의해주세요.")
                return
            }
            
            let memChu:Float = Float(SharedData.instance.memChu)!
            if memChu < Float(selChu) {
                self.showToast("환전할 츄는 보유츄보다 작아야합니다.")
                return
            }
            
            guard let token = SharedData.instance.token else {
                return
            }
            let param:[String:Any] = ["token":token, "bankname":tfBank.text!, "user_name":tfName.text!, "an":tfBankNumber.text!, "snid":tfIdentifyNumber.text!, "exc_chu":selChu]
            ApiManager.shared.requestExchageChu(param: param) { (response) in
                if let response = response, let code = response["code"] as? NSNumber, let message = response as? String, code.intValue == 200 {
                    if let mem_chu = response["mem_chu"] as? NSNumber {
                        SharedData.setObjectForKey("\(mem_chu)", kMemChu)
                        SharedData.instance.memChu = "\(mem_chu)"
                        self.updateChuNaviBarItem()
                        AppDelegate.instance()?.mainTabbarCtrl()?.view.makeToast(message)
                        self.navigationController?.popViewController(animated: true)
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
}
extension ChuExportViewController: UITextFieldDelegate {
    
}
extension ChuExportViewController: UITextViewDelegate {
    
}
