//
//  MrPhoneAuthViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/15.
//

import UIKit

class MrPhoneAuthViewController: BaseViewController {
    @IBOutlet weak var btnOk: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "휴대폰 인증", #selector(onClickedBtnActions(_:)))
        
    }
    
    @IBAction func onClickedBtnActions(_ sender:UIButton) {
        
    }
}
