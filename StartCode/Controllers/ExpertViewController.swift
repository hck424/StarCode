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
    var listOrignData:Array<[String:Any]> = []
    var listData:Array<[String:Any]> = []
    var searchTxt:String?
    
    var page = 1
    var totalPage = NSInteger.max
    var perPage = 10
    var isRequest = false
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
        
        let footerH:CGFloat = 100
        let footerView = UIView.init(frame: CGRect(x: 0, y: collectionView.bounds.height, width: collectionView.bounds.width, height: footerH))
        footerView.backgroundColor = UIColor.clear
        collectionView.addSubview(footerView)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: footerH, right: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardNotification()
        self.dataReset()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotification()
    }
    
    func dataReset() {
        self.page = 1
        totalPage = NSInteger.max
        self.listOrignData.removeAll()
        self.listData.removeAll()
        self.collectionView.setContentOffset(CGPoint.zero, animated: false)
        self.requestExpertList()
    }
    func addData() {
        self.requestExpertList()
    }
    
    func requestExpertList() {

        if page >= totalPage {
            return
        }
        //        akey, page:1, per_page:10, skeyword:전문가2, findx, sfield:mem_nickname
        var param:[String:Any] = ["akey":akey, "page":page, "per_page":perPage]
        if let searchTxt = searchTxt, searchTxt.isEmpty == false {
            param["skeyword"] = searchTxt
            param["sfield"] = "mem_nickname"
        }
        
        ApiManager.shared.requestExpertList(param: param) { (response) in
            if let response = response, let data = response["data"] as? [String:Any], let list = data["list"] as? Array<[String:Any]>, list.isEmpty == false {
                self.isRequest = false
                if self.page == 1 {
                    self.listOrignData = list
                }
                else {
                    self.listOrignData.append(contentsOf: list)
                }
                self.listData = self.listOrignData
                if let total_rows = response["total_rows"] as? Int {
                    if (total_rows%self.perPage) == 0 {
                        self.totalPage = total_rows/self.perPage
                    }
                    else {
                        self.totalPage = Int(total_rows/self.perPage)+1
                    }
                }
                self.page += 1
                
                if self.listData.count == 0 {
                    self.collectionView.isHidden = true
                }
                else {
                    self.collectionView.isHidden = false
                }
                self.collectionView.reloadData()
            }
            
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
    
    @IBAction func textFieldEdtingChanged(_ sender: UITextField) {
        self.searchTxt = sender.text
        
        if let searchTxt = searchTxt, searchTxt.isEmpty == false {
            var tmparr:Array<[String:Any]> = Array()
            for item in listOrignData {
                if let mem_nickname = item["mem_nickname"] as? String {
                    if mem_nickname.contains(searchTxt) {
                        tmparr.append(item)
                    }
                }
            }
            if tmparr.isEmpty == false {
                self.listData = tmparr
                self.collectionView.reloadData()
            }
        }
        else {
            self.listData = listOrignData
            self.collectionView.reloadData()
        }
    }
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender == btnSearch {
            self.view.endEditing(true)
            self.dataReset()
        }
        
    }
}

extension ExpertViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let velocityY = scrollView.panGestureRecognizer.translation(in: scrollView).y
        let offsetY = floor((scrollView.contentOffset.y + scrollView.bounds.height)*100)/100
        let contentH = floor(scrollView.contentSize.height*100)/100
        
        if velocityY < 0 && offsetY > contentH && isRequest == false {
            isRequest = true
            self.addData()
        }
    }
}
extension ExpertViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpertColCell", for: indexPath) as! ExpertColCell
        
        if let item = listData[indexPath.row] as? [String:Any] {
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
        self.dataReset()
        self.view.endEditing(true)
        return true
    }
}
