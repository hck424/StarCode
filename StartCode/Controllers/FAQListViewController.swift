//
//  FAQListViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/23.
//

import UIKit

class FAQListViewController: BaseViewController {

    @IBOutlet weak var svContent: UIStackView!
    var listData:[[String:Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "FAQ", #selector(actionPopViewCtrl))
        
        self.requestFaqList()
    }
    
    func requestFaqList() {
        let param:[String:Any] = ["akey":akey, "page":1, "per_page":10, "fgr_key": "app"]
        ApiManager.shared.requestFAQList(param: param) { (response) in
            if let response = response, let data = response["data"] as? [String:Any], let list = data["list"] as? Array<[String:Any]> {
                self.listData = list
                self.configurationUi()
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }

        self.configurationUi()
    }
    
    func configurationUi() {
        if listData.isEmpty == true {
            return
        }
        
        for item in listData {
            let cell = Bundle.main.loadNibNamed("FAQCellView", owner: self, options: nil)?.first as! FAQCellView
            cell.configurationData(item)
            svContent.addArrangedSubview(cell)
        }
    }
}
