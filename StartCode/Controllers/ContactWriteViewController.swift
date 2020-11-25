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
        self.showLoginPopupWithCheckSession()
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender == btnOk {
            guard let title = tfTitle.text, title.isEmpty == false else {
                self.view.makeToast("타이틀을 입력해주세요.", position:.top)
                return
            }
            guard let content = textView.text, content.isEmpty == false else {
                self.view.makeToast("내용을 입력해주세요.", position:.top)
                return
            }
            
            guard let token = SharedData.instance.pToken else {
                return
            }
            let param = ["token":token, "post_title": title, "post_content": content]
            self.view.endEditing(true)
            ApiManager.shared.requestContactUsWrite(param: param) { (response) in
                if let response = response, let code = response["code"] as? Int, code == 200, let message = response["message"] as? String {
                    self.view.makeToast(message, position:.top)
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    self.showErrorAlertView(response)
                }
            } failure: { (error) in
                self.showErrorAlertView(error)
            }
        }
    }
    
}

extension ContactWriteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let textView = textView as? CTextView {
            textView.placeholderLabel?.isHidden = !textView.text.isEmpty
        }
    }
}
