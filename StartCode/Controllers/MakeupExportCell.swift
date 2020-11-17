//
//  MakeupExportCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/16.
//

import UIKit

class MakeupExportCell: UITableViewCell {

    @IBOutlet weak var collectionVeiw: UICollectionView! {
        didSet {
            collectionVeiw.register(UINib(nibName: "ExpertColCell", bundle: nil), forCellWithReuseIdentifier: "ExpertColCell")
        }
    }
    var arrData:Array<[String:Any]>?
    var didSelectedClosure:((_ selData:[String:Any]?, _ index:Int) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func configurationData(_ data: Array<[String:Any]>?) {
        self.arrData = data
        self.collectionVeiw.delegate = self
        self.collectionVeiw.dataSource = self
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: collectionVeiw.bounds.width/3.5, height: 150)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        self.collectionVeiw.collectionViewLayout = layout
        guard let arrData = arrData else {
            return
        }
        
        self.collectionVeiw.reloadData()
    }
}

extension MakeupExportCell:UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let arrData = arrData {
            return arrData.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpertColCell", for: indexPath) as! ExpertColCell
        
        if let arrData = arrData, let item = arrData[indexPath.section] as?[String:Any] {
            cell.configurationData(item)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let arrData = arrData, let item = arrData[indexPath.row] as? [String:Any] else {
            return
        }
        
        didSelectedClosure?(item, indexPath.row)
    }

}
