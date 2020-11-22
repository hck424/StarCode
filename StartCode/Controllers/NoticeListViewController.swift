//
//  NoticeListViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class NoticeListViewController: BaseViewController {

    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        CNavigationBar.drawBackButton(self, "공지사항", #selector(actionPopViewCtrl))
        self.addRightNaviMyChuButton()
        
        let footerView = Bundle.main.loadNibNamed("TableFooterView", owner: nil, options: nil)?.first as! TableFooterView
        
        self.tblView.tableFooterView = footerView
        self.requestNoticeList()
    }
    
    func requestNoticeList() {
        self.tblView.reloadData()
    }
}

extension NoticeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell") as? NoticeCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("NoticeCell", owner: self, options: nil)?.first as? NoticeCell
        }
        cell?.configutaitonData(.notice, nil)
        return cell!
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = NoticeDetailViewController.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
