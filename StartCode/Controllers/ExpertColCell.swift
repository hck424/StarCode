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
    
    var data:[String:Any]?
    var didSelectedClosure:((_ selData: [String:Any]?, _ actionIndex:Int) ->())?
    override func awakeFromNib() {
        super.awakeFromNib()
//        let selectedBgView = UIView.init()
//        selectedBgView.backgroundColor = RGBA(139, 0, 255, 0.5)
//        self.selectedBackgroundView = selectedBgView
    }

    func configurationData(_ data:[String:Any]?) {
        self.data = data
        
        //"mem_blog_url" = "";
        //"mem_facebook_url" = "";
        //"mem_heart" = 0;
        //"mem_homepage" = "";
        //"mem_id" = 36;
        //"mem_instagram_url" = "";
        //"mem_manager_type" = "\Uc544\Ud2f0\Uc2a4\Ud2b8";
        //"mem_nickname" = "\Uc804\Ubb38\Uac0027";
        //"mem_star" = 0;
        //"mem_username" = "\Ud64d\Uae38\Ub3d927";
        //"mem_youtube_url" = "";
        //num = 3;
        //"thumb_url" = "https://api.ohguohgu.com/uploads/cache/users/sample/thumb-user_27_320x0.png";
        
        ivProfile.image = nil
        lbName.text = ""
        btnMark.isHidden = true
        lbCountStar.text = "0"
        ivProfile.layer.cornerRadius = ivProfile.bounds.height/2
        ivProfile.clipsToBounds = true
        btnMark.setTitle("", for: .normal)
        
        guard let data = data else {
            return
        }
        
        if let thumb_url = data["thumb_url"] as? String {
            ivProfile.setImageCache(url: thumb_url, placeholderImgName: nil)
        }
        
        if let mem_manager_type = data["mem_manager_type"] as? String {
            btnMark.isHidden = false
            if mem_manager_type == "셀럽" {
                btnMark.setTitle(mem_manager_type, for: .normal)
                btnMark.backgroundColor = colorCeleb
            }
            else {
                btnMark.setTitle(mem_manager_type, for: .normal)
                btnMark.backgroundColor = colorArtist
            }
        }
        
        if let mem_nickname = data["mem_nickname"] as? String {
            lbName.text = mem_nickname
        }
        if let mem_star = data["mem_star"] as? String {
            let starCntStr = "\(mem_star)".addComma()
            lbCountStar.text = starCntStr
        }
        else if let mem_star = data["mem_star"] as? NSNumber {
            let starCntStr = "\(mem_star)".addComma()
            lbCountStar.text = starCntStr
        }
    }
}
