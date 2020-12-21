//
//  NoticeListViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class NoticeListViewController: BaseViewController {
    
    @IBOutlet weak var tblView: UITableView!
    var listData:Array<[String:Any]> = []
    var page: Int = 1
    var isEndPage: Bool = false
    var isRequest: Bool = false
    var perPage = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CNavigationBar.drawBackButton(self, "공지사항", #selector(actionPopViewCtrl))
        
        let footerView = Bundle.main.loadNibNamed("TableFooterView", owner: nil, options: nil)?.first as! TableFooterView
        
        self.tblView.tableFooterView = footerView
        self.dataRest()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func dataRest() {
        self.page = 1
        self.isEndPage = false
        self.requestNoticeList()
    }
    func addData() {
        self.requestNoticeList()
    }
    func requestNoticeList() {
        if isEndPage == true {
            return
        }
        let param:[String:Any] = ["akey":akey, "page":page, "per_page":perPage]
        ApiManager.shared.requestNoticeList(param: param) { (response) in
            self.isRequest = false
            if let response = response, let data = response["data"] as?[String:Any], let list = data["list"] as?Array<[String:Any]> {
                
                if list.count == 0 {
                    self.isEndPage = true
                }
                
                if self.page == 1 {
                    self.listData = list
                }
                else {
                    self.listData.append(contentsOf: list)
                }
                
                if self.listData.isEmpty == true {
                    self.tblView.isHidden = true
                }
                else {
                    self.tblView.isHidden = false
                }
                self.tblView.reloadData()
                self.page += 1
            }
            else {
                self.showErrorAlertView(response)
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }

    }
}

extension NoticeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell") as? NoticeCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("NoticeCell", owner: self, options: nil)?.first as? NoticeCell
        }
        if let item = listData[indexPath.row] as? [String:Any] {
            cell?.configutaitonData(.notice, item)
        }
        return cell!
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = listData[indexPath.row] as? [String:Any] else {
            return
        }
        let vc = NoticeDetailViewController.init()
        vc.data = item
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NoticeListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let velocityY = scrollView.panGestureRecognizer.translation(in: scrollView).y
        let offsetY = floor((scrollView.contentOffset.y + scrollView.bounds.height)*100)/100
        let contentH = floor(scrollView.contentSize.height*100)/100
        
        if velocityY < 0 && offsetY > contentH && isRequest == false {
            isRequest = true
            self.addData()
        }
    }
}
