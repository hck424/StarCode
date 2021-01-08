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

    func configurationData(_ type:QnaType, _ data:[String:Any]) {
        
        ivThumb.image = nil
        lbName.text = ""
        lbHartCnt.text = "0"
        btnExpertType.isHidden = true
        ivThumb.layer.cornerRadius = 20
//        ivThumb.layer.borderColor = RGB(221, 221, 221).cgColor
//        ivThumb.layer.borderWidth = 1.0
        
        if let thumb_url = data["thumb_url"] as? String {
            ivThumb.setImageCache(url: thumb_url, placeholderImgName: nil)
        }
        if let post_nickname = data["post_nickname"] as? String {
            lbName.text = post_nickname
        }
        if let post_like = data["post_like"] {
            lbHartCnt.text = "\(post_like)"
        }
        if type == .beautyQna {
            if let arrTag = data["tag"] as? Array<[String:Any]>, arrTag.isEmpty == false {
                var result = ""
                for i in 0..<arrTag.count {
                    let tag = arrTag[i]
                    if let pta_tag = tag["pta_tag"] as? String {
                        if i == 0 {
                            result.append(pta_tag)
                        }
                        else {
                            result.append(", \(pta_tag)")
                        }
                    }
                }
                
                if result.isEmpty == false {
                    btnExpertType.isHidden = false
                    btnExpertType.setTitle(result, for: .normal)
                    btnExpertType.backgroundColor = RGB(255, 112, 166)
                }
            }
        }
        else {
            if let post_tag = data["post_tag"] as? String {
                btnExpertType.isHidden = false
                btnExpertType.setTitle(post_tag, for: .normal)
                
                if post_tag == "아티스트" {
                    btnExpertType.backgroundColor = RGB(212, 3, 156)
                }
                else {
                    btnExpertType.backgroundColor = RGB(245, 85, 111)
                }
            }
        }
        
        if let post_answer_compdate = data["post_answer_compdate"] as? String {
            let k = 0
        }
    }
}
