//
//  MainTabBarController.swift
//  PetChart
//
//  Created by 김학철 on 2020/09/26.
//

import UIKit

class MainTabBarController: UITabBarController {
    let homeVc = HomeViewController.init()
    let expertVc = ExpertViewController.init()
    let qnaVc = QnaViewController.init()
    let communityVc = TalkListViewController.init()
    let settingVc = SettingViewController.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
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
        
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: RGB(233, 95, 94)], for: .normal)
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: RGB(233, 95, 94)], for: .selected)
        
        homeVc.tabBarItem = item1
        expertVc.tabBarItem = item2
        qnaVc.tabBarItem = item3
        communityVc.tabBarItem = item4
        settingVc.tabBarItem = item5
        
        UITabBar.appearance().tintColor = UIColor.systemBackground
        UITabBar.appearance().barTintColor = UIColor.systemBackground
        self.hidesBottomBarWhenPushed = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("== maintabar viewwillappear")
    }
    
    func changeTabMenuIndex(_ tabIndex:Int, _ subMenuIndex:Int = 0) {
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
            self.selectedIndex = 2;
        }
    }
    
    //츄 잔액 조회 없으면 충전하기로 넘긴다.
    func checkChuBalance(index:Int) {
        if SharedData.instance.memChu > 0 {
            self.changeTabMenuIndex(2, index)
        }
        else {
            let coin = SharedData.instance.memChu
            let tmpStr = "ea"
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
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = self.viewControllers?.firstIndex(of: viewController)
        print("==== selected tab index: \(String(describing: index))")
    }
}
