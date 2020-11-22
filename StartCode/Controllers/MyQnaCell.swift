//
//  MyQnaCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit
enum MyQnaCellType {
    case type1, type2, type3, type4, type5, type6
}


class MyQnaCell: UITableViewCell {
    
    @IBOutlet weak var ivThumb: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnAnswer: CButton!
    @IBOutlet weak var btnAnswer2: CButton!
    @IBOutlet weak var lbCommentCnt: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    @IBOutlet weak var svComment: UIStackView!
    
    var type:MyQnaCellType = .type1
    override func awakeFromNib() {
        super.awakeFromNib()
        ivThumb.layer.cornerRadius = 16
        ivThumb.layer.borderWidth = 1.0
        ivThumb.layer.borderColor = RGB(236, 236, 236).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configurationData(_ data:[String:Any]?, _ type:MyQnaCellType, _ index:Int) {
        self.type = type
        ivThumb.isHidden = true
        btnAnswer.isHidden = true
        btnAnswer2.isHidden = true
        svComment.isHidden = true
        lbSubTitle.isHidden = true
        
        if type == .type1 {
            lbSubTitle.isHidden = false
            svComment.isHidden = false
        }
        else if type == .type2 {
            btnAnswer.isHidden = false
            
            if index%2 == 0 {
                btnAnswer.backgroundColor = RGB(128, 0, 255)
                btnAnswer.setTitle("답볍", for: .normal)
            }
            else {
                btnAnswer.backgroundColor = RGB(155, 155, 155)
                btnAnswer.setTitle("미답볍", for: .normal)
            }
        }
        else if type == .type3 {
            ivThumb.isHidden = false
            btnAnswer2.isHidden = false
            ivThumb.image = UIImage(named: "sample")
            if index%2 == 0 {
                btnAnswer2.backgroundColor = RGB(128, 0, 255)
                btnAnswer2.setTitle("답볍", for: .normal)
            }
            else {
                btnAnswer2.backgroundColor = RGB(155, 155, 155)
                btnAnswer2.setTitle("미답볍", for: .normal)
            }
        }
        else if type == .type4 {
            btnAnswer.isHidden = false
            
            if index%3 == 0 {
                btnAnswer.backgroundColor = RGB(128, 0, 255)
                btnAnswer.setTitle("구매", for: .normal)
            }
            else if index%3 == 1 {
                btnAnswer.backgroundColor = RGB(155, 155, 155)
                btnAnswer.setTitle("사용", for: .normal)
            }
            else if index%3 == 2 {
                btnAnswer.backgroundColor = RGB(231, 104, 113)
                btnAnswer.setTitle("선물", for: .normal)
            }
        }
        else if type == .type5 {
            svComment.isHidden = false
        }
        else if type == .type6 {
            ivThumb.isHidden = false
            ivThumb.image = UIImage(named: "sample")
            
        }
    }
}
