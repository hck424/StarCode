//
//  ExpertDailyLifeListViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/18.
//

import UIKit

class ExpertDailyLifeListViewController: BaseViewController {
    @IBOutlet weak var btnCategory: CButton!
    @IBOutlet weak var tfSearch: CTextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lbEmpty: UILabel!
    
    var searchTxt:String?
    var listData:Array<[String:Any]>?
    
    let accoryView = CToolbar.init(barItems: [.keyboardDown])
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CNavigationBar.drawBackButton(self, "전문가 일상", #selector(actionPopViewCtrl))
        CNavigationBar.drawRight(self, "12,00", UIImage(named: "ic_chu"), 999, #selector(actionShowChuVc))
        
        tfSearch.inputAccessoryView = accoryView
        accoryView.addTarget(self, selctor: #selector(actionKeybardDown))
        
        self.dataRest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardNotification()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotification()
    }
    
    
    @IBAction func textFieldEdtingChanged(_ sender: UITextField) {
        self.searchTxt = sender.text
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        
        if sender == btnCategory {
            
        }
        else if sender == btnSearch {
            
        }
    }
    func makeTestData() {
        let item = ["title": "djfakldsjfla"]
        listData = Array<[String:Any]>()
        listData?.removeAll()
        for _ in 0..<30 {
            listData?.append(item)
        }
    }
    func dataRest() {
        self.requestExpertDailyLifeList()
    }
    func addData() {
        
        self.requestExpertDailyLifeList()
    }
    
    func requestExpertDailyLifeList() {
        self.makeTestData()
        self.tblView.reloadData()
    }
}
extension ExpertDailyLifeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let listData = listData {
            return listData.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ExpertDailyLifeCell") as? ExpertDailyLifeCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("ExpertDailyLifeCell", owner: self, options: nil)?.first as? ExpertDailyLifeCell
        }
        if let listData = listData, let item = listData[indexPath.row] as? [String:Any] {
            cell?.configurationData(item)
            
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblView.deselectRow(at: indexPath, animated: true)
        if let listData = listData, let item = listData[indexPath.row] as? [String:Any] {
            let vc = ExpertDailyLifeDetailViewController.init()
            vc.passData = item
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension ExpertDailyLifeListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.searchTxt = textField.text
        if let searchTxt = searchTxt, searchTxt.isEmpty == false {
            self.dataRest()
        }
        
        self.view.endEditing(true)
        return true
    }
}
