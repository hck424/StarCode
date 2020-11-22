//
//  MyQnaViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class MyQnaViewController: BaseViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var arrTabBtn: [SelectedButton]!
    
    var selBtn:SelectedButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CNavigationBar.drawBackButton(self, "나의 문의 내역", #selector(actionPopViewCtrl))
        self.addRightNaviMyChuButton()
        
        arrTabBtn = arrTabBtn.sorted(by: { (btn1, btn2) -> Bool in
            btn2.tag > btn1.tag
        })
        for btn in arrTabBtn {
            btn.addTarget(self, action: #selector(onClickedBtnActions(_ :)), for: .touchUpInside)
        }
        
        let btn = arrTabBtn.first
        btn?.sendActions(for: .touchUpInside)
    }
    
    func requestQnaList(searchTxt: String) {
        self.tblView.reloadData {
            
        }
    }
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if let sender = sender as? SelectedButton {
            for btn in arrTabBtn {
                btn.isSelected = false
            }
            scrollView.scrollRectToVisible(sender.frame, animated: true)
            sender.isSelected = true
            if sender.tag == 1 {
                self.requestQnaList(searchTxt: "")
            }
            else if sender.tag == 2 {
                self.requestQnaList(searchTxt: "")
            }
            else if sender.tag == 3 {
                self.requestQnaList(searchTxt: "")
            }
            else if sender.tag == 4 {
                self.requestQnaList(searchTxt: "")
            }
            
            self.selBtn = sender
        }
    }
}

extension MyQnaViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MyQnaCell") as? MyQnaCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("MyQnaCell", owner: self, options: nil)?.first as? MyQnaCell
        }
        
        if let selBtn = selBtn {
            if selBtn.tag == 1 || selBtn.tag == 2 {
                cell?.configurationData(nil, .type2, indexPath.row)
            }
            else {
                cell?.configurationData(nil, .type3, indexPath.row)
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
