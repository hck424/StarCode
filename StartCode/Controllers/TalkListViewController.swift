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
    
    
    var listData:Array<[String:Any]> = []
    var listOriginData:Array<[String:Any]> = []
    var searchTxt:String?
    let accoryView = CToolbar.init(barItems: [.keyboardDown])
    var arrCategory:Array<[String:Any]> = Array<[String:Any]>()
    var selCategory:[String:Any]? {
        didSet {
            if let bca_value = selCategory?["bca_value"] as? String {
                if let lbCategory = btnCategory.viewWithTag(100) as? UILabel {
                    lbCategory.text = bca_value
                }
            }
        }
    }
    
    var page = 1
    var totalPage = NSInteger.max
    let perPage = 10
    var fIndex = "post_like" //실시간 인기, "desc"
    var isRequest = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "커뮤니티", false, nil)
        CNavigationBar.drawRight(self, "12,00", UIImage(named: "ic_chu"), 999, #selector(actionShowChuVc))
        
        let footerView = Bundle.main.loadNibNamed("TableFooterView", owner: nil, options: nil)?.first as! UIView
        tblView.tableFooterView = footerView
        tblView.estimatedRowHeight = 70
        tblView.rowHeight = UITableView.automaticDimension
        
        tfSearch.inputAccessoryView = accoryView
        accoryView.addTarget(self, selctor: #selector(onClickedBtnActions(_:)))
        self.requestCategoryList()
        
        btnLike.sendActions(for: .touchUpInside)
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
    
    func requestCategoryList() {
        guard let token = SharedData.instance.pToken else {
            return
        }
        let param:[String:Any] = ["token":token]
        ApiManager.shared.requestTalkCategory(param: param) { (response) in
            if let response = response, let category = response["category"] as? Array<Any> {
                self.arrCategory = category.first as! Array<[String : Any]>
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
    func dataReset() {
        self.page = 1
        self.totalPage = NSInteger.max
        self.tblView.setContentOffset(CGPoint.zero, animated: false)
        self.requestCommunityList()
    }
    func addData() {
        self.requestCommunityList()
    }
    
    func requestCommunityList() {
        if page >= totalPage {
            return
        }
        var param:[String:Any] = ["page":page, "per_page":perPage, "findex":fIndex]
        if let token = SharedData.instance.pToken {
            param["token"] = token
        }
//        if let selCategory = selCategory, let bca_id = selCategory["bca_id"] as? Int {
//            param["category_id"] = bca_id
//        }
        if let skeyword = searchTxt, skeyword.isEmpty == false {
            param["skeyword"] = skeyword
        }
        
        ApiManager.shared.requestTalkList(param: param) { (response) in
            self.isRequest = false
            if let response = response, let data = response["data"] as? [String:Any] {
                if let list = data["list"] as? Array<[String:Any]> {
                    if self.page == 1 {
                        self.listOriginData = list
                    }
                    else {
                        self.listOriginData.append(contentsOf: list)
                    }
                }
                
                if let total_rows = data["total_rows"] as? String {
                    let rows:Int = Int(total_rows)!
                    if (rows%self.perPage) == 0 {
                        self.totalPage = Int(rows/self.perPage)
                    }
                    else {
                        self.totalPage = Int(rows/self.perPage) + 1
                    }
                }
                else if let total_rows = data["total_rows"] as? Int {
                    let rows:Int = total_rows
                    if (rows%self.perPage) == 0 {
                        self.totalPage = Int(rows/self.perPage)
                    }
                    else {
                        self.totalPage = Int(rows/self.perPage) + 1
                    }
                }
                
                self.listData.removeAll()
                self.listData = self.listOriginData
                if self.listData.isEmpty == false {
                    self.tblView.isHidden = false
                }
                else {
                    self.tblView.isHidden = true
                }
                self.page += 1
                self.tblView.reloadData()
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
    
    @IBAction func textFieldEdtingChanged(_ sender: UITextField) {
        self.searchTxt = sender.text
        listData.removeAll()
        if searchTxt?.isEmpty == false {
            var tmpArr:Array<[String:Any]> = []
            for item in listOriginData {
                var result = ""
                if let post_title = item["post_title"] as? String {
                    result.append(post_title)
                }
                if let post_category = item["post_category"] as? String {
                    result.append(post_category)
                }
                
                if result.contains(searchTxt!) {
                    tmpArr.append(item)
                }
            }
            
            if tmpArr.isEmpty == false {
                listData = tmpArr
            }
        }
        else {
            listData = listOriginData
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
            let vc = PopupViewController.init(type: .list, data: arrCategory, keys: ["bca_value"])
            vc.didSelectRowAtItem = {(vcs, selData, index) -> Void in
                vcs.dismiss(animated: false, completion: nil)
                guard let selData = selData as? [String:Any] else {
                    return
                }
                self.selCategory = selData
                self.dataReset()
            }
            self.present(vc, animated: false, completion: nil)
        }
        else if sender == btnWrite {
            let vc = TalkWriteViewController.init()
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
        
        if let item = listData[indexPath.row] as? [String:Any] {
            cell?.configurationData(item)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblView.deselectRow(at: indexPath, animated: true)
        
        let vc = TalkDetailViewController.init()
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
