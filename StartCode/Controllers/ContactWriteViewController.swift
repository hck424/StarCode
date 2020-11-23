//
//  ContactWriteViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class ContactWriteViewController: BaseViewController {

    @IBOutlet weak var tfTitle: CTextField!
    @IBOutlet weak var textView: CTextView!
    @IBOutlet weak var btnOk: CButton!
    
    let accessroyView = CToolbar.init(barItems: [.keyboardDown])
    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "고객센터", #selector(actionPopViewCtrl))
        self.addRightNaviMyChuButton()
        
        tfTitle.inputAccessoryView = accessroyView
        textView.inputAccessoryView = accessroyView
        accessroyView.addTarget(self, selctor: #selector(actionKeybardDown))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        
    }
    
}

extension ContactWriteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let textView = textView as? CTextView {
            textView.placeholderLabel?.isHidden = !textView.text.isEmpty
        }
    }
}
