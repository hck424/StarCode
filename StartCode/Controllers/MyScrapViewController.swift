//
//  MyScrapViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class MyScrapViewController: BaseViewController {
    @IBOutlet weak var lbEmpty: UILabel!
    @IBOutlet weak var tblView: UITableView!
    var page = 1
    var perPage = 10
    var isPageEnd = false
    var canRequest = true
    var listData:Array<[String:Any]> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        CNavigationBar.drawBackButton(self, "스크랩", #selector(actionPopViewCtrl))
        let footerView = Bundle.main.loadNibNamed("TableFooterView", owner: self, options: nil)?.first as! TableFooterView
        tblView.tableFooterView = footerView
        self.dataReset()
    }
    
    func dataReset() {
        page = 1
        isPageEnd = false
        canRequest = true
        self.requestScrapList()
    }
    func addData() {
        self.requestScrapList()
    }
    func requestScrapList() {
        guard let token = SharedData.instance.token else {
            return
        }
        if isPageEnd {
            return
        }
        
        let param:[String:Any] = ["token":token, "page":page, "per_page":perPage]
        ApiManager.shared.requestMyScrap(param: param) { (response) in
            self.canRequest = true
            if let response = response, let data = response["data"] as? [String:Any], let list = data["list"] as? Array<[String:Any]> {
                
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
extension MyScrapViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tblView.dequeueReusableCell(withIdentifier: "MyQnaCell") as? MyQnaCell
        
        if cell == nil {
            cell = Bundle.main.loadNibNamed("MyQnaCell", owner: self, options: nil)?.first as? MyQnaCell
        }
        cell?.configurationData(nil, .type1, indexPath.row)
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension MyScrapViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let velocityY = scrollView.panGestureRecognizer.translation(in: scrollView).y
        let offsetY = floor((scrollView.contentOffset.y + scrollView.bounds.height)*100)/100
        let contentH = floor(scrollView.contentSize.height*100)/100
        
        if velocityY < 0 && offsetY > contentH && canRequest == true {
            canRequest = false
            self.addData()
        }
    }

}
