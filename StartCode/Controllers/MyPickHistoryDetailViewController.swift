//
//  MyPickHistoryDetailViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class MyPickHistoryDetailViewController: BaseViewController {
    @IBOutlet weak var lbEmpty: UILabel!
    
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "내 픽", #selector(actionPopViewCtrl))
        self.addRightNaviMyChuButton()
        
        self.requestMyPickHistoryDetail()
    }
    
    func requestMyPickHistoryDetail() {
        self.tblView.reloadData()
    }
    
}

extension MyPickHistoryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "MyQnaCell") as? MyQnaCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("MyQnaCell", owner: self, options: nil)?.first as? MyQnaCell
        }
        cell?.configurationData(nil, .type1, indexPath.row)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
