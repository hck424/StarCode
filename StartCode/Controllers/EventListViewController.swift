//
//  EventListViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class EventListViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    var listData:Array<[String:Any]> = []
    var page: Int = 1
    var isEndPage: Bool = false
    var isRequest: Bool = false
    var perPage = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "이벤트", #selector(actionPopViewCtrl))
        self.addRightNaviMyChuButton()
        
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
        self.requestEventList()
    }
    func addData() {
        self.requestEventList()
    }
    
    func requestEventList() {
        if isEndPage == true {
            return
        }
        let param:[String:Any] = ["akey":akey, "page":page, "per_page":perPage]
        ApiManager.shared.requestEventList(param: param) { (response) in
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
                
                self.tblView.reloadData {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                        self.tblView.reloadData()
                    }
                }
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

extension EventListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as? EventCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("EventCell", owner: self, options: nil)?.first as? EventCell
        }
        if let item = listData[indexPath.row] as? [String:Any] {
            cell?.configurationData(item)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = listData[indexPath.row] as? [String:Any] else {
            return
        }
        let vc = EventDetailViewController.init()
        vc.data = item
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension EventListViewController: UIScrollViewDelegate {
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
