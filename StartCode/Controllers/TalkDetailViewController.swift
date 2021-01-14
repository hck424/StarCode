//
//  TalkDetailViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/17.
//

import UIKit

class TalkDetailViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnComent: CButton!
    
    var data:[String:Any] = [:]
    var headerView:TalkDetailHeaderView?
    var listData:[[String:Any]] = []
    var heightHeaderView: NSLayoutConstraint?
    var selComment:[String:Any]?
    var postId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var title = "커뮤니티"
        if let post_nickname = data["post_nickname"] as? String {
            title = post_nickname
        }
        
        CNavigationBar.drawBackButton(self, title, #selector(actionPopViewCtrl))
        
        headerView = Bundle.main.loadNibNamed("TalkDetailHeaderView", owner: self, options: nil)?.first as? TalkDetailHeaderView
        self.tblView.tableHeaderView = headerView!
        let footerView = Bundle.main.loadNibNamed("TableFooterView", owner: nil, options: nil)?.first as! TableFooterView
        self.tblView.tableFooterView = footerView
        self.requestTalkDetail()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.headerUpdateLayout()
    }
    
    func headerUpdateLayout() {
        headerView?.translatesAutoresizingMaskIntoConstraints = false

        if let header = tblView.tableHeaderView as? TalkDetailHeaderView {
            if heightHeaderView != nil {
                header.removeConstraint(heightHeaderView!)
            }
            let conHeight = header.lbContent.sizeThatFits(CGSize(width: header.lbContent.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
            header.heightConetnt.constant = conHeight
            
            let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            
            header.translatesAutoresizingMaskIntoConstraints = false
            header.widthAnchor.constraint(equalToConstant: tblView.bounds.width).isActive = true
            self.heightHeaderView = header.heightAnchor.constraint(equalToConstant: height)
            self.heightHeaderView?.priority = UILayoutPriority(900)
            self.heightHeaderView?.isActive = true
        }
    }
    func requestTalkDetail() {
        guard let token = SharedData.instance.token, let data = data as?[String:Any], let post_id = data["post_id"] as? String  else {
            return
        }
        let param = ["token": token, "post_id":post_id]
        self.postId = post_id
        ApiManager.shared.requestTalkDetail(param: param) { (response) in
            if let response = response, let data = response["data"] as? [String:Any] {
                self.data = data
                self.decorationUi()
            }
            else {
                self.showErrorAlertView(response)
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
    
    func decorationUi() {
        if let comment = data["comment"] as? [String:Any], let list = comment["list"] as? Array<[String:Any]> {
            listData = list
        }
        
        self.headerView?.configurationData(data, completion: {
            self.headerUpdateLayout()
            self.view.layoutIfNeeded()
        })
        self.view.layoutIfNeeded()
        self.tblView.reloadData()
        
        self.headerView?.didClickedActionClosure = { (action) -> Void in
            guard let token = SharedData.instance.token, self.postId.isEmpty == false else {
                return
            }
            if action == .modify {
                let vc = TalkWriteViewController.init()
                vc.type = .modify
                vc.delegate = self
                vc.data = self.data
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if action == .delete {
                let vc = PopupViewController.init(type: .alert, title: nil, message: "게시글을 삭제하시겠습니까?") { (vcs, selItem, index) in
                    vcs.dismiss(animated: false, completion: nil)
                    if index == 1 {
                        let param:[String:Any] = ["token":token, "post_id":self.postId]
                        ApiManager.shared.requestDeletePost(param: param) { (response) in
                            if let response = response, let message = response["message"] as? String, let code = response["code"] as? Int, code == 200 {
                                self.showToast(message)
                                self.navigationController?.popViewController(animated: true)
                            }
                            else {
                                self.showErrorAlertView(response)
                            }
                        } failure: { (error) in
                            self.showErrorAlertView(error)
                        }
                    }
                }
                vc.addAction(.cancel, "취소")
                vc.addAction(.ok, "삭제")
                self.present(vc, animated: false, completion: nil)
                
            }
            else if action == .scrap {
                let param:[String:Any] = ["token":token, "post_id":self.postId]
                ApiManager.shared.requestPostScrap(param: param) { (response) in
                    if let response = response, let message = response["message"] as? String, let code = response["code"] as? Int, code == 200 {
                        self.showToast(message)
                        if var scrap = self.data["scrap_count"] as? Int {
                            scrap += 1
                            self.data["scrap_count"] = scrap
                            self.decorationUi()
                        }
                    }
                    else {
                        self.showErrorAlertView(response)
                    }
                } failure: { (error) in
                    self.showErrorAlertView(error)
                }
            }
            else if action == .warning {
                let param:[String:Any] = ["token":token, "post_id":self.postId]
                ApiManager.shared.requestPostWarning(param: param) { (response) in
                    if let response = response, let message = response["message"] as? String, let code = response["code"] as? Int, code == 200 {
                        self.showToast(message)
                       
                        if let blame = self.data["post_blame"] as? String, var intBlame = Int(blame) {
                            intBlame += 1
                            self.data["post_blame"] = "\(intBlame)"
                            self.decorationUi()
                        }
                    }
                    else {
                        self.showErrorAlertView(response)
                    }
                } failure: { (error) in
                    self.showErrorAlertView(error)
                }
            }
            else if action == .like {
                let param:[String:Any] = ["token":token, "post_id":self.postId, "like_type":1]
                ApiManager.shared.requestPostRecomend(param: param) { (response) in
                    if let response = response, let message = response["message"] as? String , let code = response["code"] as? Int, code == 200 {
                        self.showToast(message)
                       
                        if let like = self.data["post_like"] as? String, var intLike = Int(like) {
                            intLike += 1
                            self.data["post_like"] = "\(intLike)"
                            self.decorationUi()
                        }
                    }
                    else {
                        self.showErrorAlertView(response)
                    }
                } failure: { (error) in
                    self.showErrorAlertView(error)
                }
            }
            
        }
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender == btnComent {
            let vc = WritePopupViewController.init(.comentWrite) { (vcs, content, images, actionIdx) in
                vcs.dismiss(animated: true, completion: nil)
                guard let content = content else {
                    return
                }
                
                self.requestWriteComent(content, images, nil)
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func requestWriteComent(_ content:String, _ images:[UIImage]?, _ cmtId:String?) {
        guard let token = SharedData.instance.token else {
            return
        }
        var param:[String:Any] = ["token":token, "post_id":postId, "cmt_content":content, "mode":"c"]
        if let images = images {
            param["post_file"] = images
        }
        if let cmtId = cmtId {
            param["cmt_id"] = cmtId
        }
        
        ApiManager.shared.requestCommentWrite(param: param) { (response) in
            if let response = response, let code = response["code"] as? NSNumber, code.intValue == 200 {
                self.requestTalkDetail()
            }
            else {
                self.showErrorAlertView(response)
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
}

extension TalkDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TalkDetailCell") as? TalkDetailCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("TalkDetailCell", owner: self, options: nil)?.first as? TalkDetailCell
        }
        
        if let item = listData[indexPath.row] as? [String:Any] {
            cell?.configurationData(item)
            
            cell?.didActionClosure = {(selData, action) ->Void in
                
                guard let selData = selData, let token = SharedData.instance.token, let cmt_id = selData["cmt_id"] as? String else {
                    return
                }
                
                if action == .modify {
                    
                }
                else if action == .delete {
                    let param:[String:Any] = ["cmt_id":cmt_id, "token":token]
                    ApiManager.shared.requestDeleteComment(param: param) { (response) in
                        if let response = response, let message = response["message"] as? String, let code = response["code"] as? NSNumber, code.intValue == 200 {
                            self.showToast(message)
                            self.requestTalkDetail()
                        }
                        else {
                            self.showErrorAlertView(response)
                        }
                    } failure: { (error) in
                        self.showErrorAlertView(error)
                    }
                }
                else if action == .warning {
                    let param:[String:Any] = ["cmt_id":cmt_id, "token":token]
                    ApiManager.shared.requestPostCommentWarning(param: param) { (response) in
                        if let response = response, let message = response["message"] as? String, let code = response["code"] as? NSNumber, code.intValue == 200 {
                            self.showToast(message)
                            self.requestTalkDetail()
                        }
                        else {
                            self.showErrorAlertView(response)
                        }
                    } failure: { (error) in
                        self.showErrorAlertView(error)
                    }
                }
                else if action == .like {
                    let param:[String:Any] = ["token":token, "cmt_id":cmt_id ,"like_type":1]
                    ApiManager.shared.requestCommentRecomend(param: param) { (response) in
                        if let response = response, let message = response["message"] as? String {
                            self.showToast(message)
                            self.requestTalkDetail()
                        }
                        else {
                            self.showErrorAlertView(response)
                        }
                    } failure: { (error) in
                        self.showErrorAlertView(error)
                    }
                }
                else if action == .comment {
                    let vc = WritePopupViewController.init(.comentWrite) { (vcs, content, images, index) in
                        vcs.dismiss(animated: false, completion: nil)
                        guard let content = content else {
                            return
                        }
                        self.requestWriteComent(content, images, cmt_id)
                    }
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension TalkDetailViewController: TalkWriteViewControllerDelegate {
    func didfinishTalkWriteCompletion(category:String) {
        self.requestTalkDetail()
    }
}
