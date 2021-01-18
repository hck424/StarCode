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
    @IBOutlet weak var btnModify: CButton!
    @IBOutlet weak var btnDelete: CButton!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var heightConetnt: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib.init(nibName: "ExpertImgColCell", bundle: nil), forCellWithReuseIdentifier: "ExpertImgColCell")
        }
    }
    
    @IBOutlet weak var btnScript: UIButton!
    @IBOutlet weak var btnWarning: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    var arrFile:Array<[String:Any]> = []
    
    var didClickedActionClosure:((_ action:ActionType) -> Void)?
    func configurationData(_ data: [String:Any]?, completion:@escaping()->Void) {
        lbTitle.text = ""
        lbDate.text = ""
        lbCategory.text = ""
        lbContent.text = ""
        
        guard let data = data else {
            return
        }
        
        if let post_title = data["post_title"] as? String {
            lbTitle.text = post_title
        }
        if let post_category = data["post_category"] as? String {
            lbCategory.text = post_category
        }
        if let post_datetime = data["post_datetime"] as? String {
            let df = CDateFormatter.init()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = df.date(from: post_datetime) {
                df.dateFormat = "yyyy.MM.dd HH.mm.ss"
                lbDate.text = df.string(from: date)
            }
        }
        
        if let post_content = data["post_content"] as? String {
            lbContent.text = post_content
            let height = lbContent.sizeThatFits(CGSize(width: lbContent.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
            heightConetnt.constant = height
        }
        
        btnWarning.isHidden = false
        btnModify.isHidden = true
        btnDelete.isHidden = true
        btnLike.isHidden = false
        if let mem_id = data["mem_id"] as? String {
            if mem_id == SharedData.instance.memId {
                btnWarning.isHidden = true
                btnModify.isHidden = false
                btnDelete.isHidden = false
                btnLike.isHidden = true
            }
        }
        
        if let post_like = data["post_like"] {
            let like = "\(post_like)".addComma()
            btnLike.setTitle(like, for: .normal)
        }
        if let post_blame = data["post_blame"] {
            let blame = "\(post_blame)".addComma()
            btnWarning.setTitle(blame, for: .normal)
        }
        if let scrap_count = data["scrap_count"] {
            let scrap = "\(scrap_count)".addComma()
            btnScript.setTitle(scrap, for: .normal)
        }
        
        if let files = data["files"] as? Array<[String:Any]>, files.isEmpty == false {
            self.arrFile = files
            collectionView.isHidden = false
            collectionView.delegate = self
            collectionView.dataSource = self
            
            let layout = CustomColFlowLayout.init()
            layout.scrollDirection = .horizontal
            
            let width = collectionView.bounds.width-40
            collectionView.decelerationRate = .fast
            
            layout.itemSize = CGSize(width: width, height: width)
            layout.minimumLineSpacing = 10
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            collectionView.collectionViewLayout = layout
            layout.delegate = self
            
            collectionView.reloadData()
        }
        else {
            collectionView.isHidden = true
        }
        
        btnLike.isSelected = false
        btnScript.isSelected = false
        btnWarning.isSelected = false
        if let is_like = data["is_like"] as? Bool, is_like == true {
            btnLike.isSelected = true
        }
        if let is_scrap = data["is_scrap"] as? Bool, is_scrap == true {
            btnScript.isSelected = true
        }
        if let is_blame = data["is_blame"] as? Bool, is_blame == true {
            btnWarning.isSelected = true
        }
        completion()
    }
    
    @IBAction func onClickedBtnAction(_ sender: UIButton) {
        if sender == btnModify {
            self.didClickedActionClosure?(.modify)
        }
        else if sender == btnDelete {
            self.didClickedActionClosure?(.delete)
        }
        else if sender == btnScript {
            self.didClickedActionClosure?(.scrap)
        }
        else if sender == btnWarning {
            self.didClickedActionClosure?(.warning)
        }
        else if sender == btnLike {
            self.didClickedActionClosure?(.like)
        }
        else {
            self.didClickedActionClosure?(.none)
        }
    }
}

extension TalkDetailHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFile.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpertImgColCell", for: indexPath) as! ExpertImgColCell
        let item = arrFile[indexPath.row]
        cell.configurationData(.talkDetail, item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension TalkDetailHeaderView: CustomColFlowLayoutDelegate {
    func didEndDecelatedFloawLayout(_ indexPath: IndexPath, _ point: CGPoint) {
        
    }
}
