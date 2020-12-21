//
//  ChuPurchaseViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/17.
//

import UIKit

class ChuPurchaseViewController: BaseViewController {

    @IBOutlet weak var btnPurchase: UIButton!
    @IBOutlet weak var svChu: UIStackView!
    
    var arrMony:[Int] = [2500, 5900, 12000, 37000, 65000, 119000]
    var arrData:[[String:Any]] = []
    var selMony = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CNavigationBar.drawBackButton(self, "CHU 구매", #selector(actionPopViewCtrl))
        
        self.requestChuPurchaseList()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoginPopupWithCheckSession()
    }
    func requestChuPurchaseList() {
        guard let token = SharedData.instance.token else {
            return
        }
        let param:[String:Any] = ["token":token]
        ApiManager.shared.requestChuShopList(param: param) { (response) in
            if let response = response, let data = response["data"] as?[String:Any], let list = data["list"] as? Array<[String:Any]> {
                self.arrData = list
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
        guard arrData.isEmpty == false else {
            return
        }
        for subView in svChu.subviews {
            subView.removeFromSuperview()
        }
        
        for item in arrData {
            let btnChu = Bundle.main.loadNibNamed("ChuPurchaseBtn", owner: nil, options: nil)?.first as! ChuPurchaseBtn
            btnChu.configurationData(item)
            svChu.addArrangedSubview(btnChu)
            btnChu.translatesAutoresizingMaskIntoConstraints = false
            btnChu.heightAnchor.constraint(equalToConstant: 40).isActive = true
            btnChu.addTarget(self, action: #selector(onClickedBtnActions(_:)), for: .touchUpInside)
        }
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if let sender = sender as? ChuPurchaseBtn {
            for btn in svChu.subviews {
                if let btn = btn as? ChuPurchaseBtn {
                    btn.isSelected = false
                }
            }
            sender.isSelected = true
        }
        else if sender == btnPurchase {
            if selMony < 0 {
                self.showToast("금액을 선택해주세요")
                return
            }
            
            //TODO:: 츄 구매
        }
    }
    
}
