//
//  QuestionColCell.swift
//  StartCodePro
//
//  Created by 김학철 on 2020/12/24.
//

import UIKit

class QuestionColCell: UICollectionViewCell {

    @IBOutlet weak var btnExpertType: CButton!
    @IBOutlet weak var ivThumb: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbHartCnt: UILabel!
    
    let colorArtist = RGB(212, 3, 156)
    let colorCeleb = RGB(245, 85, 111)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configurationData(_ data:[String:Any]) {
        
        ivThumb.image = nil
        lbName.text = ""
        lbHartCnt.text = "0"
        btnExpertType.isHidden = true
        ivThumb.layer.cornerRadius = 20
        
        if let thumb_url = data["thumb_url"] as? String {
            ivThumb.setImageCache(url: thumb_url, placeholderImgName: nil)
        }
        
        if let post_nickname = data["post_nickname"] as? String {
            lbName.text = post_nickname
        }
        if let post_like = data["post_like"] {
            lbHartCnt.text = "\(post_like)"
        }
    }
}
