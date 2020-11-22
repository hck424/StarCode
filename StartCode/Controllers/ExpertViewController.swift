//
//  ExpertViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/13.
//

import UIKit

class ExpertViewController: BaseViewController {

    @IBOutlet weak var searchBgView: UIView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tfSearch: CTextField!
    @IBOutlet weak var collectionView: UICollectionView!
    let accessoryView = CToolbar.init(barItems: [.keyboardDown])
    var listData:Array<[String:Any]>?
    var searchTxt:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBgView.layer.cornerRadius = 8.0
        
        collectionView.register(UINib(nibName: "ExpertColCell", bundle: nil), forCellWithReuseIdentifier: "ExpertColCell")
        
        CNavigationBar.drawBackButton(self, "전문가", false, nil)
        CNavigationBar.drawRight(self, "12,00", UIImage(named: "ic_chu"), 999, #selector(actionShowChuVc))
        
        self.view.layoutIfNeeded()
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3, height: 150)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView.collectionViewLayout = layout
        tfSearch.inputAccessoryView = accessoryView
        accessoryView.addTarget(self, selctor: #selector(actionKeybardDown))
        
        requestExpertList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardNotification()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotification()
    }
    
    func makeTestData() {
        let item = ["name":"zzz"]
        listData = []
        listData?.removeAll()
        for _ in 0..<20 {
            listData?.append(item)
        }
    }
    
    func dateReset() {
        
    }
    
    func addData() {
        
    }
    
    func requestExpertList() {
        self.makeTestData()
        guard let _ = listData else {
            collectionView.isHidden = true
            return
        }
        collectionView.isHidden = false
        self.collectionView.reloadData()
    }
    
    @IBAction func textFieldEdtingChanged(_ sender: UITextField) {
        self.searchTxt = sender.text
        
        if let searchTxt = searchTxt, searchTxt.isEmpty == false {
            
        }
        else {
            
        }
    }
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender == btnSearch {
            self.view.endEditing(true)
            self.dateReset()
        }
        
    }
}

extension ExpertViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let listData = listData as? [[String:Any]]{
            return listData.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpertColCell", for: indexPath) as! ExpertColCell
        
        if let listData = listData, let item = listData[indexPath.row] as? [String:Any] {
            cell.configurationData(item)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
     
        let vc = ExpertDetailViewController.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ExpertViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTxt = textField.text
        if let searchtxt = searchTxt, searchtxt.isEmpty == false {
            self.dateReset()
            self.view.endEditing(true)
        }
        return true
    }
}
