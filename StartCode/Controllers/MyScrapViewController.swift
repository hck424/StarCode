//
//  MyScrapViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class MyScrapViewController: BaseViewController {
    @IBOutlet weak var lbEmpty: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CNavigationBar.drawBackButton(self, "스크랩", #selector(actionPopViewCtrl))
        self.addRightNaviMyChuButton()
        
        self.requestScrapList()
    }
    
    func requestScrapList() {
        tblView.reloadData()
    }
}
extension MyScrapViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tblView.dequeueReusableCell(withIdentifier: "MyQnaCell") as? MyQnaCell
        
        if cell == nil {
            cell = Bundle.main.loadNibNamed("MyQnaCell", owner: self, options: nil)?.first as? MyQnaCell
        }
        cell?.configurationData(nil, .type6, indexPath.row)
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
