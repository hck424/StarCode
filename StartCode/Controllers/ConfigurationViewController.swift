//
//  ConfigurationViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class ConfigurationViewController: BaseViewController {
    @IBOutlet weak var lbChu: UILabel!
    @IBOutlet weak var lbBonusChu: UILabel!
    @IBOutlet weak var lbTotalChu: UILabel!
    @IBOutlet weak var btnChuList: UIButton!
    @IBOutlet weak var tfChu: UITextField!
    @IBOutlet weak var bgAnswer: UIView!
    @IBOutlet weak var btnAnswerOk: SelectedButton!
    @IBOutlet weak var btnAnswerNo: SelectedButton!
    @IBOutlet weak var btnOk: CButton!
    
    var data:[String:Any] = [:]
    var selChu:Int = 0 {
        didSet {
            lbBonusChu.text = "추가 \(selChu) CHU"
            lbTotalChu.text = "\(10+selChu)개"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.selChu = 0
        CNavigationBar.drawBackButton(self, "환경 설정", #selector(actionPopViewCtrl))
        self.removeRightSettingNaviItem()
        
        self.requestMyInfo()
    }
    func requestMyInfo() {
        guard let token = SharedData.instance.token else {
            return
        }
        let param = ["token": token]
        ApiManager.shared.requestMyInfo(param: param) { (response) in
            if let response = response, let user = response["user"] as?[String:Any], let code = response["code"] as? NSNumber, code.intValue == 200 {
                self.data = user
                self.decorationUi()
            }
            else {
                self.showErrorAlertView(response)
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
    func decorationUi() {
        btnAnswerOk.isSelected = false
        btnAnswerNo.isSelected = true
        bgAnswer.bringSubviewToFront(btnAnswerNo)

        if let mem_is_question = data["mem_is_question"] as? String {
            if mem_is_question == "1" {
                btnAnswerOk.isSelected = true
                btnAnswerNo.isSelected = false
                bgAnswer.bringSubviewToFront(btnAnswerOk)
            }
        }
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender == btnAnswerOk {
            btnAnswerOk.isSelected = true
            btnAnswerNo.isSelected = false
            bgAnswer.bringSubviewToFront(btnAnswerOk)
        }
        else if sender == btnAnswerNo {
            btnAnswerOk.isSelected = false
            btnAnswerNo.isSelected = true
            bgAnswer.bringSubviewToFront(btnAnswerNo)
        }
        else if sender == btnChuList {
            var list:[String] = []
            for i in 1..<21 {
                list.append("\(i*10) CHU")
            }
            
            let vc = PopupViewController.init(type: .list, data: list) { (vcs, selItem, index) in
                vcs.dismiss(animated: false, completion: nil)
                guard let selItem = selItem as? String else {
                    return
                }
                self.tfChu.text = selItem
                self.selChu = (index+1) * 10
            }
            self.present(vc, animated: true, completion: nil)
        }
        else if sender == btnOk {
            if btnAnswerOk.isSelected {
                self.requestMyChuSetting(isQuestion: true)
            }
            else {
                self.requestMyChuSetting(isQuestion: false)
            }
        }
    }
    
    func requestMyChuSetting(isQuestion:Bool) {
        guard let token = SharedData.instance.token else {
            return
        }
        let mem_chupay:Int = selChu + 10
        let param:[String:Any] = ["token":token, "mem_chupay": mem_chupay, "mem_is_question": isQuestion]
        ApiManager.shared.requestModifyMyInfo(param: param) { (response) in
            if let response = response, let user = response["user"] as?[String:Any], let code = response["code"] as? NSNumber, code.intValue == 200, let message = response["message"] as? String {
                self.data = user
                self.decorationUi()
                self.showToast(message)
            }
            else {
                self.showErrorAlertView(response)
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
}
