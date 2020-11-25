//
//  ContactUsListViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class ContactUsListViewController: BaseViewController {

    @IBOutlet weak var btnWrtite: CButton!
    @IBOutlet weak var tblView: UITableView!
    
    var listData:Array<[String:Any]> = []
    var page: Int = 1
    var isEndPage: Bool = false
    var isRequest: Bool = false
    var perPage = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "고객센터", #selector(actionPopViewCtrl))
        self.addRightNaviMyChuButton()
      
        let footerView = Bundle.main.loadNibNamed("TableFooterView", owner: nil, options: nil)?.first as! TableFooterView
        footerView.frame = CGRect.init(x: 0, y: 0, width: tblView.bounds.width, height: 200)
        self.tblView.tableFooterView = footerView
        self.dataRest()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoginPopupWithCheckSession()
    }
    func dataRest() {
        self.page = 1
        self.isEndPage = false
        self.requestContactUsList()
    }
    func addData() {
        self.requestContactUsList()
    }
    
    func requestContactUsList() {
        if isEndPage == true {
            return
        }
        guard let token = SharedData.instance.pToken else {
            return
        }
        let param:[String:Any] = ["token":token, "page":page, "per_page":perPage]
        ApiManager.shared.requestContactUsList(param: param) { (response) in
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
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender == btnWrtite {
            let vc = ContactWriteViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ContactUsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell") as? NoticeCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("NoticeCell", owner: self, options: nil)?.first as? NoticeCell
        }
        if let item = listData[indexPath.row] as? [String: Any] {
            cell?.configutaitonData(.contactus, item)
        }
        return cell!
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = listData[indexPath.row] as? [String:Any] else {
            return
        }
        let vc = ContactUsDetailViewController.init()
        vc.data = item
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ContactUsListViewController: UIScrollViewDelegate {
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
