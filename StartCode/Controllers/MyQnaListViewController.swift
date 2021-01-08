//
//  MyQnaListViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class MyQnaListViewController: BaseViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var arrTabBtn: [SelectedButton]!
    
    var selBtn:SelectedButton?
    
    var arrCategory:[String] = ["1:1", "ai", "메이크업진단", "뷰티질문"]
    var selCagegory:String = "1:1"
    
    var listData:Array<[String:Any]> = []
    var page: Int = 1
    var isPageEnd: Bool = false
    var isRequest: Bool = false
    var perPage = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if appType == .user {
            CNavigationBar.drawBackButton(self, "나의 문의 내역", #selector(actionPopViewCtrl))
        }
        else {
            CNavigationBar.drawBackButton(self, "질문 내역", #selector(actionPopViewCtrl))
            arrTabBtn[1].isHidden = true
        }
        for btn in arrTabBtn {
            btn.addTarget(self, action: #selector(onClickedBtnActions(_ :)), for: .touchUpInside)
        }
        let footerView = Bundle.main.loadNibNamed("TableFooterView", owner: nil, options: nil)?.first as! TableFooterView
        self.tblView.tableFooterView = footerView
        
        let btn = arrTabBtn.first
        btn?.sendActions(for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoginPopupWithCheckSession()
    }
    func dataRest() {
        self.tblView.setContentOffset(CGPoint.zero, animated: false)
        self.page = 1
        self.isPageEnd = false
        self.requestQnaList()
    }
    func addData() {
        self.requestQnaList()
    }
    func requestQnaList() {
        guard let token = SharedData.instance.token else {
            return
        }
        if isPageEnd == true {
            return
        }
        
        if appType == .user {
            let param:[String:Any] = ["token":token, "page":page, "category_id":selCagegory, "per_page":perPage]
            ApiManager.shared.requestMyQnaList(param: param) { (response) in
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
        else {
            let param:[String:Any] = ["token":token, "page":page, "category_id":selCagegory, "per_page":perPage]
            ApiManager.shared.requestAskList(param: param) { (response) in
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
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if let sender = sender as? SelectedButton {
            for btn in arrTabBtn {
                btn.isSelected = false
            }
            scrollView.scrollRectToVisible(sender.frame, animated: true)
            sender.isSelected = true
            
            if sender.tag == 1 {
                self.selCagegory = arrCategory[0]
                dataRest()
            }
            else if sender.tag == 2 {
                self.selCagegory = arrCategory[1]
                dataRest()
            }
            else if sender.tag == 3 {
                self.selCagegory = arrCategory[2]
                dataRest()
            }
            else if sender.tag == 4 {
                self.selCagegory = arrCategory[3]
                dataRest()
            }
            self.selBtn = sender
        }
    }
}

extension MyQnaListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MyQnaCell") as? MyQnaCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("MyQnaCell", owner: self, options: nil)?.first as? MyQnaCell
        }
        
        if let selBtn = selBtn, let item = listData[indexPath.row] as? [String:Any] {
            if selBtn.tag == 1 {
                cell?.configurationData(item, .type1, indexPath.row)
            }
            else if selBtn.tag == 2 {
                cell?.configurationData(item, .type2, indexPath.row)
            }
            else {
                cell?.configurationData(item, .type3, indexPath.row)
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = listData[indexPath.row] as? [String:Any] else {
            return
        }
        let vc = MyQnaDetailViewController.init()
        vc.data = item
        if selBtn?.tag == 1 {
            vc.type = .oneToQna
        }
        else if selBtn?.tag == 2 {
            vc.type = .aiQna
        }
        else if selBtn?.tag == 3 {
            vc.type = .makeupQna
        }
        else if selBtn?.tag == 4 {
            vc.type = .beautyQna
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension MyQnaListViewController: UIScrollViewDelegate {
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
