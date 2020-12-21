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
    var arrExpert:[[String:Any]] = []
    var arrAskBtn:[[String:Any]] = []
    var arrPopular:[[String:Any]] = []
    var arrDailyLife:[[String:Any]] = []
    
    var headerView:HomeHeaderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrAskBtn.append(["title":"전문가의 명쾌한 솔루션", "sub_title":"메이크업 진단 받기", "image_name":"btn_makeup_diag"])
        arrAskBtn.append(["title":"뷰티 전문가의 고민해결", "sub_title":"뷰티 고민 질문하기", "image_name":"btn_main_beauty_qna"])
        
        CNavigationBar.drawBackButton(self, UIImage(named: "logo_header"), nil)
        
        
        self.view.layoutIfNeeded()
        self.headerView = Bundle.main.loadNibNamed("HomeHeaderView", owner: self, options: nil)?.first as? HomeHeaderView
        tblView.tableHeaderView = headerView!
        tblView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tblView.bounds.width, height: 100))
        self.reqeustBannerList()
        self.reqeustExpertMainTop()
        self.requestTalkListPopular()
        self.requestTalkListExpertDailyLife()
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
        let param:[String:Any] = ["akey":akey, "page":1, "per_page":10]
        
        ApiManager.shared.requestEventList(param: param) { (response) in
            if let response = response, let banner = response["data"] as?[String:Any], let list = banner["list"] as? Array<[String:Any]>, list.isEmpty == false {
                self.arrBanner.append(contentsOf: list)
                self.tblView.reloadData {
                    self.headerView?.configurationData(self.arrBanner)
                }
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
    func reqeustExpertMainTop() {
        arrExpert.removeAll()
        let param:[String:Any] = ["akey":akey, "page":1, "per_page":5]
        ApiManager.shared.requestExpertMainTop(param: param) { (response) in
            guard let response = response else {
                return
            }
            
            if let data1 = response["data1"] as? [String:Any], let list = data1["list"] as? Array<[String:Any]>, list.isEmpty == false {
                self.arrExpert.append(contentsOf: list)
            }
            if let data2 = response["data2"] as? [String:Any], let list = data2["list"] as? Array<[String:Any]>, list.isEmpty == false {
                self.arrExpert.append(contentsOf: list)
            }
            
            self.makeSectionData()
            
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
    func requestTalkListPopular() {
        var param:[String:Any] = ["page":1, "per_page":10, "findex":"desc"]
        if let token = SharedData.instance.token {
            param["token"] = token
        }
        arrPopular.removeAll()
        ApiManager.shared.requestTalkList(param: param) { (response) in
            guard let response = response else {
                return
            }
            if let data = response["data"] as? [String:Any], let list = data["list"] as? Array<[String:Any]>, list.isEmpty == false {
                self.arrPopular = list
            }
            self.makeSectionData()
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
    func requestTalkListExpertDailyLife() {
        var param:[String:Any] = ["page":1, "per_page":10, "findex":"post_like"]
        if let token = SharedData.instance.token {
            param["token"] = token
        }
        ApiManager.shared.requestExpertLifeList(param: param) { (response) in
            guard let response = response else {
                return
            }
            if let data = response["data"] as? [String:Any], let list = data["list"] as? Array<[String:Any]>, list.isEmpty == false {
                self.arrDailyLife = list
            }
            self.makeSectionData()
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
    func makeSectionData() {
        if appType == .user {
            //버튼
            listData.removeAll()
            
            let section: [String : Any] = ["sec_title":"", "sec_type":SectionType.button, "sec_list":arrAskBtn]
            listData.append(section)

            if arrExpert.isEmpty == false {
                let section:[String : Any] = ["sec_title":"메이크업 전문가", "sec_type":SectionType.makeupExport, "sec_list":arrExpert]
                listData.append(section)
            }

            if arrPopular.isEmpty == false {
                let section = ["sec_title":"실시간 인기글", "sec_type":SectionType.popularPost, "sec_list":arrPopular] as [String : Any]
                listData.append(section)
            }

            let list = [["title":"Skin Cosmetic", "sub_title":"블라인드 테스트 테스터 모집", "image_name":"img_main_ad"]]
            let adSection = ["sec_title":"", "sec_type":SectionType.ad, "sec_list":list] as [String : Any]
            listData.append(adSection)
            
            if arrDailyLife.isEmpty == false {
                let section = ["sec_title":"전문가 일상", "sec_type":SectionType.expertLife, "sec_list":arrDailyLife] as [String : Any]
                listData.append(section)
            }
            
            self.tblView.reloadData {
                self.tblView.reloadData()
            }
        }
        else {
            
        }
    }

    func moveTabIndex(index:Int) {
        //0:"메이크업 진단 받기", 1:"뷰티고민 질문", 2:"1:1질문", 3:"Ai 메이크업 진단"
        AppDelegate.instance()?.mainTabbarCtrl()?.selectedIndex = 2
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
                guard let mainTabVc = AppDelegate.instance()?.mainTabbarCtrl(), let vctrls = mainTabVc.viewControllers, let vc = vctrls[2] as? UIViewController else {
                    return
                }
                mainTabVc.tabBarController(mainTabVc, shouldSelect: vc)
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
                let vc = ExpertDetailViewController.init()
                vc.data = selData
                self.navigationController?.pushViewController(vc, animated: true)
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
        else if secType == .expertLife {
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
                    AppDelegate.instance()?.mainTabbarCtrl()?.selectedIndex = 1
                }
                else if type == .popularPost {
                    print("실시간 인기글")
                    AppDelegate.instance()?.mainTabbarCtrl()?.selectedIndex = 3
                }
                else if type == .expertLife {
                    print("전문가의 일상")
                    let vc = ExpertLifeListViewController.init()
                    self.navigationController?.pushViewController(vc, animated: true)
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
        if type == .popularPost {
            let vc = TalkDetailViewController.init()
            vc.data = item
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if type == .expertLife {
//            let vc = TalkDetailViewController.init()
//            vc.data = item
//            self.navigationController?.pushViewController(vc, animated:true)
            let vc = ExpertLifeDetailViewController.init()
            vc.data = item
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
