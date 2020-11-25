//
//  LoginSelectViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/13.
//

import UIKit

class LoginSelectViewController: BaseViewController {

    @IBOutlet weak var btnSignUp: CButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnNaver: UIButton!
    @IBOutlet weak var btnKakao: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let title = btnSignIn.titleLabel?.text {
            let attr = NSAttributedString.init(string: title, attributes: [NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue])
            btnSignIn.setAttributedTitle(attr, for: .normal)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender == btnSignUp {
            let vc = LoginViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if sender == btnFacebook {
            
        }
        else if sender == btnNaver {
            
        }
        else if sender == btnKakao {
            
        }
        else if sender == btnSignIn {
            let vc = MrTermsViewController.init()
            vc.user = UserInfo.init(JSON: ["join_type":"none"])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
