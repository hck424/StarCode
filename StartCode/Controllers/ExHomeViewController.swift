//
//  ExHomeViewController.swift
//  StartCodePro
//
//  Created by 김학철 on 2020/12/21.
//
//전문가 탭은 홈, 커뮤니티, 1:1질문, 메이크업진단, 뷰티진단입니다.
import UIKit

class ExHomeViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    
    var headerView:HomeHeaderView?
    var listData:[Any] = []
    var arrBanner:[[String:Any]] = []
    var arrAnswer:[[String:Any]] = []
    var arrMakeup:[[String:Any]] = []
    var arrBeauty:[[String:Any]] = []
    var arrPopular:[[String:Any]] = []
    var arrExpertLife:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CNavigationBar.drawBackButton(self, UIImage(named: "logo_header"), nil)
        
        self.headerView = Bundle.main.loadNibNamed("HomeHeaderView", owner: self, options: nil)?.first as? HomeHeaderView
        tblView.tableHeaderView = headerView!
        tblView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tblView.bounds.width, height: 190))
        self.reqeustBannerList()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataReset()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let headerView = tblView.tableHeaderView {
            headerView.frame = CGRect.init(x: 0, y: 0, width: tblView.bounds.width, height: (self.view.frame.size.width * 170)/335)
        }
    }
    func dataReset() {
//        self.requestMyAnswerList()
        self.requestAskList(type: .oneToQna)
        self.requestAskList(type: .makeupQna)
        self.requestAskList(type: .beautyQna)
        self.requestTalkListPopular()
        self.requestExpertLifeList()
    }
    func reqeustBannerList() {
        arrBanner.removeAll()
        let param:[String:Any] = ["akey":akey]
        ApiManager.shared.requestAdvertisement(param: param) { (response) in
            if let response = response, let banner = response["banner"] as?[String:Any], let list = banner["list"] as? Array<[String:Any]>, list.isEmpty == false {
                self.arrBanner.append(contentsOf: list)
                let saveOffset = self.tblView.contentOffset
                self.tblView.reloadData {
                    self.headerView?.configurationData(self.arrBanner)
                    self.tblView.setContentOffset(saveOffset, animated: false)
                }
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
//    func requestMyAnswerList() {
//        guard let token = SharedData.instance.token else {
//            return
//        }
//        let param:[String:Any] = ["token":token, "page":1, "category_id":"1:1", "state":0]
//        ApiManager.shared.requestMyAnswerList(param: param) { (response) in
//            if let response = response, let data = response["data"] as? [String:Any], let list = data["list"] as? Array<[String:Any]>, list.isEmpty == false {
//                self.arrAnswer = list
//            }
//            else {
//                self.arrAnswer.removeAll()
//            }
//            self.makeSectionData()
//        } failure: { (error) in
//            self.showErrorAlertView(error)
//        }
//    }
    func requestAskList(type:QnaType) {
        guard let token = SharedData.instance.token else {
            return
        }
        var category_id = ""
        var per_page = 6
        if type == .makeupQna {
            category_id = "메이크업진단"
            per_page = 6
        }
        else if type == .beautyQna {
            category_id = "뷰티질문"
            per_page = 6
        }
        else if type == .oneToQna {
            category_id = "1:1"
            per_page = 5
        }
        else {
            return
        }
        
        let param:[String:Any] = ["token":token, "page":1, "per_page": per_page, "category_id":category_id]
        ApiManager.shared.requestAskList(param: param) { (response) in
            if let response = response, let data = response["data"] as? [String:Any], let list = data["list"] as? Array<[String:Any]>, list.isEmpty == false {
                if type == .makeupQna {
                    self.arrMakeup = list
                }
                else if type == .beautyQna {
                    self.arrBeauty = list
                }
                else if type == .oneToQna {
                    self.arrAnswer = list
                }
            }
            else {
                if type == .makeupQna {
                    self.arrMakeup.removeAll()
                }
                else if type == .beautyQna {
                    self.arrBeauty.removeAll()
                }
                else if type == .oneToQna {
                    self.arrAnswer.removeAll()
                }
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
    func requestExpertLifeList() {
        var param:[String:Any] = ["page":1, "per_page":10, "findex":"post_like"]
        if let token = SharedData.instance.token {
            param["token"] = token
        }
        ApiManager.shared.requestExpertLifeList(param: param) { (response) in
            if let response = response, let data = response["data"] as? [String:Any], let list = data["list"] as? Array<[String:Any]>, list.isEmpty == false {
                self.arrExpertLife = list
            }
            else {
                self.arrExpertLife.removeAll()
            }
            self.makeSectionData()
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
    
    func makeSectionData() {
        self.listData.removeAll()
        if arrAnswer.isEmpty == false {
            let tmpStr = "(1:1 질문)"
            let result = String(format: "내게 주어진 질문 %@", tmpStr)
            let attr = NSMutableAttributedString.init(string: result)
            attr.addAttribute(.foregroundColor, value: RGB(155, 155, 155), range: ((result as NSString).range(of: tmpStr)))
            let section:[String:Any] = ["sec_title": attr, "sec_type":SectionType.askAnswer, "sec_list":arrAnswer]
            listData.append(section)
        }
        
        if arrMakeup.isEmpty == false {
            let section:[String:Any] = ["sec_title": "메이크업 진단", "sec_type":SectionType.askMakeup, "sec_list":arrMakeup]
            listData.append(section)
        }
        
        let list = [["title":"Skin Cosmetic", "sub_title":"블라인드 테스트 테스터 모집", "image_name":"img_main_ad"]]
        let adSection = ["sec_title":"", "sec_type":SectionType.ad, "sec_list":list] as [String : Any]
        listData.append(adSection)
        
        if arrBeauty.isEmpty == false {
            let section:[String:Any] = ["sec_title": "뷰티 질문", "sec_type":SectionType.askBeauty, "sec_list":arrBeauty]
            listData.append(section)
        }
        
        if arrPopular.isEmpty == false {
            let section = ["sec_title":"실시간 인기글", "sec_type":SectionType.popularPost, "sec_list":arrPopular] as [String : Any]
            listData.append(section)
        }
        
        if arrExpertLife.isEmpty == false {
            let section = ["sec_title":"전문가 일상", "sec_type":SectionType.expertLife, "sec_list":arrExpertLife] as [String : Any]
            listData.append(section)
        }
        let saveOffset = self.tblView.contentOffset
        self.tblView.reloadData {
//            self.tblView.reloadData()
            self.tblView.setContentOffset(saveOffset, animated: false)
        }
    }
}

extension ExHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return listData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let secInfo = listData[section] as? [String:Any], let secType = secInfo["sec_type"] as? SectionType else {
            return 0
        }
        
        if let sec_list = secInfo["sec_list"] as? [[String:Any]] {
            if secType == .askMakeup || secType == .askBeauty {
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
        else if secType == .askAnswer {
            var tmpCell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell") as? AnswerCell
            if tmpCell == nil {
                tmpCell = Bundle.main.loadNibNamed("AnswerCell", owner: self, options: nil)?.first as? AnswerCell
            }
            if let secList = secList, let item = secList[indexPath.row] as? [String:Any] {
                tmpCell?.configuraitonData(item)
            }
            cell = tmpCell
        }
        else if secType == .askMakeup || secType == .askBeauty {
            var tmpCell = tableView.dequeueReusableCell(withIdentifier: "MakeupExpertCell") as? MakeupExpertCell
            if tmpCell == nil {
                tmpCell = Bundle.main.loadNibNamed("MakeupExpertCell", owner: self, options: nil)?.first as? MakeupExpertCell
            }
            
            if let secList = secList as? [[String:Any]] {
                tmpCell?.configurationData(secList, secType)
            }
            
            cell = tmpCell
            tmpCell?.didSelectedClosure = {(selData:[String:Any]?, index:Int)->Void in
                guard let selData = selData else {
                    return
                }
                
                guard let token = SharedData.instance.token, let post_id = selData["post_id"] else {
                    return
                }
                
                let param = ["token":token, "post_id":post_id]
                ApiManager.shared.requestAnswerOpenCheck(param) { (response) in
                    if let response = response, let code = response["code"] as? NSNumber, code.intValue == 200 {
                        if let mem_chu = response["mem_chu"] as? NSNumber {
                            SharedData.setObjectForKey("\(mem_chu)", kMemChu)
                            SharedData.instance.memChu = "\(mem_chu)"
                            self.updateChuNaviBarItem()
                        }
                        
                        if secType == .askMakeup {
                            let vc = ExMakeupQnaDetailViewController.init()
                            vc.data = selData
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else if secType == .askBeauty {
                            let vc = ExBeautyQnaDetailViewController.init()
                            vc.data = selData
                            self.navigationController?.pushViewController(vc, animated: true)
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
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let secInfo = listData[section] as! [String:Any]

        let secTitle = secInfo["sec_title"]
        let sectionView = Bundle.main.loadNibNamed("HomeSectionView", owner: self, options: nil)?.first as! HomeSectionView
        if let secTitle = secTitle {
            sectionView.btnTitle.isHidden = false
            if let secTitle = secTitle as? NSAttributedString {
                sectionView.btnTitle.setAttributedTitle(secTitle, for: .normal)
            }
            else if let secTitle = secTitle as? String {
                sectionView.btnTitle.setTitle(secTitle, for: .normal)
            }
            
            sectionView.section = section
            
            sectionView.didSelectedClosure = {(index:Int)->Void in
                guard let secInfo = self.listData[index] as?[String:Any], let type = secInfo["sec_type"] as? SectionType  else {
                    return
                }
                
                if type == .popularPost {
                    print("실시간 인기글")
                    AppDelegate.instance()?.mainTabbarCtrl()?.selectedIndex = 1
                }
                else if type == .askAnswer {
                    AppDelegate.instance()?.mainTabbarCtrl()?.selectedIndex = 2
                }
                else if type == .askMakeup {
                    AppDelegate.instance()?.mainTabbarCtrl()?.selectedIndex = 3
                }
                else if type == .askBeauty {
                    AppDelegate.instance()?.mainTabbarCtrl()?.selectedIndex = 4
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
            let vc = ExpertLifeDetailViewController.init()
            vc.data = item
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if type == .askAnswer {
            guard let token = SharedData.instance.token, let post_id = item["post_id"] else {
                return
            }
            let param = ["token":token, "post_id":post_id]
            
            ApiManager.shared.requestAnswerOpenCheck(param) { (response) in
                if let response = response, let code = response["code"] as? NSNumber, code.intValue == 200 {
                    if let mem_chu = response["mem_chu"] as? NSNumber {
                        SharedData.setObjectForKey("\(mem_chu)", kMemChu)
                        SharedData.instance.memChu = "\(mem_chu)"
                        self.updateChuNaviBarItem()
                    }
                    
                    let vc = ExOneToQnaDetailViewController.init()
                    vc.data = item
                    self.navigationController?.pushViewController(vc, animated: true)
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
