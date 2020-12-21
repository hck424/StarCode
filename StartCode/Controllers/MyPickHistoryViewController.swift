//
//  MyPickHistoryViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class MyPickHistoryViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: "ExpertColCell", bundle: nil), forCellWithReuseIdentifier: "ExpertColCell")
        }
    }
    var page = 1
    var perPage = 10
    var isPageEnd = false
    var canRequest = true
    var listData:Array<[String:Any]> = []
    override func viewDidLoad() {
        super.viewDidLoad()
     
        CNavigationBar.drawBackButton(self, "내 픽", #selector(actionPopViewCtrl))
        
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: UIScreen.main.bounds.width/3.0, height: 150)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
        self.dataReset()
    }
    
    func dataReset() {
        page = 1
        isPageEnd = false
        canRequest = true
        self.requestMyPickHistory()
    }
    func addData() {
        self.requestMyPickHistory()
    }
    func requestMyPickHistory() {
        guard let token = SharedData.instance.token else {
            return
        }
        if isPageEnd {
            return
        }
        
        let param:[String:Any] = ["token":token, "page":page, "per_page":perPage]
        ApiManager.shared.requestMyPickList(param: param) { (response) in
            self.canRequest = true
            if let response = response, let data = response["data"] as? [String:Any], let list = data["list"] as? Array<[String:Any]> {
                
                if list.count == 0 {
                    self.isPageEnd = true
                }
                
                if self.page == 1 {
                    self.listData = list
                }
                else {
                    self.listData.append(contentsOf: list)
                }
                
                if self.listData.isEmpty == true {
                    self.collectionView.isHidden = true
                }
                else {
                    self.collectionView.isHidden = false
                }
                self.collectionView.reloadData()
                self.page += 1
            }
            else {
                self.showErrorAlertView(response)
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
}

extension MyPickHistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpertColCell", for: indexPath) as! ExpertColCell
        
        cell.configurationData(nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let vc = MyPickHistoryDetailViewController.init()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
extension MyPickHistoryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let velocityY = scrollView.panGestureRecognizer.translation(in: scrollView).y
        let offsetY = floor((scrollView.contentOffset.y + scrollView.bounds.height)*100)/100
        let contentH = floor(scrollView.contentSize.height*100)/100
        
        if velocityY < 0 && offsetY > contentH && canRequest == true {
            canRequest = false
            self.addData()
        }
    }
}
