//
//  MyQnaDetailViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/12/14.
//

import UIKit

class MyQnaDetailViewController: BaseViewController {
    var type:QnaType = .faq
    var data:[String:Any]? 
    override func viewDidLoad() {
        super.viewDidLoad()
        var vcTitle = ""
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
        guard let token = SharedData.instance.pToken else {
            return
        }
        guard let data = data, let post_id = data["post_id"] as? String else {
            return
        }
        let param = ["token":token, "post_id":post_id]
        
        ApiManager.shared.requestAskDetail(param: param) { (response) in
            if let response = response, let data = response["data"] as? [String:Any], let code = response["code"] as? Int, code == 200 {
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
        
    }
}
