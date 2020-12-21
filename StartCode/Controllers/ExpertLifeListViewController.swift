//
//  ExpertLifeListViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/18.
//

import UIKit

class ExpertLifeListViewController: BaseViewController {
    @IBOutlet weak var btnCategory: CButton!
    @IBOutlet weak var tfSearch: CTextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lbEmpty: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    
    var searchTxt:String?
    var listData:[[String:Any]] = []
    var orignListData:[[String:Any]] = []
    
    var page: Int = 1
    var isPageEnd: Bool = false
    var isRequest: Bool = false
    var perPage = 10
    
    let accoryView = CToolbar.init(barItems: [.keyboardDown])
    var selCategory:String? {
        didSet {
            lbCategory.text = selCategory!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CNavigationBar.drawBackButton(self, "전문가 일상", #selector(actionPopViewCtrl))
        
        let footerView = Bundle.main.loadNibNamed("TableFooterView", owner: nil, options: nil)?.first as! TableFooterView
        self.tblView.tableFooterView = footerView
        
        tfSearch.inputAccessoryView = accoryView
        accoryView.addTarget(self, selctor: #selector(actionKeybardDown))
//        self.selCategory = SharedData.instance.categorys[5]
        self.dataReset()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardNotification()
        self.showLoginPopupWithCheckSession()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotification()
    }
    
    @IBAction func textFieldEdtingChanged(_ sender: UITextField) {
        self.searchTxt = sender.text
        if searchTxt?.isEmpty == false {
            var tmpArr:[[String:Any]] = []
            for item in orignListData {
                if let post_title = item["post_title"] as? String, post_title.contains(searchTxt!) == true {
                    tmpArr.append(item)
                }
            }
            
            if tmpArr.isEmpty == false {
                self.listData = tmpArr
            }
        }
        else {
            self.listData = orignListData
        }
        self.tblView.reloadData()
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender == btnCategory {
            self.view.endEditing(true)
            let vc = PopupViewController.init(type: .list, data: SharedData.instance.categorys, completion: { (vcs, selItem, index) in
                vcs.dismiss(animated: false, completion: nil)
                guard let selItem = selItem as? String else {
                    return
                }
                self.tfSearch.text = nil
                self.searchTxt = nil
                self.selCategory = selItem
                self.dataReset()
            })
            self.present(vc, animated: false, completion: nil)
        }
        else if sender == btnSearch {
            guard let search = searchTxt, search.isEmpty == false else {
                return
            }
            self.dataReset()
        }
    }
    
    func dataReset() {
        self.page = 1
        self.isPageEnd = false
        self.isRequest = false
        self.requestExpertLifeList()
    }
    func addData() {
        self.requestExpertLifeList()
    }
    
    func requestExpertLifeList() {
        guard let token = SharedData.instance.token else {
            return
        }
        if isPageEnd == true {
            return
        }
        var param:[String:Any] = ["token":token, "page":page, "per_page":perPage]
        
        if let selCategory = selCategory, selCategory.isEmpty == false, selCategory != "전체" {
            param["category_id"] = selCategory
        }
        if let searchTxt = searchTxt, searchTxt.isEmpty == false {
            param["skeyword"] = searchTxt
        }
        
        ApiManager.shared.requestExpertLifeList(param: param) { (response) in
            if let response = response, let data = response["data"] as? [String:Any], let list = data["list"] as? [[String:Any]] {
                
                if list.isEmpty == true {
                    self.isPageEnd = true
                }
                
                if self.page == 1 {
                    self.orignListData = list
                }
                else {
                    self.orignListData.append(contentsOf: list)
                }
                self.listData.removeAll()
                self.listData = self.orignListData
                
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

extension ExpertLifeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ExpertDailyLifeCell") as? ExpertDailyLifeCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("ExpertDailyLifeCell", owner: self, options: nil)?.first as? ExpertDailyLifeCell
        }
        cell?.configurationData(listData[indexPath.row])
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblView.deselectRow(at: indexPath, animated: true)
        let vc = TalkDetailViewController.init()
        vc.data = listData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated:true)
//        let vc = ExpertLifeDetailViewController.init()
//        vc.passData = listData[indexPath.row]
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension ExpertLifeListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.searchTxt = textField.text
        self.dataReset()
        self.view.endEditing(true)
        return true
    }
}
extension ExpertLifeListViewController: UIScrollViewDelegate {
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
