//
//  PopularPostCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/15.
//

import UIKit

class PopularPostCell: UITableViewCell {
    @IBOutlet weak var btnBest: CButton!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var heightTitle: NSLayoutConstraint!
    
    var data:[String:Any] = [:]
    var didSelectedClosure:((_ selData: [String:Any]?, _ actionIndex:Int) ->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configurationData(_ data: [String:Any]) {
        self.data = data
        
        lbTitle.text = ""
        if let title = data["post_title"] as? String {
            lbTitle.text = title
        }
        let height = lbTitle.sizeThatFits(CGSize(width: lbTitle.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
        heightTitle.constant = height
    }
}
