//
//  TalkDetailCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class TalkDetailCell: UITableViewCell {
    @IBOutlet weak var lbExpertName: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var btnModify: CButton!
    @IBOutlet weak var btnDelete: CButton!
    @IBOutlet weak var lbContent: UIStackView!
    @IBOutlet weak var photoScrollView: UIScrollView!
    @IBOutlet weak var svPhoto: UIStackView!
    @IBOutlet weak var btnWarning: UIButton!
    @IBOutlet weak var btnLikeCnt: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configurationData(_ data:[String:Any]?, _ index:Int) {
        photoScrollView.isHidden = true
        if index%2 == 0 {
            photoScrollView.isHidden = false
        }
    }
}
