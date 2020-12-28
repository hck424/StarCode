//
//  MakeupExpertCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/16.
//

import UIKit

class MakeupExpertCell: UITableViewCell {

    @IBOutlet weak var collectionVeiw: UICollectionView! {
        didSet {
            collectionVeiw.register(UINib(nibName: "ExpertColCell", bundle: nil), forCellWithReuseIdentifier: "ExpertColCell")
        }
    }
    var arrData:Array<[String:Any]>?
    var didSelectedClosure:((_ selData:[String:Any]?, _ index:Int) -> Void)?
    var sectionType:SectionType = .makeupExport
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func configurationData(_ data: Array<[String:Any]>?, _ type:SectionType) {
        self.arrData = data
        self.sectionType = type
        self.collectionVeiw.delegate = self
        self.collectionVeiw.dataSource = self
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        let width:CGFloat = 78+8
        layout.itemSize = CGSize(width: width, height: self.bounds.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionVeiw.contentInset = UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 17)
        self.collectionVeiw.collectionViewLayout = layout
        DispatchQueue.main.async {
            self.collectionVeiw.reloadData()
        }
    }
}

extension MakeupExpertCell:UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let arrData = arrData {
            return arrData.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpertColCell", for: indexPath) as! ExpertColCell
        
        if let arrData = arrData, let item = arrData[indexPath.row] as?[String:Any] {
            cell.configurationData(item)
        }
        if sectionType == .askBeauty {
            cell.ivProfile.layer.cornerRadius = 20
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
