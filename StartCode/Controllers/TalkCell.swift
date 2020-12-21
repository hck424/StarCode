//
//  TalkCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/17.
//

import UIKit

class TalkCell: UITableViewCell {

    @IBOutlet weak var btnMark: CButton!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbComentCnt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configurationData(_ data:[String:Any]?) {
        
        lbTitle.text = nil
        lbDate.text = nil
        lbComentCnt.text = "0"
        lbSubTitle.text = nil
        btnMark.isHidden = true
        lbSubTitle.isHidden = true
        guard let data = data  else {
            return
        }
        
        if let post_title = data["post_title"] as? String {
            lbTitle.text = post_title
        }
        if let post_category = data["post_category"] as? String {
            lbSubTitle.isHidden = false
            lbSubTitle.text = post_category
        }
        
        if let post_updated_datetime = data["post_updated_datetime"] as? String {
            let df = CDateFormatter.init()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = df.date(from: post_updated_datetime) {
                df.dateFormat = "yyyy.MM.dd HH:mm"
                lbDate.text = df.string(from: date)
            }
        }
        
        if let post_comment_count = data["post_comment_count"] as? String {
            lbComentCnt.text = post_comment_count.addComma()
        }
    }
}
