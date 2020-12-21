//
//  ExpertDailyLifeDetailViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/18.
//

import UIKit

class ExpertLifeDetailViewController: BaseViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    var headerView:TalkDetailHeaderView?
    
    var passData:[String:Any]?
    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "전문가 일상", #selector(actionPopViewCtrl))
        
        headerView = Bundle.main.loadNibNamed("TalkDetailHeaderView", owner: self, options: nil)?.first as? TalkDetailHeaderView
        
        tblView.tableHeaderView = headerView!
        
        self.requestExpertDailyLifeDetail()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let header = tblView.tableHeaderView as? TalkDetailHeaderView {
            let conHeight = header.lbContent.sizeThatFits(CGSize(width: header.lbContent.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
            header.heightConetnt.constant = conHeight
            
            header.translatesAutoresizingMaskIntoConstraints = false
            
            let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

            header.translatesAutoresizingMaskIntoConstraints = false
            header.widthAnchor.constraint(equalToConstant: tblView.bounds.width).isActive = true
            header.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    func requestExpertDailyLifeDetail() {
        self.loadViewIfNeeded()
        headerView?.configurationData(nil, completion: {
            self.loadViewIfNeeded()
            self.tblView.reloadData()
        })
        tblView.reloadData()
    }
}

extension ExpertDailyLifeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TalkDetailCell") as? TalkDetailCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("TalkDetailCell", owner: self, options: nil)?.first as? TalkDetailCell
        }
        
//        cell?.configurationData(nil, indexPath.row)
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
