//
//  NoticeCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit
enum NoticeCellType {
    case notice, contactus
}
class NoticeCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var btnState: CButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configutaitonData(_ type: NoticeCellType, _ data: [String:Any]?) {
        lbTitle.text = ""
        lbDate.text = ""
        btnState.isHidden = true
        
        guard let data = data else {
            return
        }
        
        if type == .notice {
            if let post_title = data["post_title"] as? String {
                lbTitle.text = post_title
            }
            if let post_datetime = data["post_datetime"] as? String {
                let df = CDateFormatter.init()
                df.dateFormat = "yyyy-MM-dd HH.mm.ss"
                if let date = df.date(from: post_datetime) {
                    df.dateFormat = "yyyy.MM.dd HH.mm"
                    lbDate.text = df.string(from: date)
                }
            }
        }
        else if type == .contactus {
            if let post_title = data["post_title"] as? String {
                lbTitle.text = post_title
            }
            if let post_datetime = data["post_datetime"] as? String {
                let df = CDateFormatter.init()
                df.dateFormat = "yyyy-MM-dd HH.mm.ss"
                if let date = df.date(from: post_datetime) {
                    df.dateFormat = "yyyy.MM.dd HH.mm"
                    lbDate.text = df.string(from: date)
                }
            }
            
            if let post_category = data["post_category"] as? String {
                btnState.isHidden = false
                btnState.setTitle(post_category, for: .normal)
            }
        }
    }
}
