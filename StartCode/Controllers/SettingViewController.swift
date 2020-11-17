//
//  SettingViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/13.
//

import UIKit

class SettingViewController: BaseViewController {
    @IBOutlet var haderView: UIView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    let listData = [["title":"내 게시글", "count": 1],
                    ["title":"나의 문의 내역", "count": 5],
                    ["title":"CHU 사용 내역", "count": 12],
                    ["title":"내 픽"],
                    ["title":"스크랩"],
                    ["title":"계정관리"],
                    ["title":"환경설정"],
                    ["title":"공지사항"],
                    ["title":"이벤트"],
                    ["title":"고객센터"],
                    ["title":"FAQ"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, UIImage(named: "logo_header"), nil)
        CNavigationBar.drawRight(self, "12,00", UIImage(named: "ic_chu"), 999, #selector(actionShowChuVc))
        
        tblView.tableHeaderView = haderView
        let userName = "장유리"
        let result = "\(userName)님\n환영합니다."
        let attr = NSMutableAttributedString.init(string: result)
        attr.addAttribute(.foregroundColor, value: RGB(128, 0, 250), range: (result as NSString).range(of: userName))
        attr.addAttribute(.font, value: UIFont.systemFont(ofSize: lbUserName.font.pointSize, weight: .bold), range: (result as NSString).range(of: userName))
        
        lbUserName.attributedText = attr
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
        
        if let item = listData[indexPath.row] as? [String:Any] {
            let title = item["title"] as! String
            cell?.lbTitle.text = title
            cell?.btnNoticeCnt.isHidden = true
            if let count = item["count"] as? Int {
                cell?.btnNoticeCnt.isHidden = false
                cell?.btnNoticeCnt.setTitle("\(count)", for: .normal)
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
