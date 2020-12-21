//
//  TalkListViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/13.
//

import UIKit

class TalkListViewController: BaseViewController {
    @IBOutlet weak var btnLike: SelectedButton!
    @IBOutlet weak var btnDesc: SelectedButton!
    @IBOutlet weak var lbEmpty: UILabel!
    @IBOutlet weak var btnCategory: CButton!
    @IBOutlet weak var tfSearch: CTextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnWrite: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lbCategory: UILabel!
    
    var listData:Array<[String:Any]> = []
    var listOriginData:Array<[String:Any]> = []
    var searchTxt:String?
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
    var fIndex = "post_like" //실시간 인기, "desc"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "커뮤니티", false, nil)
        
        let footerView = Bundle.main.loadNibNamed("TableFooterView", owner: nil, options: nil)?.first as! UIView
        tblView.tableFooterView = footerView
        tblView.estimatedRowHeight = 70
        tblView.rowHeight = UITableView.automaticDimension
        
        tfSearch.inputAccessoryView = accoryView
        accoryView.addTarget(self, selctor: #selector(actionKeybardDown))
        
        self.selCategory = SharedData.instance.categorys[5]
        btnLike.isSelected = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardNotification()
        self.dataReset()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotification()
    }
    
    func dataReset() {
        self.page = 1
        self.isPageEnd = false
        self.isRequest = false
        self.requestCommunityList()
    }
    func addData() {
        self.requestCommunityList()
    }
    
    func requestCommunityList() {
        if isPageEnd == true {
            return
        }
        guard let token = SharedData.instance.token else {
            return
        }
        
        var param:[String:Any] = ["token":token, "page":page, "per_page":perPage, "findex":fIndex]
        
        if let selCategory = selCategory, selCategory.isEmpty == false, selCategory != "전체" {
            param["category_id"] = selCategory
        }
        if let searchTxt = searchTxt, searchTxt.isEmpty == false {
            param["skeyword"] = searchTxt
        }
        
        ApiManager.shared.requestTalkList(param: param) { (response) in
            self.isRequest = false
            if let response = response, let data = response["data"] as? [String:Any], let list = data["list"] as? [[String:Any]] {
                
                if list.isEmpty == true {
                    self.isPageEnd = true
                }
                
                if self.page == 1 {
                    self.listOriginData = list
                }
                else {
                    self.listOriginData.append(contentsOf: list)
                }
                self.listData.removeAll()
                self.listData = self.listOriginData
                
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
    
    @IBAction func textFieldEdtingChanged(_ sender: UITextField) {
        self.searchTxt = sender.text
        if searchTxt?.isEmpty == false {
            var tmpArr:[[String:Any]] = []
            for item in listOriginData {
                if let post_title = item["post_title"] as? String, post_title.contains(searchTxt!) == true {
                    tmpArr.append(item)
                }
            }
            
            if tmpArr.isEmpty == false {
                self.listData = tmpArr
            }
        }
        else {
            self.listData = listOriginData
        }
        
        self.tblView.reloadData()
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender == btnLike {
            btnLike.isSelected = true
            btnDesc.isSelected = false
            
            tfSearch.text = nil
            searchTxt = nil
            fIndex = "post_like"
            self.dataReset()
        }
        else if sender == btnDesc {
            btnLike.isSelected = false
            btnDesc.isSelected = true
            
            tfSearch.text = nil
            searchTxt = nil
            fIndex = "desc"
            self.dataReset()
        }
        else if sender == btnSearch {
            self.view.endEditing(true)
            self.dataReset()
        }
        else if sender == btnCategory {
            self.view.endEditing(true)
            let vc = PopupViewController.init(type: .list, data: SharedData.instance.categorys) { (vcs, selItem, index) in
                vcs.dismiss(animated: false, completion: nil)
                guard let selItem = selItem as? String else {
                    return
                }
                self.tfSearch.text = nil
                self.searchTxt = nil
                self.selCategory = selItem
                self.dataReset()
            }
            self.present(vc, animated: false, completion: nil)
        }
        else if sender == btnWrite {
            let vc = TalkWriteViewController.init()
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
extension TalkListViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tblView.dequeueReusableCell(withIdentifier: "TalkCell") as? TalkCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("TalkCell", owner: self, options: nil)?.first as? TalkCell
        }
        cell?.configurationData(listData[indexPath.row])
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblView.deselectRow(at: indexPath, animated: true)
        
        let vc = TalkDetailViewController.init()
        vc.data = listData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated:true)
    }
}
extension TalkListViewController: UIScrollViewDelegate {
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
extension TalkListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTxt = textField.text;
        self.dataReset()
        return true
    }
}
extension TalkListViewController: TalkWriteViewControllerDelegate {
    func didfinishTalkWriteCompletion(category: String) {
        self.selCategory = category
        lbCategory.text = self.selCategory!
    }
}
