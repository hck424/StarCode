//
//  EventDetailViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class EventDetailViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "이벤트 상세", #selector(actionPopViewCtrl))
        self.addRightNaviMyChuButton()
        
    }
    
}
