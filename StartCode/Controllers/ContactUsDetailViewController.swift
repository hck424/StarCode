//
//  ContactUsDetailViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class ContactUsDetailViewController: BaseViewController {
    @IBOutlet weak var lbQusTitle: UILabel!
    @IBOutlet weak var lbQusDate: UILabel!
    @IBOutlet weak var lbQusContent: UILabel!
    
    @IBOutlet weak var svAnswer: UIStackView!
    var data:[String:Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "고객센터", #selector(actionPopViewCtrl))
        self.addRightNaviMyChuButton()

        self.requestContactUsDetail()
    }
    func requestContactUsDetail() {
        guard let token = SharedData.instance.pToken, let post_id = data["post_id"] else {
            return
        }
        
        let param:[String:Any] = ["token": token, "post_id":post_id]
        ApiManager.shared.requestContactUsDetail(param: param) { (response) in
            if let response = response, let data = response["data"] as? [String:Any] {
                self.data = data
                self.decorationUi()
            }
            else {
                self.showErrorAlertView(response)
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
    
    func decorationUi() {
        if let post_title = data["post_title"] as? String {
            lbQusTitle.text = post_title
        }
        if let post_content = data["post_content"] as? String {
            lbQusContent.text = post_content
        }
        if let post_datetime = data["post_datetime"] as? String {
            let df = CDateFormatter.init()
            df.dateFormat = "yyyy-MM-dd HH.mm.ss"
            if let date = df.date(from: post_datetime) {
                df.dateFormat = "yyyy.MM.dd HH.mm"
                lbQusDate.text = df.string(from: date)
            }
        }
        
        guard let comment = data["comment"] as? Array<[String:Any]>, comment.isEmpty == false else {
            return
        }
        for item in comment {
            let cell = Bundle.main.loadNibNamed("ContactUsDetailAnswerView", owner: nil, options: nil)?.first as! ContactUsDetailAnswerView
            svAnswer.addArrangedSubview(cell)
            cell.configurationData(item)
        }
    }
}
