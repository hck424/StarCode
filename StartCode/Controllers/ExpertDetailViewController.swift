//
//  ExpertDetailViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/18.
//

import UIKit

class ExpertDetailViewController: BaseViewController {
//header oulet
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var btnType: CButton!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var btnStarCnt: UIButton!
    @IBOutlet weak var btnHartCnt: UIButton!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var btnFaq: CButton!
    @IBOutlet weak var btnChu: CButton!
    @IBOutlet weak var btnPick: UIButton!
    @IBOutlet weak var heightContent: NSLayoutConstraint!
    var heightHeaderView: NSLayoutConstraint?
    var widthHeaderView: NSLayoutConstraint?
//header outlet end
    @IBOutlet weak var tblView: UITableView!
    
    var arrData:Array<Any> = []
    var arrExpertDaily:Array<Any>?
    var data:[String:Any]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CNavigationBar.drawBackButton(self, "전문가", #selector(actionPopViewCtrl))
        
        
        ivProfile.layer.cornerRadius = ivProfile.bounds.height/2
        ivProfile.layer.borderWidth = 1.0
        ivProfile.layer.borderColor = RGB(236, 236, 236).cgColor
        self.tblView.estimatedRowHeight = 100
        self.tblView.rowHeight = UITableView.automaticDimension
        self.view.layoutIfNeeded()
        self.requestExpertDetail()
        tblView.tableHeaderView = headerView
        
        self.requestExpertDailyLife()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoginPopupWithCheckSession()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.headerUpdateLayout()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.headerUpdateLayout()
    }
    
    func headerUpdateLayout() {
        
        if let header = tblView.tableHeaderView {
            if heightHeaderView != nil {
                header.removeConstraint(heightHeaderView!)
            }
            if widthHeaderView != nil {
                header.removeConstraint(widthHeaderView!)
            }
            
            if let header = tblView.tableHeaderView {
                let conHeight = lbContent.sizeThatFits(CGSize(width: lbContent.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
                heightContent.constant = conHeight
                
                let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
                
                header.frame = CGRect(x: header.frame.origin.x, y: header.frame.origin.y, width: header.bounds.width, height: height)
                
                header.translatesAutoresizingMaskIntoConstraints = false
                self.widthHeaderView = header.widthAnchor.constraint(equalToConstant: self.tblView.bounds.width)
                widthHeaderView?.priority = UILayoutPriority(999)
                widthHeaderView?.isActive = true
                
                header.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
                self.heightHeaderView = header.heightAnchor.constraint(equalToConstant: height)
                self.heightHeaderView?.priority = UILayoutPriority(900)
                self.heightHeaderView?.isActive = true
            }
        }
    }
    func requestExpertDailyLife() {
        guard let token = SharedData.instance.token else {
            return
        }
        let param:[String:Any] = ["token":token, "page":1, "per_page":5, "findex":"post_like"]
        ApiManager.shared.requestTalkList(param: param) { (response) in
            if let response = response, let data = response["data"] as? [String:Any], let list = data["list"] as?[[String:Any]], list.isEmpty == false {
                self.arrExpertDaily = list
                self.decorationUi()
            }
        } failure: { (errro) in
            self.showErrorAlertView(errro)
        }

    }
    func requestExpertDetail() {
        guard let token = SharedData.instance.token, let data = data, let mem_id = data["mem_id"] else {
            return
        }
        let param:[String:Any] = ["token":token, "mem_id":mem_id]
        ApiManager.shared.requestExpertDetail(param: param) { (response) in
            if let response = response, let user = response["user"] as? [String:Any] {
                self.data = user
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
        ivProfile.image = nil
        lbName.text = ""
        btnStarCnt.setTitle("0", for: .normal)
        btnHartCnt.setTitle("0", for: .normal)
        lbContent.text = ""
        guard let data = data else {
            return
        }
        
        if let mem_photo = data["mem_photo"] as? String {
            ivProfile.setImageCache(url: mem_photo, placeholderImgName: nil)
        }
        if let mem_nickname = data["mem_nickname"] as? String {
            lbName.text = mem_nickname
        }
        if let mem_star = data["mem_star"] {
            let star = "\(mem_star)".addComma()
            btnStarCnt.setTitle(star, for: .normal)
        }
        if let mem_heart = data["mem_heart"] {
            let hart = "\(mem_heart)".addComma()
            btnHartCnt.setTitle(hart, for: .normal)
        }
        
        if let mem_manager_type = data["mem_manager_type"] as? String {
            btnType.setTitle(mem_manager_type, for: .normal)
        }
        
        let is_mypick = data["is_mypick"] as? Bool
        if is_mypick == true {
            btnPick.isSelected = true
        }
        else {
            btnPick.isSelected = false
        }
        if let mem_profile_content = data["mem_profile_content"] as? String {
            lbContent.text = mem_profile_content
        }
        self.headerUpdateLayout()
        
        arrData.removeAll()
        if let thumb_url = data["thumb_url"] as? [String], thumb_url.isEmpty == false {
            let secInfo:[String:Any] = ["sec_type": "image", "sec_title":"", "sec_list":thumb_url]
            arrData.append(secInfo)
        }
        
        if let arrExpertDaily = arrExpertDaily {
            let secInfo:[String:Any] = ["sec_type": "expertDailyLife", "sec_title":"전문가 일상", "sec_list":arrExpertDaily]
            arrData.append(secInfo)
        }
        
        if let review = data["review"] as? [String:Any], let list = review["list"] as? [[String:Any]], list.isEmpty == false {
            let secInfo:[String:Any] = ["sec_type": "comment", "sec_list":list]
            arrData.append(secInfo)
        }
        self.view.layoutIfNeeded()
        self.tblView.reloadData {
            self.view.layoutIfNeeded()
            self.headerUpdateLayout()
        }
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender.tag == 10000 { //전문가 일상
            print("전문가 일상")
            
            let vc = ExpertLifeListViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if sender == btnFaq {
            let vc = QnaViewController.init()
            vc.type = .oneToQna
            vc.passData = data
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if sender == btnChu {
            
        }
        else if sender == btnPick {
            sender.isSelected = !sender.isSelected
            
        }
    }
    
}
extension ExpertDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let secInfo = arrData[section] as?[String:Any], let secList = secInfo["sec_list"] as? [Any] {
            if let secType = secInfo["sec_type"] as? String, secType == "image" {
                return 1
            }
            return secList.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if let secInfo = arrData[indexPath.section] as?[String:Any], let secList = secInfo["sec_list"] as? [Any] {
            
            let secType = secInfo["sec_type"] as! String
            
            if secType == "image" {
                var imgCell = tableView.dequeueReusableCell(withIdentifier: "ExpertImageCell") as? ExpertImageCell
                if imgCell == nil {
                    imgCell = Bundle.main.loadNibNamed("ExpertImageCell", owner: self, options: nil)?.first as? ExpertImageCell
                }
                
                cell = imgCell
                imgCell?.configurationData(secList)
            }
            else if secType == "expertDailyLife" {
                var dailyCell = tableView.dequeueReusableCell(withIdentifier: "ExpertDailyLifeCell") as? ExpertDailyLifeCell
                if cell == nil {
                    dailyCell = Bundle.main.loadNibNamed("ExpertDailyLifeCell", owner: self, options: nil)?.first as? ExpertDailyLifeCell
                }
                
                cell = dailyCell
                dailyCell?.configurationData(secList[indexPath.row])
            }
            else if secType == "comment" {
                var commentCell = tableView.dequeueReusableCell(withIdentifier: "ExpertCommentCell") as? ExpertCommentCell
                if commentCell == nil {
                    commentCell = Bundle.main.loadNibNamed("ExpertCommentCell", owner: self, options: nil)?.first as? ExpertCommentCell
                }
                
                cell = commentCell
                commentCell?.configurationData(secList[indexPath.row])
            }
        }
        
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "Cell")
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let secInfo = arrData[section] as! [String:Any]
        if let secType = secInfo["sec_type"] as? String, secType == "expertDailyLife" {
            return 67;
        }
        return 8
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let secInfo = arrData[section] as! [String:Any]
        var sectionView:UIView?
        
        if let secType = secInfo["sec_type"] as? String, secType == "expertDailyLife" {
            sectionView = UIView.init(frame: CGRect(x: 0, y: 0, width: tblView.bounds.width, height: 67))
            let hilightBg = UIView.init(frame: CGRect(x: 0, y: 0, width: tblView.bounds.width, height: 8))
            hilightBg.backgroundColor = RGB(242, 242, 242)
            sectionView?.addSubview(hilightBg)
            
            let btn = UIButton.init(frame: CGRect(x: 20, y: hilightBg.frame.maxY + 24, width: 200, height: 27))
            btn.setTitle("전문가 일상", for: .normal)
            btn.setImage(UIImage(named: "ic_arrow_link"), for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            btn.contentHorizontalAlignment = .left
            btn.semanticContentAttribute = .forceRightToLeft
            btn.setTitleColor(UIColor.label, for: .normal)
            sectionView?.addSubview(btn)
            btn.tag = 10000
//            btn.layer.borderWidth = 1.0
//            btn.layer.borderColor = UIColor.red.cgColor
            btn.addTarget(self, action: #selector(onClickedBtnActions(_:)), for: .touchUpInside)
        }
        else {
            sectionView = UIView.init(frame: CGRect(x: 0, y: 0, width: tblView.bounds.width, height: 8))
            sectionView?.backgroundColor = RGB(242, 242, 242)
        }
        return sectionView!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let secInfo = arrData[indexPath.section] as! [String:Any]
        if let secType = secInfo["sec_type"] as? String, secType == "expertDailyLife", let list = secInfo["sec_list"] as? [Any], let item = list[indexPath.row] as? [String:Any] {
            
            let vc = TalkDetailViewController.init()
            vc.data = item
            self.navigationController?.pushViewController(vc, animated:true)
//            let vc = ExpertLifeDetailViewController.init()
//            vc.passData = item
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
