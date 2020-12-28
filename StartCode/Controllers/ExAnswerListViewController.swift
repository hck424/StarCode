//
//  ExAnswerListViewController.swift
//  StartCodePro
//
//  Created by 김학철 on 2020/12/21.
//

import UIKit

class ExAnswerListViewController: BaseViewController {
    @IBOutlet weak var tblView: UITableView!
    var arrAnswer:Array<[String:Any]> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let tmpStr = "(1:1 질문)"
        let result = String(format: "내게 주어진 질문 %@", tmpStr)
        let attr = NSMutableAttributedString.init(string: result)
        attr.addAttribute(.foregroundColor, value: RGB(155, 155, 155), range: ((result as NSString).range(of: tmpStr)))
        CNavigationBar.drawBackButton(self, attr, false, #selector(actionPopViewCtrl))
        
        let footerView = Bundle.main.loadNibNamed("TableFooterView", owner: self, options: nil)?.first as! TableFooterView
        self.tblView.tableFooterView = footerView

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoginPopupWithCheckSession()
        self.requestMyAnswerList()
    }
    
    func requestMyAnswerList() {
        guard let token = SharedData.instance.token else {
            return
        }
        let param:[String:Any] = ["token":token, "page":1, "category_id":"1:1", "state":0]
        ApiManager.shared.requestMyAnswerList(param: param) { (response) in
            if let response = response, let data = response["data"] as? [String:Any], let list = data["list"] as? Array<[String:Any]>,
               list.isEmpty == false {
                self.tblView.isHidden = false
                self.arrAnswer = list
            }
            else {
                self.arrAnswer.removeAll()
                self.tblView.isHidden = true
            }
            self.tblView.reloadData()
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
}

extension ExAnswerListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAnswer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell") as? AnswerCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("AnswerCell", owner: self, options: nil)?.first as? AnswerCell
        }
        if  let item = arrAnswer[indexPath.row] as? [String:Any] {
            cell?.configuraitonData(item)
        }
        return cell!
    }
    
    
}
