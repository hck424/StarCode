//
//  EventListViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class EventListViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "이벤트", #selector(actionPopViewCtrl))
        self.addRightNaviMyChuButton()
        
        self.requestEventList()
    }
    
    func requestEventList() {
        tblView.reloadData()
    }
}

extension EventListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as? EventCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("EventCell", owner: self, options: nil)?.first as? EventCell
        }
            
        cell?.configurationData(nil)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let vc = EventDetailViewController.init()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
