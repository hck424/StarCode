//
//  MyPostListViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class MyPostListViewController: BaseViewController {

    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CNavigationBar.drawBackButton(self, "내 게시글", #selector(actionPopViewCtrl))
        self.addRightNaviMyChuButton()
        
        self.requestMyPostList()
    }
    
    func requestMyPostList() {
        tblView.reloadData {
            
        }
    }
    
}

extension MyPostListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
