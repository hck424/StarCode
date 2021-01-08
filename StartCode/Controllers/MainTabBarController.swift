//
//  MainTabBarController.swift
//  PetChart
//
//  Created by 김학철 on 2020/09/26.
//

import UIKit

class MainTabBarController: UITabBarController {
    #if Cust
    let homeVc = HomeViewController.init()
    let expertVc = ExpertViewController.init()
    let qnaVc = QnaViewController.init()
    let communityVc = TalkListViewController.init()
    let settingVc = SettingViewController.init()
    #else
    let homeVc = ExHomeViewController.init()
    let talkVc = TalkListViewController.init()
    let qnaVc = ExAnswerListViewController.init()
    let makeupVc = ExQuestionListViewController.init()
    let beautyVc = ExQuestionListViewController.init()
    #endif
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        #if Cust
        let homNaviCtrl = BaseNavigationController.init(rootViewController: homeVc)
        let expertNaviCtrl = BaseNavigationController.init(rootViewController: expertVc)
        let qnaNaviCtrl = BaseNavigationController.init(rootViewController: qnaVc)
        let communityNaviCtrl = BaseNavigationController.init(rootViewController: communityVc)
        let settingNaviCtrl = BaseNavigationController.init(rootViewController: settingVc)
        
        self.viewControllers = [homNaviCtrl, expertNaviCtrl, qnaNaviCtrl, communityNaviCtrl, settingNaviCtrl]
        
        let imgHome = UIImage(named: "ic_tabbar_home_off")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let imgHomeSel = UIImage(named: "ic_tabbar_home_on")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let imgExpert = UIImage(named: "ic_tabbar_star_off")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let imgExpertSel = UIImage(named: "ic_tabbar_star_on")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let imgQna = UIImage(named: "ic_tabbar_qna_off")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let imgQnaSel = UIImage(named: "ic_tabbar_qna_on")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let imgCommunity = UIImage(named: "ic_tabbar_community_off")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let imgCommunitySel = UIImage(named: "ic_tabbar_community_on")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let imgSetting = UIImage(named: "ic_tabbar_mypage_off")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let imgSettingSel = UIImage(named: "ic_tabbar_mypage_on")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let item1 = UITabBarItem(title: nil, image: imgHome, selectedImage: imgHomeSel)
        let item2 = UITabBarItem(title: nil, image: imgExpert, selectedImage: imgExpertSel)
        let item3 = UITabBarItem(title: nil, image: imgQna, selectedImage: imgQnaSel)
        let item4 = UITabBarItem(title: nil, image: imgCommunity, selectedImage: imgCommunitySel)
        let item5 = UITabBarItem(title: nil, image: imgSetting, selectedImage: imgSettingSel)
        
        
        homeVc.tabBarItem = item1
        expertVc.tabBarItem = item2
        qnaVc.tabBarItem = item3
        communityVc.tabBarItem = item4
        settingVc.tabBarItem = item5
        #else
        let homNavi = BaseNavigationController.init(rootViewController: homeVc)
        let talkNavi = BaseNavigationController.init(rootViewController: talkVc)
        let qnaNavi = BaseNavigationController.init(rootViewController: qnaVc)
        makeupVc.type = .makeupQna
        let makeupNavi = BaseNavigationController.init(rootViewController: makeupVc)
        beautyVc.type = .beautyQna
        let beautyNavi = BaseNavigationController.init(rootViewController: beautyVc)
        
        self.viewControllers = [homNavi, talkNavi, qnaNavi, makeupNavi, beautyNavi]
        
        let imgHome = UIImage(named: "ic_tabbar_home_off")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let imgHomeSel = UIImage(named: "ic_tabbar_home_on")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)

        let imgTalk = UIImage(named: "ic_tabbar_community_off")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let imgTalkSel = UIImage(named: "ic_tabbar_community_on")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let imgQna = UIImage(named: "ic_tabbar_qna_off")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let imgQnaSel = UIImage(named: "ic_tabbar_qna_on")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let imgMakeup = UIImage(named: "ic_tabbar_makeup_qna_off")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let imgMakeupSel = UIImage(named: "ic_tabbar_makeup_qna_on")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let imgBeauty = UIImage(named: "ic_tabbar_beauty_off")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let imgBeautySel = UIImage(named: "ic_tabbar_beauty_on")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
//        let imgSetting = UIImage(named: "ic_tabbar_mypage_off")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        let imgSettingSel = UIImage(named: "ic_tabbar_mypage_on")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let item1 = UITabBarItem(title: nil, image: imgHome, selectedImage: imgHomeSel)
        let item2 = UITabBarItem(title: nil, image: imgTalk, selectedImage: imgTalkSel)
        let item3 = UITabBarItem(title: nil, image: imgQna, selectedImage: imgQnaSel)
        let item4 = UITabBarItem(title: nil, image: imgMakeup, selectedImage: imgMakeupSel)
        let item5 = UITabBarItem(title: nil, image: imgBeauty, selectedImage: imgBeautySel)
        
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: RGB(233, 95, 94)], for: .normal)
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: RGB(233, 95, 94)], for: .selected)
        
        homeVc.tabBarItem = item1
        talkVc.tabBarItem = item2
        qnaVc.tabBarItem = item3
        makeupVc.tabBarItem = item4
        beautyVc.tabBarItem = item5
        
        #endif
        UITabBar.appearance().tintColor = UIColor.systemBackground
        UITabBar.appearance().barTintColor = UIColor.systemBackground
        self.hidesBottomBarWhenPushed = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("== maintabar viewwillappear")
    }
    
    func changeTabMenuIndex(_ tabIndex:Int, _ subMenuIndex:Int = 0) {
        #if Cust
        if tabIndex == 2 {
            if subMenuIndex == 0 {
                self.qnaVc.type = .makeupQna
            }
            else if subMenuIndex == 1 {
                self.qnaVc.type = .beautyQna
            }
            else {
                self.qnaVc.type = .aiQna
            }
            self.qnaVc.changeTapMenu()
            SharedData.instance.enableChangeTabMenu = true
            self.selectedIndex = tabIndex;
        }
        #else
        self.selectedIndex = tabIndex;
        #endif
    }
    
    //츄 잔액 조회 없으면 충전하기로 넘긴다.
    func checkChuBalance(index:Int) {
        if let chu = Double(SharedData.instance.memChu), chu > 0  {
            self.changeTabMenuIndex(2, index)
        }
        else {
            let coin = SharedData.instance.memChu
            let tmpStr = "CHU"
            let coinStr = "\(coin)".addComma()
            let result = "\(coinStr) \(tmpStr)"

            let attr = NSMutableAttributedString.init(string: result)
            attr.addAttribute(.foregroundColor, value: RGB(139, 0, 255), range: (result as NSString).range(of: coinStr))
            attr.addAttribute(.font, value: UIFont.systemFont(ofSize: 24, weight: .bold), range: (result as NSString).range(of: coinStr))
            attr.addAttribute(.foregroundColor, value: UIColor.label, range: (result as NSString).range(of: tmpStr))
            attr.addAttribute(.font, value: UIFont.systemFont(ofSize: 24, weight: .regular), range: (result as NSString).range(of: tmpStr))
            
            let vc = PopupViewController.init(type: .alert, title: "잔여 CHU", message: attr) { (vcs, selItem, index) in
                vcs.dismiss(animated: true, completion: nil)
                let vc = ChuPurchaseViewController.init()
                if let navi = self.selectedViewController as? BaseNavigationController {
                    navi.pushViewController(vc, animated: true)
                }
            }
            vc.addAction(.ok, "CHU 구매하기")
            self.present(vc, animated: false, completion: nil)
        }
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = self.viewControllers?.firstIndex(of: viewController)
        #if Cust
        if index == 2 && SharedData.instance.enableChangeTabMenu == false {
            let list = ["메이크업 진단 받기", "뷰티고민 질문하기", "Ai 진단 받기"]
            let vc = PopupViewController.init(type: .list, data: list, keys: nil) { (vcs, selItem, index) in
                vcs.dismiss(animated: false, completion: nil)
                //0:"메이크업 진단 받기", 1:"뷰티고민 질문", 2:"1:1질문", 3:"Ai 메이크업 진단"
                if index == 0 || index == 1 {
                    self.checkChuBalance(index: index)
                }
                else {
                    self.changeTabMenuIndex(2, index)
                }
            }
            self.present(vc, animated: false, completion: nil)
            return false
        }
        else {
            return true
        }
        #else
        return true
        #endif
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = self.viewControllers?.firstIndex(of: viewController)
        print("==== selected tab index: \(String(describing: index))")
    }
}
