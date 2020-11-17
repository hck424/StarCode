//
//  ButtonCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/16.
//

import UIKit

class ButtonCell: UITableViewCell {

    @IBOutlet weak var ivThumb: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    @IBOutlet weak var ivArrow: UIImageView!
    var didSelectedClosure:((_ selData: [String:Any]?, _ actionIndex:Int) ->())?
    var data:[String:Any]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configurationData( _ data: [String:Any]?) {
        self.data = data
        guard let data = self.data else {
            return
        }
        
        lbTitle.text = ""
        lbSubTitle.text = ""
        ivThumb.image = nil
        ivArrow.isHidden = false
        if let title = data["title"] as? String {
            lbTitle.text = title
        }
        
        if let subTitle = data["sub_title"] as? String {
            lbSubTitle.text = subTitle
        }
        if let imgName = data["image_name"] as? String {
            ivThumb.image = UIImage(named: imgName)
        }
        
    }
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        self.didSelectedClosure?(self.data, 0)
    }
}
