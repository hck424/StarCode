//
//  MyQnaDetailViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/12/14.
//

import UIKit

class MyQnaDetailViewController: BaseViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var svContent: UIStackView!
    var vcTitle = ""
    var type:QnaType = .faq
    var data:[String:Any]? 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if type == .faq {
            vcTitle = "1:1 문의"
        }
        else if type == .makeupQna {
            vcTitle = "메이크업 진단"
        }
        else if type == .beautyQna {
            vcTitle = "뷰티질문"
        }
        else if type == .aiQna {
            vcTitle = "Ai 질문"
        }
        CNavigationBar.drawBackButton(self, vcTitle, #selector(actionPopViewCtrl))
       
        self.requestMyQuestDetail()
    }
    func requestMyQuestDetail() {
        guard let token = SharedData.instance.token else {
            return
        }
        guard let data = data, let post_id = data["post_id"] as? String else {
            return
        }
        let param = ["token":token, "post_id":post_id]
        
        ApiManager.shared.requestAskDetail(param: param) { (response) in
            if let response = response, let data = response["data"] as? [String:Any],
               let code = response["code"] as? Int, code == 200 {
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
        guard let data = data else {
            return
        }
        self.view.layoutIfNeeded()
        let questionView = Bundle.main.loadNibNamed("MyQnaView", owner: self, options: nil)?.first as! MyQnaView
        svContent.addArrangedSubview(questionView)
        
        self.view.layoutIfNeeded()
        questionView.questionType = type
        questionView.configurationData(data, .question)
        
        
        if let comment = data["comment"] as? [String:Any], let list = comment["list"] as? Array<[String:Any]> {
            
        }
    }
}
