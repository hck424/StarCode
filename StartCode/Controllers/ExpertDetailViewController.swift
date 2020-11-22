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
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var btnStarCnt: UIButton!
    @IBOutlet weak var btnHartCnt: UIButton!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var btnFaq: CButton!
    @IBOutlet weak var btnChu: CButton!
    @IBOutlet weak var btnPick: UIButton!
    @IBOutlet weak var heightContent: NSLayoutConstraint!
//header outlet end
    @IBOutlet weak var tblView: UITableView!
    
    var arrData:Array<Any> = []
    var passDic:[String:Any]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CNavigationBar.drawBackButton(self, "전문가", #selector(actionPopViewCtrl))
        CNavigationBar.drawRight(self, "12,00", UIImage(named: "ic_chu"), 999, #selector(actionShowChuVc))
        ivProfile.layer.cornerRadius = ivProfile.bounds.height/2
        
        tblView.tableHeaderView = headerView
        self.requestExpertDetail()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let header = tblView.tableHeaderView {
            let conHeight = lbContent.sizeThatFits(CGSize(width: lbContent.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
            heightContent.constant = conHeight
            
            let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            
            header.frame = CGRect(x: header.frame.origin.x, y: header.frame.origin.y, width: header.bounds.width, height: height)
        }
    }
    
    func requestExpertDetail() {
        self.makeTestData()
        self.tblView.reloadData()
    }
    func makeTestData() {
        let item:[String:Any] = ["title": "CF 광고 촬영 출장 다녀왔습니다~", "data": "2020.10.04", "comment_cnt":19]
        var secList = Array<Any>()
        for _ in 0..<10 {
            secList.append(item)
        }
        var secInfo:[String:Any] = ["sec_type": "image", "sec_title":"", "sec_list":secList]
        arrData.removeAll()
        arrData.append(secInfo)
        
        secInfo.removeAll()
        secInfo = ["sec_type": "expertDailyLife", "sec_title":"전문가 일상", "sec_list":secList]
        arrData.append(secInfo)
        
        let item2:[String:Any] = ["name": "꾸쮸뿌쮸", "date":"2020.10.20 13:00", "star_cnt": 4, "content":"진단후기 내용입니다. 진단후기 내용입니다. 진단후기 내용입니다. 진단후기 내용입니다. 진단후기 내용입니다. 진단후기 내용입니다. 진단후기 내용입니다. 진단후기 내용입니다. 진단후기 내용입니다. "]
        secList.removeAll()
        secInfo.removeAll()
        for _ in 0..<10 {
            secList.append(item2)
        }
        secInfo = ["sec_type": "comment", "sec_title":"전문가 일상", "sec_list":secList]
        arrData.append(secInfo)
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender.tag == 10000 { //전문가 일상
            print("전문가 일상")
            
            let vc = ExpertDailyLifeListViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if sender == btnFaq {
            
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
        if let secInfo = arrData[section] as?[String:Any], let secList = secInfo["sec_list"] as? Array<[String:Any]> {
            if let secType = secInfo["sec_type"] as? String, secType == "image" {
                return 1
            }
            return secList.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if let secInfo = arrData[indexPath.section] as?[String:Any], let secList = secInfo["sec_list"] as? Array<[String:Any]> {
            
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
        if let secType = secInfo["sec_type"] as? String, secType == "expertDailyLife", let list = secInfo["sec_list"] as? Array<[String:Any]>, let item = list[indexPath.row] as? [String:Any] {
            let vc = ExpertDailyLifeDetailViewController.init()
            vc.passData = item
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
