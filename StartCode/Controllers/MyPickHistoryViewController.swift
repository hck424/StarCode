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
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        CNavigationBar.drawBackButton(self, "내 픽", #selector(actionPopViewCtrl))
        self.addRightNaviMyChuButton()
        
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: UIScreen.main.bounds.width/3.0, height: 150)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
        
        self.requestMyPickHistory()
    }
    func requestMyPickHistory() {
        self.collectionView.reloadData()
    }
}

extension MyPickHistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 31
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
