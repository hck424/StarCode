//
//  MyQnaCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit
enum MyQnaCellType {
//    type1:나의문의내역(1:1, ai), type2:내문의내역(메이크업진단, 뷰티질문)
    case type1, type2
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
        lbCommentCnt.text = "0"
        guard let data = data else {
            return
        }
        if type == .type1 {
            btnAnswer.isHidden = false
            
            if let post_title = data["post_title"] as? String {
                lbTitle.text = post_title
            }
            
            if let post_category = data["post_category"] as? String {
                lbSubTitle.text = post_category
            }
            
            if let post_datetime = data["post_datetime"] as? String {
                let df = CDateFormatter.init()
                df.dateFormat = "yyyy-MM-dd HH.mm.ss"
                if let date = df.date(from: post_datetime) {
                    df.dateFormat = "yy.MM.dd HH.mm"
                    lbDate.text = df.string(from: date)
                }
            }
            if let post_comment_count = data["post_comment_count"] {
                let comentCnt = "\(post_comment_count)".addComma()
                lbCommentCnt.text = comentCnt
            }
            
            if let post_reply = data["post_reply"] as? String, post_reply.isEmpty == false {
                btnAnswer.backgroundColor = RGB(128, 0, 255)
                btnAnswer.setTitle("답볍", for: .normal)
            }
            else {
                btnAnswer.backgroundColor = RGB(155, 155, 155)
                btnAnswer.setTitle("미답볍", for: .normal)
            }
        }
        else if type == .type2 {
            ivThumb.isHidden = false
            btnAnswer2.isHidden = false
            ivThumb.image = nil
            if let post_title = data["post_title"] as? String {
                lbTitle.text = post_title
            }
           
            if let post_datetime = data["post_datetime"] as? String {
                let df = CDateFormatter.init()
                df.dateFormat = "yyyy-MM-dd HH.mm.ss"
                if let date = df.date(from: post_datetime) {
                    df.dateFormat = "yy.MM.dd HH.mm"
                    lbDate.text = df.string(from: date)
                }
            }
            
            if let thumb_url = data["thumb_url"] as? String {
                ivThumb.setImageCache(url: thumb_url, placeholderImgName: nil)
            }
            
            if let post_reply = data["post_reply"] as? String, post_reply.isEmpty == false {
                btnAnswer2.backgroundColor = RGB(128, 0, 255)
                btnAnswer2.setTitle("답볍", for: .normal)
            }
            else {
                btnAnswer2.backgroundColor = RGB(155, 155, 155)
                btnAnswer2.setTitle("미답볍", for: .normal)
            }
        }
    }
}
