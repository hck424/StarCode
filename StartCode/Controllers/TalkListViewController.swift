//
//  TalkListViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/13.
//

import UIKit

class TalkListViewController: BaseViewController {

    @IBOutlet weak var btnMakup: SelectedButton!
    @IBOutlet weak var btnBeauty: SelectedButton!
    @IBOutlet weak var lbEmpty: UILabel!
    @IBOutlet weak var btnCategory: CButton!
    @IBOutlet weak var tfSearch: CTextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnWrite: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    var listData:Array<[String:Any]>?
    var searchTxt:String?
    let accoryView = CToolbar.init(barItems: [.keyboardDown])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "전문가", false, nil)
        CNavigationBar.drawRight(self, "12,00", UIImage(named: "ic_chu"), 999, #selector(actionShowChuVc))
        
        tfSearch.inputAccessoryView = accoryView
        accoryView.addTarget(self, selctor: #selector(onClickedBtnActions(_:)))
        
        btnMakup.sendActions(for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardNotification()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotification()
    }
    func requestCommunityList() {
        
    }
    
    @IBAction func textFieldEdtingChanged(_ sender: UITextField) {
        self.searchTxt = sender.text
    }
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender == btnMakup {
            btnMakup.isSelected = true
            btnBeauty.isSelected = false
            
            tfSearch.text = ""
            searchTxt = nil
            
            self.requestCommunityList()
        }
        else if sender == btnBeauty {
            btnMakup.isSelected = false
            btnBeauty.isSelected = true
            
            tfSearch.text = ""
            searchTxt = nil
            
            self.requestCommunityList()
        }
        else if sender == btnSearch {
            
        }
    }

}
extension TalkListViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let listData = listData {
            return listData.count
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tblView.dequeueReusableCell(withIdentifier: "CommunityCell") as? CommunityCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("CommunityCell", owner: self, options: nil)?.first as? CommunityCell
        }
        
        if let listData = listData, let item = listData[indexPath.row] as? [String:Any] {
            cell?.configurationData(item)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension TalkListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTxt = textField.text;
        
        return true
    }
}
