//
//  MyQnaViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class MyQnaViewController: BaseViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var arrTabBtn: [SelectedButton]!
    
    var selBtn:SelectedButton?
    let arrCategory:[String] = ["1:1", "ai", "메이크업진단", "뷰티질문"]
    var selCagegory:String = "1:1"
    
    var listData:Array<[String:Any]> = []
    var page: Int = 1
    var isPageEnd: Bool = false
    var isRequest: Bool = false
    var perPage = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CNavigationBar.drawBackButton(self, "나의 문의 내역", #selector(actionPopViewCtrl))
        self.addRightNaviMyChuButton()
        
        arrTabBtn = arrTabBtn.sorted(by: { (btn1, btn2) -> Bool in
            btn2.tag > btn1.tag
        })
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
        guard let token = SharedData.instance.pToken else {
            return
        }
        if isPageEnd == true {
            return
        }
        
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

extension MyQnaViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MyQnaCell") as? MyQnaCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("MyQnaCell", owner: self, options: nil)?.first as? MyQnaCell
        }
        
        
        if let selBtn = selBtn, let item = listData[indexPath.row] as? [String:Any] {
            if selBtn.tag == 1 || selBtn.tag == 2 {
                cell?.configurationData(item, .type1, indexPath.row)
            }
            else {
                cell?.configurationData(item, .type2, indexPath.row)
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = listData[indexPath.row] as? [String:Any] else {
            return
        }
        ///TODO:: 나의 질문내역 페이지 상세 
    }
}
extension MyQnaViewController: UIScrollViewDelegate {
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
