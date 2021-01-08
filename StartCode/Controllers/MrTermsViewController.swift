//
//  MrTermsViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/14.
//

import UIKit

class MrTermsViewController: BaseViewController {
    @IBOutlet weak var btnTotal: UIButton!
    @IBOutlet weak var btnFourteen: UIButton!
    @IBOutlet weak var btnService: UIButton!
    @IBOutlet weak var btnPrivacy: UIButton!
    @IBOutlet weak var btnMarketing: UIButton!
    @IBOutlet weak var tvService: CTextView!
    @IBOutlet weak var tvPrivacy: CTextView!
    @IBOutlet weak var tvMaketing: CTextView!
    @IBOutlet weak var btnOk: UIButton!
    
    var user:UserInfo?
    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "약관동의", #selector(actionPopViewCtrl))
        self.removeRightChuNaviItem()
        self.removeRightSettingNaviItem()
        
        let tmpStr = "(필수)"
        let result = "만 14세 이상입니다 \(tmpStr)"
        let attr = NSMutableAttributedString.init(string: result, attributes: [.foregroundColor: UIColor.label])
        attr.addAttribute(.foregroundColor, value: ColorAppDefault, range: (result as NSString).range(of: tmpStr))
        btnFourteen.setAttributedTitle(attr, for: .normal)
        
        let result2 = "서비스 이용약관 동의 \(tmpStr)"
        let attr2 = NSMutableAttributedString.init(string: result2, attributes: [.foregroundColor: UIColor.label])
        attr2.addAttribute(.foregroundColor, value: ColorAppDefault, range: (result2 as NSString).range(of: tmpStr))
        btnService.setAttributedTitle(attr2, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @IBAction func onClickedBtnActions(_ sender:UIButton) {
        if sender == btnTotal {
            sender.isSelected = !sender.isSelected
            btnFourteen.isSelected = sender.isSelected
            btnService.isSelected = sender.isSelected
            btnPrivacy.isSelected = sender.isSelected
            btnMarketing.isSelected = sender.isSelected
        }
        else if sender == btnFourteen {
            sender.isSelected = !sender.isSelected
        }
        else if sender == btnService {
            sender.isSelected = !sender.isSelected
        }
        else if sender == btnPrivacy {
            sender.isSelected = !sender.isSelected
        }
        else if sender == btnMarketing {
            sender.isSelected = !sender.isSelected
        }
        else if sender == btnOk {
            if btnFourteen.isSelected == false
                || btnService.isSelected == false {
                self.showToast("약관에 동의해주세요.")
                return
            }
            
            guard let user = user else {
                return
            }
            
            user.mem_is_14_agree = "0"
            user.mem_is_termsservice_agree = "0"
            user.mem_is_privacy_agree = "0"
            user.mem_is_marketing_agree = "0"
            
            if btnFourteen.isSelected {
                user.mem_is_14_agree = "1"
            }
            if btnService.isSelected {
                user.mem_is_termsservice_agree = "1"
            }
            if btnPrivacy.isSelected {
                user.mem_is_privacy_agree = "1"
            }
            if btnMarketing.isSelected {
                user.mem_is_marketing_agree = "1"
            }
            
            let vc = MrPhoneAuthViewController.init()
            vc.user = user
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
