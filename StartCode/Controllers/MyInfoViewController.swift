//
//  MyInfoViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class MyInfoViewController: BaseViewController {

    @IBOutlet weak var tfPassword: CTextField!
    @IBOutlet weak var btnChangePW: UIButton!
    @IBOutlet weak var lbHitPw: UILabel!
    @IBOutlet weak var tfNickName: CTextField!
    @IBOutlet weak var btnChangeNickName: UIButton!
    @IBOutlet weak var lbHitNickName: UILabel!
    @IBOutlet weak var textView: CTextView!
    let accessoryView = CToolbar.init(barItems: [.keyboardDown])
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CNavigationBar.drawBackButton(self, "계정 관리", #selector(actionPopViewCtrl))
        self.addRightNaviMyChuButton()
        
        tfPassword.inputAccessoryView = accessoryView
        tfNickName.inputAccessoryView = accessoryView
        textView.inputAccessoryView = accessoryView
        accessoryView.addTarget(self, selctor: #selector(actionKeybardDown))
        self.addTapGestureKeyBoardDown()
        
        self.requestMyInfo()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardNotification()
        textView.delegate = self
        textView.placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotification()
    }
    
    func requestMyInfo() {
        self.decortionUi()
    }
    
    func decortionUi() {
        
    }
    
}

extension MyInfoViewController: UITextFieldDelegate {
    
}

extension MyInfoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let textView = textView as? CTextView {
            textView.placeholderLabel?.isHidden = !textView.text.isEmpty
        }
    }
    
    
}
