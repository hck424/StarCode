//
//  MyPostListViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class MyPostListViewController: BaseViewController {

    @IBOutlet weak var tblView: UITableView!
    var listData:Array<[String:Any]> = []
    var page: Int = 1
    var isPageEnd: Bool = false
    var isRequest: Bool = false
    var perPage = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CNavigationBar.drawBackButton(self, "내 게시글", #selector(actionPopViewCtrl))
        
        let footerview = Bundle.main.loadNibNamed("TableFooterView", owner: self, options: nil)?.first as? TableFooterView
        self.tblView.tableFooterView = footerview
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoginPopupWithCheckSession()
        self.dataRest()
    }
    func dataRest() {
        self.page = 1
        self.isPageEnd = false
        self.requestMyPostList()
    }
    func addData() {
        self.requestMyPostList()
    }
    func requestMyPostList() {
        guard let token = SharedData.instance.token else {
            return
        }
        
        if isPageEnd {
            return
        }
        
        let param:[String:Any] = ["token":token, "page":page, "per_page":perPage]
        
        ApiManager.shared.requestMyPostHistory(param: param) { (response) in
            self.isRequest = false
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

extension MyPostListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MyPostCell") as? MyPostCell
        
        if cell == nil {
            cell = Bundle.main.loadNibNamed("MyPostCell", owner: self, options: nil)?.first as? MyPostCell
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
        let vc = TalkDetailViewController.init()
        vc.data = item
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension MyPostListViewController: UIScrollViewDelegate {
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
