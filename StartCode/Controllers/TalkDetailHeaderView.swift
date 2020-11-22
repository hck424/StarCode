//
//  TalkDetailHeaderView.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/17.
//

import UIKit

class TalkDetailHeaderView: UIView {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbModify: CButton!
    @IBOutlet weak var lbDelete: CButton!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var heightConetnt: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib.init(nibName: "ExpertImgColCell", bundle: nil), forCellWithReuseIdentifier: "ExpertImgColCell")
        }
    }
    
    @IBOutlet weak var btnScript: UIButton!
    @IBOutlet weak var lbWarning: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var textView: CTextView!
    @IBOutlet weak var photoScrollView: UIScrollView!
    @IBOutlet weak var svPhoto: UIStackView!
    @IBOutlet weak var btnAddPhoto: CButton!
    @IBOutlet weak var btnCommentRegi: CButton!
    
    
    func configurationData(_ data: [String:Any]?) {
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 320, height: collectionView.bounds.height)
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.collectionViewLayout = layout
        
        collectionView.reloadData()
        
    }
    
}

extension TalkDetailHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpertImgColCell", for: indexPath) as! ExpertImgColCell
        
        
        cell.configurationData(type: .talkDetail, "sample")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
