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
    @IBOutlet weak var svContent: UIStackView!
    @IBOutlet weak var lbContent: UILabel!
    
    var data:[String:Any] = [:]
    var qnaType:QnaType = .oneToQna
    var viewType:MyQnaViewType = .question
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgItemView.isHidden = true
    }
    func configurationData(_ data:[String:Any], _ viewType:MyQnaViewType, _ qnaType:QnaType) {
        self.data = data
        self.viewType = viewType
        self.qnaType = qnaType
        
        bgItemView.isHidden = true
        ivThumb.image = nil
        svContent.isHidden = true
        
        if viewType == .question {
            if let pfi_filename = data["pfi_filename"] as? String {
                ivThumb.setImageCache(url: pfi_filename, placeholderImgName: nil)
            }
        }
        else {
            if qnaType == .makeupQna {
                bgItemView.isHidden = false
                bgItemView.layer.cornerRadius = 8.0
                bgItemView.layer.maskedCorners = CACornerMask(TL: true, TR: true, BL: false, BR: false)
                lbItem.text = ""
                if let title = data["title"] as? String {
                    lbItem.text = title
                }
                
                ivThumb.image = nil
                if let thumb_url = data["thumb_url"] as? String {
                    ivThumb.setImageCache(url: thumb_url, placeholderImgName: nil)
                }

                if let star = data["star"] as? String, let starCnt:Int = Int(star) {
                    var i = 0
                    for ivStar in arrIvStar {
                        if i < starCnt {
                            ivStar.image = UIImage(named: "ic_grade_star_m")
                        }
                        else {
                            ivStar.image = UIImage(named: "ic_grade_star_m_off")
                        }
                        i += 1
                    }
                }
                
                if let content = data["content"] as? String, content.isEmpty == false {
                    svContent.isHidden = false
                    lbContent.text = content
                }
            }
            else {
                if let pfi_filename = data["cfi_filename"] as? String {
                    ivThumb.setImageCache(url: pfi_filename, placeholderImgName: nil)
                }
            }
        }
    }
}
