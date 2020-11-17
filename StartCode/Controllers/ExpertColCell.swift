//
//  ExpertColCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/15.
//

import UIKit

class ExpertColCell: UICollectionViewCell {

    @IBOutlet weak var contentBgView: UIView!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var btnMark: CButton!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCountStar: UILabel!
    
    
    let colorArtist = RGB(212, 3, 156)
    let colorCeleb = RGB(245, 85, 111)
    
    var data:[String:Any] = [:]
    var didSelectedClosure:((_ selData: [String:Any]?, _ actionIndex:Int) ->())?
    override func awakeFromNib() {
        super.awakeFromNib()
//        let selectedBgView = UIView.init()
//        selectedBgView.backgroundColor = RGBA(139, 0, 255, 0.5)
//        self.selectedBackgroundView = selectedBgView
    }

    func configurationData(_ data:[String:Any]) {
        self.data = data
        
        ivProfile.layer.cornerRadius = ivProfile.bounds.height/2
        ivProfile.clipsToBounds = true
        ivProfile.image = UIImage(named: "img_star_thumb")
        btnMark.backgroundColor = colorArtist
        
    }
}
