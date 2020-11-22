//
//  ChuHistoryViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class ChuHistoryViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CNavigationBar.drawBackButton(self, "CHU 사용내역", #selector(actionPopViewCtrl))
        self.addRightNaviMyChuButton()
        
        self.requestMyChuHistory()
    }
    
    func requestMyChuHistory() {
        self.tblView.reloadData {
            
        }
    }


}
extension ChuHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MyQnaCell") as? MyQnaCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("MyQnaCell", owner: self, options: nil)?.first as? MyQnaCell
        }
        
        cell?.configurationData(nil, .type4, indexPath.row)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
