//
//  ExQuestionListViewController.swift
//  StartCodePro
//
//  Created by 김학철 on 2020/12/21.
//

import UIKit

class ExQuestionListViewController: BaseViewController {
    var type:QnaType = .makeupQna
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: "QuestionColCell", bundle: nil), forCellWithReuseIdentifier: "QuestionColCell")
        }
    }
    
    var listData:Array<[String:Any]> = []
    var page: Int = 1
    var perPage = 10
    var isPageEnd: Bool = false
    var canRequest: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        if type == .beautyQna {
            CNavigationBar.drawBackButton(self, "뷰티질문", false,  #selector(actionPopViewCtrl))
        }
        else {
            CNavigationBar.drawBackButton(self, "메이크업 진단", false,  #selector(actionPopViewCtrl))
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataRest()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layoutIfNeeded()
        self.collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        self.view.layoutIfNeeded()
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        let width = (UIScreen.main.bounds.width - 40)/2
        layout.itemSize = CGSize(width: width, height: width+25)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView.collectionViewLayout = layout
    }
    
    func dataRest() {
        canRequest = true
        page = 1
        isPageEnd = false
        self.requestQuestionList()
        self.collectionView.setContentOffset(CGPoint.zero, animated: false)
    }
    func addData() {
        self.requestQuestionList()
    }
    func requestQuestionList() {
        guard let token = SharedData.instance.token else {
            return
        }
        if isPageEnd == true {
            return
        }
        var category_id = "메이크업진단"
        if type == .beautyQna {
            category_id = "뷰티질문"
        }
        
        let param:[String:Any] = ["page":page, "per_page":perPage, "token":token, "category_id": category_id]
        
        ApiManager.shared.requestAskList(param: param) { (response) in
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
extension ExQuestionListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionColCell", for: indexPath) as! QuestionColCell
        if let item = listData[indexPath.row] as? [String:Any] {
            cell.configurationData(type, item)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        if let item = listData[indexPath.row] as? [String:Any] {
            
            guard let token = SharedData.instance.token, let post_id = item["post_id"] else {
                return
            }
            let param = ["token":token, "post_id":post_id]
            
            ApiManager.shared.requestAnswerOpenCheck(param) { (response) in
                if let response = response, let code = response["code"] as? NSNumber, code.intValue == 200 {
                    if let mem_chu = response["mem_chu"] as? String {
                        SharedData.setObjectForKey(mem_chu, kMemChu)
                        SharedData.instance.memChu = mem_chu
                        self.updateChuNaviBarItem()
                    }
                    
                    if self.type == .oneToQna {
                        let vc = ExOneToQnaDetailViewController.init()
                        vc.data = item
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else if self.type == .makeupQna {
                        let vc = ExMakeupQnaDetailViewController.init()
                        vc.data = item
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else if self.type == .beautyQna {
                        let vc = ExBeautyQnaDetailViewController.init()
                        vc.data = item
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                else {
                    self.showErrorAlertView(response)
                }
            } failure: { (error) in
                self.showErrorAlertView(error)
            }
        }
    }
}
extension ExQuestionListViewController: UIScrollViewDelegate {
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
