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
    var type:QnaType = .oneToQna
    var data:[String:Any]?
    var aiResult:[String:Any]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if type == .oneToQna {
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
        
        if appType == .user {
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
        else {
            ApiManager.shared.requestAnswerDetail(param: param) { (response) in
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
        
        
        if let comment = data["comment"] as? [String:Any], let list = comment["list"] as? Array<[String:Any]>, list.isEmpty == false {
            for item in list {
                let questionView = Bundle.main.loadNibNamed("MyQnaView", owner: self, options: nil)?.first as! MyQnaView
                svContent.addArrangedSubview(questionView)
                questionView.questionType = type
                questionView.configurationData(item, .answer)
                questionView.didClickedClosure = {(selData, actionIndex) -> () in
                    guard let selData = selData, let cmt_id = selData["cmt_id"] as? String else {
                        return
                    }
                    if actionIndex == 100 {
                        //패스
                    }
                    else if actionIndex == 101 {
                        //경고
                        let token = SharedData.instance.token!
                        let param = ["token":token, "cmt_id": cmt_id]
                        ApiManager.shared.requestPostCommentWarning(param: param) { (response) in
                            if let response = response, let message = response["message"] as? String {
                                self.showToast(message)
                            }
                        } failure: { (error) in
                            self.showErrorAlertView(error)
                        }
                    }
                    else if actionIndex == 102 {
                        //채택
                        let token = SharedData.instance.token!
                        let param = ["token":token, "cmt_id": cmt_id]
                        ApiManager.shared.requestAskChoose(param: param) { (response) in
                            if let response = response, let message = response["message"] as? String {
                                self.showToast(message)
                            }
                        } failure: { (error) in
                            self.showErrorAlertView(error)
                        }
                    }
                }
            }
        }
        else if let aiResult = aiResult {
            let questionView = Bundle.main.loadNibNamed("MyQnaView", owner: self, options: nil)?.first as! MyQnaView
            svContent.addArrangedSubview(questionView)
            questionView.questionType = type
            questionView.configurationData(aiResult, .answer)
            
            questionView.didClickedClosure = {(selData, actionIndex) -> () in
                guard let selData = selData, let cmt_id = selData["cmt_id"] as? String else {
                    return
                }
                if actionIndex == 100 {
                    //패스
                }
                else if actionIndex == 101 {
                    //경고
                    let token = SharedData.instance.token!
                    let param = ["token":token, "cmt_id": cmt_id]
                    ApiManager.shared.requestPostCommentWarning(param: param) { (response) in
                        if let response = response, let message = response["message"] as? String {
                            self.showToast(message)
                        }
                    } failure: { (error) in
                        self.showErrorAlertView(error)
                    }
                }
                else if actionIndex == 102 {
                    //채택
                    let token = SharedData.instance.token!
                    let param = ["token":token, "cmt_id": cmt_id]
                    ApiManager.shared.requestAskChoose(param: param) { (response) in
                        if let response = response, let message = response["message"] as? String {
                            self.showToast(message)
                        }
                    } failure: { (error) in
                        self.showErrorAlertView(error)
                    }
                }
            }
        }
    }
}
