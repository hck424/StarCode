//
//  MainTabBarController.swift
//  PetChart
//
//  Created by 김학철 on 2020/09/26.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVc = HomeViewController.init()
        let expertVc = ExpertViewController.init()
        let qnaVc = QnaViewController.init()
        let communityVc = CommunityViewController.init()
        let settingVc = SettingViewController.init()
        
//        let homNaviCtrl = BaseNavigationController.init(rootViewController: homeVc)
//        let expertNaviCtrl = BaseNavigationController.init(rootViewController: expertVc)
//        let qnaNaviCtrl = BaseNavigationController.init(rootViewController: qnaVc)
//        let communityNaviCtrl = BaseNavigationController.init(rootViewController: communityVc)
//        let settingNaviCtrl = BaseNavigationController.init(rootViewController: settingVc)
        
        self.viewControllers = [homeVc, expertVc, qnaVc, communityVc, settingVc]

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
        
//        UITabBar.appearance().tintColor = RGB(233, 95, 94)
//        UITabBar.appearance().barTintColor = RGB(255, 255, 255)
        self.hidesBottomBarWhenPushed = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("== maintabar viewwillappear")
    }
    
}
