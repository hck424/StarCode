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
        
        if let thumb_url = data["thumb_url"] as? String {
            ivThumb.setImageCache(url: thumb_url, placeholderImgName: nil)
        }
        if let ban_title = data["ban_title"] as? String {
            lbTitle.text = ban_title
        }
        if let sub = data["content"] as? String {
            lbSubTitle.text = sub
        }
    }
}
