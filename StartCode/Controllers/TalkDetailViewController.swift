//
//  TalkDetailViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/17.
//

import UIKit

class TalkDetailViewController: BaseViewController {
    var passData:[String:Any]?
    var headerView:TalkDetailHeaderView?
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CNavigationBar.drawBackButton(self, "커뮤니티", #selector(actionPopViewCtrl))
        CNavigationBar.drawRight(self, "12,00", UIImage(named: "ic_chu"), 999, #selector(actionShowChuVc))
        headerView = Bundle.main.loadNibNamed("TalkDetailHeaderView", owner: self, options: nil)?.first as? TalkDetailHeaderView
        
        self.tblView.tableHeaderView = headerView!
        
        self.requestTalkDetail()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let header = tblView.tableHeaderView as? TalkDetailHeaderView {
            
            let conHeight = header.lbContent.sizeThatFits(CGSize(width: header.lbContent.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
            header.heightConetnt.constant = conHeight
            
            
            let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            
            header.translatesAutoresizingMaskIntoConstraints = false
            header.widthAnchor.constraint(equalToConstant: tblView.bounds.width).isActive = true
            header.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func requestTalkDetail() {
        headerView?.configurationData(nil)
        self.tblView.reloadData {
            
        }
    }
}

extension TalkDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TalkDetailCell") as? TalkDetailCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("TalkDetailCell", owner: self, options: nil)?.first as? TalkDetailCell
        }
        
        cell?.configurationData(nil, indexPath.row)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
