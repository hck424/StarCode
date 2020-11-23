//
//  ContactUsListViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class ContactUsListViewController: BaseViewController {

    @IBOutlet weak var btnWrtite: CButton!
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "고객센터", #selector(actionPopViewCtrl))
        self.addRightNaviMyChuButton()
      
        let footerView = Bundle.main.loadNibNamed("TableFooterView", owner: nil, options: nil)?.first as! TableFooterView
        footerView.frame = CGRect.init(x: 0, y: 0, width: tblView.bounds.width, height: 200)
        self.tblView.tableFooterView = footerView
        
        self.requestContactUsList()
    }
    
    func requestContactUsList() {
        self.tblView.reloadData()
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender == btnWrtite {
            let vc = ContactWriteViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ContactUsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell") as? NoticeCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("NoticeCell", owner: self, options: nil)?.first as? NoticeCell
        }
        cell?.configutaitonData(.contactus, nil)
        return cell!
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ContactUsDetailViewController.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
