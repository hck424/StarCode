//
//  BannerCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/15.
//

import UIKit

class BannerCell: UICollectionViewCell {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var ivThumb: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    var data:[String:Any] = [:]

    override func awakeFromNib() {
        super.awakeFromNib()
        ivThumb.layer.cornerRadius = 20.0
        ivThumb.clipsToBounds = true
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.shadowView.backgroundColor = UIColor.clear
        
        self.shadowView.layer.shadowColor = RGBA(0, 0, 0, 0.3).cgColor
        self.shadowView.layer.shadowRadius = 3
        self.shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.shadowView.layer.shadowOpacity = 0.75
        self.shadowView.layer.shadowOffset = .zero
        
    }

    func configurationData(_ data: [String:Any]) {
        self.data = data
        
        ivThumb.image = nil
        lbTitle.text = nil
        lbSubTitle.text = nil
        
        if let url = data["img_url"] as? String {
            ivThumb.image = UIImage(named: url)
        }
        if let title = data["title"] as? String {
            lbTitle.text = title
        }
        if let sub = data["content"] as? String {
            lbSubTitle.text = sub
        }
    }
}
