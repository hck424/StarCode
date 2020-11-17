//
//  ExpertDailyLifeCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/15.
//

import UIKit

class ExpertDailyLifeCell: UITableViewCell {
    
    @IBOutlet weak var btnCell: UIButton!
    @IBOutlet weak var ivThumb: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbCommentCnt: UILabel!
    
    var data:[String:Any] = [:]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configurationData(_ data:[String:Any]) {
        self.data = data
        
    }
}
