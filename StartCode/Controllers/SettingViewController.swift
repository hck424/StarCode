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
            return "나의 문의 내역"
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
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    let listData:[CellId] = [.myPost, .myQna, .chuUsingHistory, .myPick, .myScrap, .accountManage, .configuration, .notice, .event, .contactus, .faq]
    
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
        
        self.tblView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let header = tblView.tableHeaderView {
            let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            header.frame = CGRect(x: header.frame.origin.x, y: header.frame.origin.y, width: header.bounds.width, height: height)
        }
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender == btnLogout {
            let vc = PopupViewController.init(type: .alert, title: "로그아웃", message: "로그아웃 하시겠습니까?") { (vcs, selItem, index) in
                
                vcs.dismiss(animated: true, completion: nil)
                if index == 1 {
                    SharedData.removeObjectForKey(kToken)
                    SharedData.instance.token = nil
                    SharedData.removeObjectForKey(kMemId)
                    SharedData.removeObjectForKey(kMemUserid)
                    SharedData.removeObjectForKey(kMemPassword)
                    SharedData.instance.memUserId = nil
                    SharedData.instance.memId = nil
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
        
        if let cellId = listData[indexPath.row] as? CellId {
            cell?.lbTitle.text = cellId.displayName()
            cell?.btnNoticeCnt.isHidden = true
//            if let count = item["count"] as? Int {
//                cell?.btnNoticeCnt.isHidden = false
//                cell?.btnNoticeCnt.setTitle("\(count)", for: .normal)
//            }
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
            let vc = ConfigurationViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
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
