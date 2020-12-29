//
//  ExOneToQnaDetailViewController.swift
//  StartCodePro
//
//  Created by 김학철 on 2020/12/27.
//

import UIKit

class ExOneToQnaDetailViewController: BaseViewController {
    @IBOutlet weak var svContent: UIStackView!
    
    var data:[String:Any] = [:]
    var type:QnaType = .oneToQna
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tmpStr = "(1:1 질문)"
        let result = String(format: "내게 주어진 질문 %@", tmpStr)
        let attr = NSMutableAttributedString.init(string: result)
        attr.addAttribute(.foregroundColor, value: RGB(155, 155, 155), range: ((result as NSString).range(of: tmpStr)))
        CNavigationBar.drawBackButton(self, attr, #selector(actionPopViewCtrl))
    
        
        self.requestAnswerDetail()
        
    }
    func requestAnswerDetail() {
        guard let token = SharedData.instance.token, let post_id = data["post_id"] else {
            return
        }
        let param = ["token":token, "post_id":post_id]
        ApiManager.shared.requestAnswerDetail(param: param) { (response) in
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
        svContent.addArrangedSubview(questView)
        questView.configurationData(data, type)
        
    }
}
