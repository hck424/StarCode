//
//  QnaColCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/12/20.
//

import UIKit

class QnaColCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgItemView: UIView!
    @IBOutlet weak var lbItem: UILabel!
    @IBOutlet var arrIvStar: [UIImageView]!
    @IBOutlet weak var ivThumb: UIImageView!
    var data:[String:Any] = [:]
    var type:MyQnaViewType = .question
    override func awakeFromNib() {
        super.awakeFromNib()
        bgItemView.isHidden = true
    }
    func configurationData(_ data:[String:Any], _ type:MyQnaViewType) {
        self.data = data
        self.type = type
        
        bgItemView.isHidden = true
        if type == .question {
            
        }
        else {
            bgItemView.isHidden = false
            bgItemView.layer.cornerRadius = 8.0
            bgItemView.layer.maskedCorners = CACornerMask(TL: true, TR: true, BL: false, BR: false)
        }
        ivThumb.image = nil
        
        if let pfi_filename = data["pfi_filename"] as? String {
            ivThumb.setImageCache(url: pfi_filename, placeholderImgName: nil)
        }
    }
}
