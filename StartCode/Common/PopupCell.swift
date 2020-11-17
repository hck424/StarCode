//
//  PopupCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/16.
//

import UIKit

class PopupCell: UITableViewCell {

    @IBOutlet weak var svContent: UIStackView!
    @IBOutlet weak var lbTitle: UILabel!
    var margin:UIEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        svContent.isLayoutMarginsRelativeArrangement = true
        svContent.layoutMargins = margin
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
