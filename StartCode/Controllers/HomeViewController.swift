//
//  HomeViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/13.
//

import UIKit

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
   
    var listData:[Any] = []
    var arrBanner:[[String:Any]] = []
    
    
    var headerView:HomeHeaderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CNavigationBar.drawBackButton(self, UIImage(named: "logo_header"), nil)
        CNavigationBar.drawRight(self, "12,00", UIImage(named: "ic_chu"), 999, #selector(actionShowChuVc))
        
        self.view.layoutIfNeeded()
        self.headerView = Bundle.main.loadNibNamed("HomeHeaderView", owner: self, options: nil)?.first as? HomeHeaderView
        tblView.tableHeaderView = headerView!
        tblView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tblView.bounds.width, height: 100))
        self.reqeustBannerList()
    
        self.requestMainData()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let headerView = tblView.tableHeaderView {
            headerView.frame = CGRect.init(x: 0, y: 0, width: tblView.bounds.width, height: 190)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    func reqeustBannerList() {
        //Api 요청
        arrBanner.removeAll()
        let item1 = ["img_url":"img_bn_example", "title":"LOVE YOUR SELF\nCAMPAIGN", "content":"자신을 사랑하기1"]
        let item2 = ["img_url":"img_bn_example", "title":"LOVE YOUR SELF\nCAMPAIGN", "content":"자신을 사랑하기2"]
        let item3 = ["img_url":"img_bn_example", "title":"LOVE YOUR SELF\nCAMPAIGN", "content":"자신을 사랑하기3"]
        let item4 = ["img_url":"img_bn_example", "title":"LOVE YOUR SELF\nCAMPAIGN", "content":"자신을 사랑하기4"]
        arrBanner.append(item1)
        arrBanner.append(item2)
        arrBanner.append(item3)
        arrBanner.append(item4)
        
        self.tblView.reloadData {
            self.headerView?.configurationData(self.arrBanner)
        }
    }
    
    func requestMainData() {
        self.listData = []
        self.makeSectionData()
    }
    
    func makeSectionData() {
        if appType == .user {
            //버튼
            var list = [["title":"전문가의 명쾌한 솔루션", "sub_title":"메이크업 진단 받기", "image_name":"btn_makeup_diag"],
                        ["title":"뷰티 전문가의 고민해결", "sub_title":"뷰티 고민 질문하기", "image_name":"btn_main_beauty_qna"]]
            
            var section: [String : Any] = ["sec_title":"", "sec_type":SectionType.button, "sec_list":list]
            
            listData.append(section)
            
            //전문가
            list.removeAll()
            section.removeAll()
            let item = ["img_url":"img_bn_example", "title":"LOVE YOUR SELF\nCAMPAIGN", "content":"자신을 사랑하기1"]
            for _ in 0..<20 {
                list.append(item)
            }
            
            section = ["sec_title":"메이크업 전문가", "sec_type":SectionType.makeupExport, "sec_list":list]
            listData.append(section)
            
            list.removeAll()
            section.removeAll()
            for _ in 0..<20 {
                list.append(item)
            }
            
            section = ["sec_title":"실시간 인기글", "sec_type":SectionType.popularPost, "sec_list":list]
            listData.append(section)
            
            list.removeAll()
            section.removeAll()
            list = [["title":"Skin Cosmetic", "sub_title":"블라인드 테스트 테스터 모집", "image_name":"img_main_ad"]]
            
            section = ["sec_title":"", "sec_type":SectionType.ad, "sec_list":list]
            listData.append(section)
            
            list.removeAll()
            section.removeAll()
            for _ in 0..<15 {
                list.append(item)
            }
            
            section = ["sec_title":"전문가 일상", "sec_type":SectionType.exportDailyLife, "sec_list":list]
            listData.append(section)
            
            
            self.tblView.reloadData {
                self.tblView.reloadData()
            }
        }
        else {
            
        }
    }

    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        let vc = LoginViewController.init()
        self.navigationController?.pushViewController(vc, animated:true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let secInfo = listData[section] as? [String:Any], let secType = secInfo["sec_type"] as? SectionType else {
            return 0
        }
        
        if let sec_list = secInfo["sec_list"] as? [[String:Any]] {
            if secType == .makeupExport {
                return 1
            }
            else {
                return sec_list.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        let secInfo = listData[indexPath.section] as! [String:Any]
        let secType = secInfo["sec_type"] as! SectionType
        let secList = secInfo["sec_list"] as? Array<Any>
       
        if secType == .button {
            var tmpCell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as? ButtonCell
            if tmpCell == nil {
                tmpCell = Bundle.main.loadNibNamed("ButtonCell", owner: self, options: nil)?.first as? ButtonCell
            }
            if let secList = secList, let item = secList[indexPath.row] as? [String:Any] {
                tmpCell?.configurationData(item)
            }
            cell = tmpCell
            
            tmpCell?.didSelectedClosure = {(selData, index)->() in
                guard let selData = selData else {
                    return
                }
                let hasMoney = false
                if hasMoney {
                    let list = ["메이크업 진단 받기", "뷰티고민 질문하기", "Ai 진단 받기"]
                    let vc = PopupViewController.init(type: .list, data: list, keys: nil, completion: { (vcs, selData, index) in
                        
                        vcs.dismiss(animated: false, completion: nil)
                        guard let selData = selData else {
                            return
                        }
                        print(selData)
                    })
                    
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: false, completion: nil)
                }
                else {
                    let vc = PopupViewController.init(type: .balance, data: ["coin": 2000]) { (vcs, selData, index) in
                        vcs.dismiss(animated: false, completion: nil)
                        if index == 1 { //구매하기로 가기
                            print("coint 구매하기로 가기")
                        }
                    }
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: false, completion: nil)
                }
            }
        }
        else if secType == .makeupExport {
            var tmpCell = tableView.dequeueReusableCell(withIdentifier: "MakeupExportCell") as? MakeupExportCell
            if tmpCell == nil {
                tmpCell = Bundle.main.loadNibNamed("MakeupExportCell", owner: self, options: nil)?.first as? MakeupExportCell
            }
            
            if let secList = secList as? [[String:Any]] {
                tmpCell?.configurationData(secList)
            }
            
            cell = tmpCell
            tmpCell?.didSelectedClosure = {(selData:[String:Any]?, index:Int)->Void in
                guard let selData = selData else {
                    return
                }
                print(selData)
            }
        }
        else if secType == .popularPost {
            var tmpCell = tableView.dequeueReusableCell(withIdentifier: "PopularPostCell") as? PopularPostCell
            if tmpCell == nil {
                tmpCell = Bundle.main.loadNibNamed("PopularPostCell", owner: self, options: nil)?.first as? PopularPostCell
            }
            
            if let secList = secList,  let item = secList[indexPath.row] as? [String:Any] {
                tmpCell?.configurationData(item)
            }
            cell = tmpCell
        }
        else if secType == .ad {
            var tmpCell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as? ButtonCell
            if tmpCell == nil {
                tmpCell = Bundle.main.loadNibNamed("ButtonCell", owner: self, options: nil)?.first as? ButtonCell
            }
            
            if let secList = secList, let item = secList[indexPath.row] as? [String:Any] {
                tmpCell?.configurationData(item)
            }
            tmpCell?.ivArrow.isHidden = true
            cell = tmpCell
        }
        else if secType == .exportDailyLife {
            var tmpCell = tableView.dequeueReusableCell(withIdentifier: "ExpertDailyLifeCell") as? ExpertDailyLifeCell
            if tmpCell == nil {
                tmpCell = Bundle.main.loadNibNamed("ExpertDailyLifeCell", owner: self, options: nil)?.first as? ExpertDailyLifeCell
            }
            
            if let secList = secList,  let item = secList[indexPath.row] as? [String:Any] {
                tmpCell?.configurationData(item)
            }
            cell = tmpCell
            
        }
        
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "Cell")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let secInfo = listData[section] as! [String:Any]
        let secType = secInfo["sec_type"] as! SectionType
        
        if secType == .button || secType == .ad {
            return 30
        }
        
        return 70
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let secInfo = listData[section] as! [String:Any]

        let secTitle = secInfo["sec_title"]
        let sectionView = Bundle.main.loadNibNamed("HomeSectionView", owner: self, options: nil)?.first as! HomeSectionView
        if let secTitle = secTitle as? String, secTitle.isEmpty == false {
            sectionView.btnTitle.isHidden = false
            sectionView.btnTitle.setTitle(secTitle, for: .normal)
            sectionView.section = section
            
            sectionView.didSelectedClosure = {(index:Int)->Void in
                guard let secInfo = self.listData[index] as?[String:Any], let sectionList = secInfo["sec_list"] as? Array<Any> else {
                    return
                }
                
                let type = secInfo["sec_type"] as! SectionType
                if type == .makeupExport {
                    print("메이크업 전문가")
                }
                else if type == .popularPost {
                    print("실시간 인기글")
                }
                else if type == .exportDailyLife {
                    print("전문가의 일상")
                }
            }
        }
        else {
            sectionView.btnTitle.isHidden = true
        }
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
     
        guard let secInfo = listData[indexPath.section] as?[String:Any], let sectionList = secInfo["sec_list"] as? Array<Any>, let item = sectionList[indexPath.row] as? [String:Any]  else {
            return
        }
        
        let type = secInfo["sec_type"] as! SectionType
        if type == .popularPost || type == .exportDailyLife  {
            print(item)
        }
    }
}
