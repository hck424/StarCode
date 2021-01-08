//
//  MrCompleteViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/15.
//

import UIKit

class MrCompleteViewController: BaseViewController {

    @IBOutlet weak var btnOk: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "가입완료", #selector(onClickedBtnActions(_:)))
        self.removeRightChuNaviItem()
        self.removeRightSettingNaviItem()
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender.tag == TAG_NAVI_BACK {
            self.navigationController?.popViewController(animated: true)
            if appType == .user {
                AppDelegate.instance()?.callMainVc()
            }
            else {
                AppDelegate.instance()?.callLoginVc()
            }
        }
        else if sender == btnOk {
            //save user 정보 및
            if appType == .user {
                AppDelegate.instance()?.callMainVc()
            }
            else {
                AppDelegate.instance()?.callLoginVc()
            }
        }
    }
}
