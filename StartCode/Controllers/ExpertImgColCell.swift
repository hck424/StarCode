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
    @IBOutlet weak var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configurationData(_ type: ExpertImgCellType, _ data:Any?) {
        ivThumb.image = nil
        guard let data = data else {
            return
        }
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = RGB(236, 236, 236).cgColor
        
        if type == .expertDetail {
            ivThumb.layer.cornerRadius = 16
            bgView.layer.cornerRadius = 16
            bgView.clipsToBounds = true
            
            if let data = data as? String {
                ivThumb.setImageCache(url: data, placeholderImgName: nil)
            }
        }
        else {
            if let data = data as? [String:Any], let pfi_filename = data["pfi_filename"] as? String {
                ivThumb.setImageCache(url: pfi_filename, placeholderImgName: nil)
            }
        }
    }
}
