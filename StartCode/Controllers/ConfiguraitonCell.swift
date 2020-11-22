//
//  ConfiguraitonCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class ConfiguraitonCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnToggle: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
