//
//  ExpertImageCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/18.
//

import UIKit

class ExpertImageCell: UITableViewCell {
    @IBOutlet weak var collectionVew: UICollectionView! {
        didSet {
            collectionVew.register(UINib(nibName: "ExpertImgColCell", bundle: nil), forCellWithReuseIdentifier: "ExpertImgColCell")
        }
    }
    var arrData:[String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configurationData(_ data:[Any]?) {
        guard let data = data as? [String] else {
            return
        }
        
        self.arrData = data
        
        collectionVew.delegate = self
        collectionVew.dataSource = self
        self.layoutIfNeeded()
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 180, height: 180)
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.footerReferenceSize = CGSize.zero
        layout.headerReferenceSize = CGSize.zero
        collectionVew.collectionViewLayout = layout
        
        collectionVew.reloadData()
    }
}

extension ExpertImageCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpertImgColCell", for: indexPath) as! ExpertImgColCell
        let item = arrData[indexPath.row]
        cell.configurationData(.expertDetail, item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
