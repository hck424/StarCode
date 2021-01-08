//
//  ExAnswerListViewController.swift
//  StartCodePro
//
//  Created by 김학철 on 2020/12/21.
//

import UIKit

class ExAnswerListViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    var listData:Array<[String:Any]> = []
    var page: Int = 1
    var perPage = 10
    var isPageEnd: Bool = false
    var canRequest: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tmpStr = "(1:1 질문)"
        let result = String(format: "내게 주어진 질문 %@", tmpStr)
        let attr = NSMutableAttributedString.init(string: result)
        attr.addAttribute(.foregroundColor, value: RGB(155, 155, 155), range: ((result as NSString).range(of: tmpStr)))
        CNavigationBar.drawBackButton(self, attr, false, #selector(actionPopViewCtrl))
        
        let footerView = Bundle.main.loadNibNamed("TableFooterView", owner: self, options: nil)?.first as! TableFooterView
        self.tblView.tableFooterView = footerView

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoginPopupWithCheckSession()
        self.dataRest()
    }
    
    func dataRest() {
        canRequest = true
        page = 1
        isPageEnd = false
        self.requestMyAnswerList()
        self.tblView.setContentOffset(CGPoint.zero, animated: false)
    }
    func addData() {
        self.requestMyAnswerList()
    }
    
    func requestMyAnswerList() {
        guard let token = SharedData.instance.token else {
            return
        }
        if isPageEnd == true {
            return
        }
        
        var category_id = "1:1"
        
        let param:[String:Any] = ["page":page, "per_page":perPage, "token":token, "category_id": category_id]
        ApiManager.shared.requestAskList(param: param) { (response) in
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

extension ExAnswerListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell") as? AnswerCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("AnswerCell", owner: self, options: nil)?.first as? AnswerCell
        }
        cell?.seperatorBottom.isHidden = true
        if  let item = listData[indexPath.row] as? [String:Any] {
            cell?.configuraitonData(item)
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let item = listData[indexPath.row] as? [String:Any], let token = SharedData.instance.token, let post_id = item["post_id"] else {
            return
        }
        
        let param = ["token":token, "post_id":post_id]
        ApiManager.shared.requestAnswerOpenCheck(param) { (response) in
            if let response = response, let code = response["code"] as? NSNumber, code.intValue == 200 {
                if let mem_chu = response["mem_chu"] as? NSNumber {
                    SharedData.setObjectForKey("\(mem_chu)", kMemChu)
                    SharedData.instance.memChu = "\(mem_chu)"
                    self.updateChuNaviBarItem()
                }
                
                let vc = ExOneToQnaDetailViewController.init()
                vc.data = item
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                self.showErrorAlertView(response)
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
}

extension ExAnswerListViewController: UIScrollViewDelegate {
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
