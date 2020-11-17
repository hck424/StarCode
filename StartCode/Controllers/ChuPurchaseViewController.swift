//
//  ChuPurchaseViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/17.
//

import UIKit

class ChuPurchaseViewController: BaseViewController {

    @IBOutlet var arrBtnChu: [CButton]!
    @IBOutlet weak var btnPurchase: UIButton!
    
    var arrMony:[Int] = [2500, 5900, 12000, 37000, 65000, 119000]
    
    var selMony = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CNavigationBar.drawBackButton(self, "CHU 구매", #selector(actionPopViewCtrl))
        arrBtnChu = arrBtnChu.sorted(by: { (btn1, btn2) -> Bool in
            btn1.tag < btn2.tag
        })
        
        for i in 0..<arrBtnChu.count {
            let btn = arrBtnChu[i]
            btn.addTarget(self, action: #selector(onClickedBtnActions(_:)), for: .touchUpInside)
            
            if i < arrMony.count {
                let money = arrMony[i]
                btn.data = money
            }
        }
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if let sender = sender as? CButton, arrBtnChu.contains(sender) == true {
            for btnChu in arrBtnChu {
                btnChu.isSelected = false
                if let lbCnt = btnChu.viewWithTag(100) as? UILabel {
                    lbCnt.textColor = UIColor.label
                    lbCnt.font = UIFont.systemFont(ofSize: lbCnt.font.pointSize, weight: .regular)
                }
                if let lbMoney = btnChu.viewWithTag(101) as? UILabel {
                    lbMoney.textColor = UIColor.label
                    lbMoney.font = UIFont.systemFont(ofSize: lbMoney.font.pointSize, weight: .regular)
                }
                btnChu.borderColor = RGB(221, 221, 221)
            }
            
            sender.isSelected = true
            let colorSel = RGB(128, 0, 255)
            if let lbCnt = sender.viewWithTag(100) as? UILabel {
                lbCnt.textColor = colorSel
                lbCnt.font = UIFont.systemFont(ofSize: lbCnt.font.pointSize, weight: .bold)
            }
            if let lbMoney = sender.viewWithTag(101) as? UILabel {
                lbMoney.textColor = colorSel
                lbMoney.font = UIFont.systemFont(ofSize: lbMoney.font.pointSize, weight: .bold)
            }
            sender.borderColor = colorSel
            
            if let money = sender.data as? Int {
                self.selMony = money
            }
            print("\(selMony)")
        }
        else if sender == btnPurchase {
            if selMony < 0 {
                self.view.makeToast("금액을 선택해주세요")
                return
            }
            
            //TODO:: 츄 구매
        }
    }
    
}
