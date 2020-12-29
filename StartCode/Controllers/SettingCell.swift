//
//  SettingCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/17.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnNoticeCnt: CButton!
    @IBOutlet weak var btnPush: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
