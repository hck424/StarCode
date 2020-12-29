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
    @IBOutlet weak var lbHitName: UILabel!
    @IBOutlet weak var btnBank: UIButton!
    @IBOutlet weak var tfBank: UITextField!
    @IBOutlet weak var lbHitBank: UILabel!
    @IBOutlet weak var btnExchange: UIButton!
    @IBOutlet weak var tfExchange: UITextField!
    @IBOutlet weak var lbHitExchange: UILabel!
    @IBOutlet weak var tfBankNumber: CTextField!
    @IBOutlet weak var lbHitBankNumber: UILabel!
    @IBOutlet weak var tfIdentifyNumber: CTextField!
    @IBOutlet weak var lbHitIdentifyNumber: UILabel!
    @IBOutlet weak var btnTerm: UIButton!
    @IBOutlet weak var btnOk: CButton!
    
    let accessoryView = CToolbar.init(barItems: [.keyboardDown])
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CNavigationBar.drawBackButton(self, "CHU 전환하기", #selector(actionPopViewCtrl))
        self.removeRightSettingNaviItem()
        
        tfName.inputAccessoryView = accessoryView
        tfBankNumber.inputAccessoryView = accessoryView
        tfIdentifyNumber.inputAccessoryView = accessoryView
        accessoryView.addTarget(self, selctor: #selector(actionKeybardDown))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardNotification()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotification()
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender == btnBank {
            let list:[String] = ["우리은행", "농협", "기업은행", "신한은행"]
            let vc = PopupViewController.init(type: .list, data: list) { (vcs, selItem, index) in
                vcs.dismiss(animated: false, completion: nil)
                guard let selItem = selItem as? String else {
                    return
                }
                self.tfBank.text = selItem
            }
            self.present(vc, animated: true, completion: nil)
        }
        else if sender == btnExchange {
            let list:[String] = ["일부 환전요청", "전액환전"]
            let vc = PopupViewController.init(type: .list, data: list) { (vcs, selItem, index) in
                vcs.dismiss(animated: false, completion: nil)
                guard let selItem = selItem as? String else {
                    return
                }
                self.tfExchange.text = selItem
            }
            self.present(vc, animated: true, completion: nil)
        }
        else if sender == btnTerm {
            sender.isSelected = !sender.isSelected
        }
        else if sender == btnOk {
            lbHitName.isHidden = true
            lbHitBank.isHidden = true
            lbHitExchange.isHidden = true
            lbHitBankNumber.isHidden = true
            lbHitIdentifyNumber.isHidden = true
            
            guard let name = tfName.text, name.isEmpty == false else {
                lbHitName.isHidden = false
                return
            }
            
            guard let bankName = tfBank.text, bankName.isEmpty == false else {
                lbHitBank.isHidden = false
                return
            }
            
            guard let exchange = tfExchange.text, exchange.isEmpty == false else {
                lbHitExchange.isHidden = false
                return
            }
            
            guard let bankNumber = tfBankNumber.text, bankNumber.isEmpty == false else {
                lbHitBankNumber.isHidden = false
                return
            }
            
            guard let identify = tfIdentifyNumber.text, identify.isEmpty == false else {
                lbHitIdentifyNumber.isHidden = false
                return
            }
            
            if btnTerm.isSelected == false {
                self.showToast("약관을 동의해주세요.")
                return
            }
            
            
        }
        
    }
}
extension ChuExportViewController: UITextFieldDelegate {
    
}
extension ChuExportViewController: UITextViewDelegate {
    
}
