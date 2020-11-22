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
        
        if type == .notice {
            btnState.isHidden = true
        }
        else if type == .contactus {
            btnState.isHidden = false
        }
    }
}
