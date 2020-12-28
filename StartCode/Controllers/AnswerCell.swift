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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configuraitonData(_ data:[String:Any]) {
        
    }
    
}
