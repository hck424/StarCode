//
//  ConfigurationViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class ConfigurationViewController: BaseViewController {

    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        CNavigationBar.drawBackButton(self, "환경 설정", #selector(actionPopViewCtrl))
        
        let footerView = Bundle.main.loadNibNamed("TableFooterView", owner: self, options: nil)?.first as! TableFooterView
        self.tblView.tableFooterView = footerView
        
        tblView.reloadData()
    }
    
}
extension ConfigurationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ConfiguraitonCell") as? ConfiguraitonCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("ConfiguraitonCell", owner: self, options: nil)?.first as? ConfiguraitonCell
        }
        
        if indexPath.row == 0 {
            cell?.btnToggle.isHidden = false
            cell?.lbTitle.text = "알림 설정"
        }
        else if indexPath.row == 1 {
            cell?.btnToggle.isHidden = true
            
//            let buildVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
            if let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
                cell?.lbTitle.text = "현재버전: \(appVersion)"
            }
            else {
                cell?.lbTitle.text = "현재버전: "
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
