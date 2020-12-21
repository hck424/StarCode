//
//  ChuHistoryViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class ChuHistoryViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    var listData:Array<[String:Any]> = []
    var page: Int = 1
    var isPageEnd: Bool = false
    var isRequest: Bool = false
    var perPage = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "CHU 사용내역", #selector(actionPopViewCtrl))
        let footerView = Bundle.main.loadNibNamed("TableFooterView", owner: self, options: nil)?.first as! TableFooterView
        tblView.tableFooterView = footerView
        self.dataRest()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoginPopupWithCheckSession()
    }
    
    func dataRest() {
        self.page = 1
        self.isPageEnd = false
        self.requestMyChuHistory()
    }
    func addData() {
        self.requestMyChuHistory()
    }
    func requestMyChuHistory() {
        guard let token = SharedData.instance.token else {
            return
        }
        
        if isPageEnd {
            return
        }
        let param:[String:Any] = ["token":token, "page":page, "per_page":perPage]
        
        ApiManager.shared.requestMyChuHistory(param: param) { (response) in
            if let response = response, let data = response["data"] as?[String:Any], let list = data["list"] as?Array<[String:Any]> {
                
                if list.count == 0 {
                    self.isPageEnd = true
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
extension ChuHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ChuHistoryCell") as? ChuHistoryCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("ChuHistoryCell", owner: self, options: nil)?.first as? ChuHistoryCell
        }
        if let item = listData[indexPath.row] as? [String:Any] {
            cell?.configurationData(item)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension ChuHistoryViewController: UIScrollViewDelegate {
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
