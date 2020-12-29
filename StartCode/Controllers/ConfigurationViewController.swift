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
    var selChu:Int = 0 {
        didSet {
            lbBonusChu.text = "추가 \(selChu) CHU"
            lbTotalChu.text = "\(10+selChu)개"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CNavigationBar.drawBackButton(self, "환경 설정", #selector(actionPopViewCtrl))
        self.removeRightSettingNaviItem()
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
            
        }
    }
}
