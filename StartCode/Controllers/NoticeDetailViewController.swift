//
//  NoticeDetailViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class NoticeDetailViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "공지사항", #selector(actionPopViewCtrl))
        self.addRightNaviMyChuButton()
    }

}
