//
//  ExAnswerDetailViewController.swift
//  StartCodePro
//
//  Created by 김학철 on 2020/12/27.
//

import UIKit

class ExMakeupQnaDetailViewController: BaseViewController {
    @IBOutlet weak var svContent: UIStackView!
    
    var data:[String:Any] = [:]
    var type:QnaType = .makeupQna
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "메이크업 진단", #selector(actionPopViewCtrl))
        
        self.requestAnswerDetail()
        
    }
    func requestAnswerDetail() {
        guard let token = SharedData.instance.token, let post_id = data["post_id"] else {
            return
        }
        let param = ["token":token, "post_id":post_id]
        ApiManager.shared.requestAskDetail(param: param) { (response) in
            if let response = response, let data = response["data"] as? [String:Any] {
                self.data = data
                self.configurationUi()
            }
            else {
                self.showErrorAlertView(response)
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
    func configurationUi() {
        self.view.layoutIfNeeded()
        let questView = Bundle.main.loadNibNamed("ExQuestionView", owner: self, options: nil)?.first as! ExQuestionView
        svContent.insertArrangedSubview(questView, at: 0)
        questView.configurationData(data, type)
        
    }
}
