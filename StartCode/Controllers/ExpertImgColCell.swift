//
//  ExpertImgColCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/18.
//

import UIKit
enum ExpertImgCellType {
    case expertDetail, talkDetail
}
class ExpertImgColCell: UICollectionViewCell {

    @IBOutlet weak var ivThumb: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configurationData(type: ExpertImgCellType, _ url: String) {
        if type == .expertDetail {
            ivThumb.layer.cornerRadius = 16
        }
        ivThumb.image = UIImage(named: url)
    }
}
