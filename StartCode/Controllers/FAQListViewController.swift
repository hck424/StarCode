//
//  FAQListViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/23.
//

import UIKit

class FAQListViewController: BaseViewController {

    @IBOutlet weak var svContent: UIStackView!
    var listData:[[String:Any]]?
    override func viewDidLoad() {
        super.viewDidLoad()

        CNavigationBar.drawBackButton(self, "FAQ", #selector(actionPopViewCtrl))
        self.addRightNaviMyChuButton()
        
        self.requestFaqList()
    }
    func requestFaqList() {
        self.configurationUi()
    }
    
    func configurationUi() {
//        guard let listData = listData else {
//            return
//        }
        for i in 0..<20 {
            let cell = Bundle.main.loadNibNamed("FAQCellView", owner: self, options: nil)?.first as! FAQCellView
            cell.configurationData(nil)
            svContent.addArrangedSubview(cell)
        }
    }
}
