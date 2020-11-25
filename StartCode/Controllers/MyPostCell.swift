//
//  MyPostCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/25.
//

import UIKit

class MyPostCell: UITableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbCommentCnt: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configurationData(_ data:[String:Any]?) {
        guard let data = data else {
            return
        }
        
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
    }
}
