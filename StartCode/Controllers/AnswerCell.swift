//
//  AnswerCell.swift
//  StartCodePro
//
//  Created by 김학철 on 2020/12/24.
//

import UIKit

class AnswerCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var btnAnswerState: CButton!
    @IBOutlet weak var seperatorBottom: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configuraitonData(_ data:[String:Any]) {
        lbTitle.text = ""
        lbDate.text = ""
        
        if let post_title = data["post_title"] as? String {
            lbTitle.text = post_title
        }
        
        if let post_answer_compdate = data["post_answer_compdate"] as? String {
            let df = CDateFormatter.init()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = df.date(from: post_answer_compdate) {
                df.dateFormat = "yyyy.MM.dd HH:mm:ss"
                lbDate.text = df.string(from: date)
            }
        }
        
        if let post_comment_count = data["post_comment_count"] as? String, let count = Int(post_comment_count), count > 0 {
            btnAnswerState.backgroundColor = RGB(128, 0, 255)
            btnAnswerState.setTitle("답볍", for: .normal)
        }
        else {
            btnAnswerState.backgroundColor = RGB(155, 155, 155)
            btnAnswerState.setTitle("미답볍", for: .normal)
        }
    }
    
}
