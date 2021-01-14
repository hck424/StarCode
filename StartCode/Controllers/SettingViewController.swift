//
//  SettingViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/13.
//

import UIKit
enum CellId:String {
    case myPost = "myPost"
    case myQna = "myQna"
    case chuUsingHistory = "chuUsingHistory"
    case myPick = "myPick"
    case myScrap = "myScrap"
    case accountManage = "accountManage"
    case configuration = "configuration"
    case notice = "notice"
    case event = "event"
    case contactus = "contactus"
    case faq = "faq"
    
    func displayName() ->String {
        if self.rawValue == "myPost" {
            return "내 게시글"
        }
        else if self.rawValue == "myQna" {
            if appType == .user {
                return "나의 문의 내역"
            }
            else {
                return "질문 내역"
            }
        }
        else if self.rawValue == "chuUsingHistory" {
            return "CHU 사용 내역"
        }
        else if self.rawValue == "myPick" {
            return "내 픽"
        }
        else if self.rawValue == "myScrap" {
            return "스크랩"
        }
        else if self.rawValue == "accountManage" {
            return "계정관리"
        }
        else if self.rawValue == "configuration" {
            return "환경설정"
        }
        else if self.rawValue == "notice" {
            return "공지사항"
        }
        else if self.rawValue == "event" {
            return "이벤트"
        }
        else if self.rawValue == "contactus" {
            return "고객센터"
        }
        else if self.rawValue == "faq" {
            return "FAQ"
        }
        else {
            return ""
        }
    }
}
class SettingViewController: BaseViewController {
    @IBOutlet var haderView: UIView!
    @IBOutlet weak var headerInfoView: CView!
    @IBOutlet weak var btnHart: UIButton!
    @IBOutlet weak var btnStar: UIButton!
    @IBOutlet weak var btnMyPick: UIButton!
    
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var btnChuChange: CButton!
    
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var tblView: UITableView!
    #if Cust
    let listData:[CellId] = [.myPost, .myQna, .chuUsingHistory, .myPick, .myScrap, .accountManage, .configuration, .notice, .event, .contactus, .faq]
    #else
    let listData:[CellId] = [.myPost, .myQna, .chuUsingHistory, .myScrap, .accountManage, .configuration, .notice, .event, .contactus, .faq]
    #endif
    var badgeInfo:[String:Any]?
    override func viewDidLoad() {
        super.viewDidLoad()
        if appType == .user {
            CNavigationBar.drawBackButton(self, UIImage(named: "logo_header"), nil)
        }
        else {
            CNavigationBar.drawBackButton(self, "설정", #selector(actionPopViewCtrl))
            self.removeRightSettingNaviItem()
        }
        
        tblView.tableHeaderView = haderView
        tblView.tableFooterView = footerView
        if appType == .user {
            headerInfoView.isHidden = true
            btnChuChange.isHidden = true
        }
        else {
            headerInfoView.isHidden = false
            btnChuChange.isHidden = false
        }
        self.decorationUi()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestMyInfo()
        self.requestUserBadge()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tblView.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let header = tblView.tableHeaderView {
            let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            header.frame = CGRect(x: header.frame.origin.x, y: header.frame.origin.y, width: header.bounds.width, height: height)
        }
        
        if let footer = tblView.tableFooterView {
            if appType == .user {
                footer.frame = CGRect(x: footer.frame.origin.x, y: footer.frame.origin.y, width: footer.bounds.width, height: 24)
            }
            else {
                footer.frame = CGRect(x: footer.frame.origin.x, y: footer.frame.origin.y, width: footer.bounds.width, height: 88)
            }
        }
    }
    func decorationUi() {
        if let userName = SharedData.objectForKey(kMemNickname) as? String {
            let result = "\(userName)님\n환영합니다."
            let attr = NSMutableAttributedString.init(string: result)
            attr.addAttribute(.foregroundColor, value: RGB(128, 0, 250), range: (result as NSString).range(of: userName))
            attr.addAttribute(.font, value: UIFont.systemFont(ofSize: lbUserName.font.pointSize, weight: .bold), range: (result as NSString).range(of: userName))
            lbUserName.attributedText = attr
        }
        else {
            lbUserName.text = "환영합니다."
        }
        
        if let hartCnt = SharedData.objectForKey(kMemHart) as? String {
            btnHart.setTitle(hartCnt, for: .normal)
        }
        if let likeCnt = SharedData.objectForKey(kMemStar) as? String {
            btnStar.setTitle(likeCnt, for: .normal)
        }
        
    }
    func requestUserBadge() {
        guard let token = SharedData.instance.token, let mem_id = SharedData.instance.memId else {
            return
        }
        let param = ["token":token, "mem_id":mem_id]
        ApiManager.shared.requestUserBadge(param: param) { (response) in
            if let response = response, let code = response["code"] as? NSNumber, code.intValue == 200, let data = response["data"] as? [String:Any] {
                self.badgeInfo = data
                self.tblView.reloadData()
            }
            else {
                self.showErrorAlertView(response)
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
    
    func requestMyInfo() {
        guard let token = SharedData.instance.token else {
            return
        }
        let param = ["token":token]
        ApiManager.shared.requestMyInfo(param:param) { (response) in
            if let response = response, let user = response["user"] as? [String:Any], let code = response["code"] as? NSNumber, code.intValue == 200 {
                SharedData.instance.saveUserInfo(user: user)
                self.decorationUi()
            }
            else {
                self.showErrorAlertView(response)
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender == btnLogout {
            let vc = PopupViewController.init(type: .alert, title: "로그아웃", message: "로그아웃 하시겠습니까?") { (vcs, selItem, index) in
                
                vcs.dismiss(animated: true, completion: nil)
                if index == 1 {
                    SharedData.removeObjectForKey(kToken)
                    SharedData.instance.token = nil

                    if appType == .user {
                        AppDelegate.instance()?.callLgoinSelectVc()
                    }
                    else {
                        AppDelegate.instance()?.callLoginVc()
                    }
                }
            }
            vc.addAction(.cancel, "취소")
            vc.addAction(.ok, "확인")
            present(vc, animated: true, completion: nil)
        }
        else if sender == btnChuChange {
            #if Pro
            let vc = ChuExportViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
            #endif
        }
    }
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as? SettingCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("SettingCell", owner: self, options: nil)?.first as? SettingCell
        }
        cell?.btnNoticeCnt.isHidden = true
        cell?.btnPush.isHidden = true
        
        if let cellId = listData[indexPath.row] as? CellId {
            cell?.lbTitle.text = cellId.displayName()
            if cellId == .myPost {
                if let badge = badgeInfo, let new_post = badge["new_post"] as? NSNumber {
                    cell?.btnNoticeCnt.isHidden = false
                    cell?.btnNoticeCnt.setTitle("\(new_post)", for: .normal)
                }
            }
            else if cellId == .myQna {
                if appType == .user {
                    if let badge = badgeInfo, let qna = badge["qna"] as? NSNumber {
                        cell?.btnNoticeCnt.isHidden = false
                        cell?.btnNoticeCnt.setTitle("\(qna)", for: .normal)
                    }
                }
                else {
                    if let badge = badgeInfo, let answer = badge["answer"] as? NSNumber {
                        cell?.btnNoticeCnt.isHidden = false
                        cell?.btnNoticeCnt.setTitle("\(answer)", for: .normal)
                    }
                }
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cellId = listData[indexPath.row] as? CellId else {
            return
        }
        
        if cellId == .myPost {
            let vc = MyPostListViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if cellId == .myQna {
            let vc = MyQnaListViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if cellId == .chuUsingHistory {
            let vc = ChuHistoryViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if cellId == .myPick {
            let vc = MyPickHistoryViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if cellId == .myScrap {
            let vc = MyScrapViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if cellId == .accountManage {
            let vc = MyInfoViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if cellId == .configuration {
            if appType == .expert {
                let vc = ConfigurationViewController.init()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if cellId == .notice {
            let vc = NoticeListViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if cellId == .event {
            let vc = EventListViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if cellId == .contactus {
            let vc = ContactUsListViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if cellId == .faq {
            let vc = FAQListViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
