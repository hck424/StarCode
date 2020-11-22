//
//  EventCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var ivThumb: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var btnState: CButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configurationData(_ data: [String:Any]?) {
        
    }
}
