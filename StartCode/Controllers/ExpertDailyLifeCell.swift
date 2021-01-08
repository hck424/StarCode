//
//  ExpertDailyLifeCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/15.
//

import UIKit

class ExpertDailyLifeCell: UITableViewCell {

    @IBOutlet weak var ivThumb: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbCommentCnt: UILabel!
    
    var data:[String:Any] = [:]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ivThumb.layer.cornerRadius = 16
        ivThumb.clipsToBounds = true
        ivThumb.layer.borderWidth = 1
        
        
        ivProfile.layer.cornerRadius = ivProfile.bounds.height/2
        ivProfile.clipsToBounds = true
        ivProfile.layer.borderWidth = 0.5
        ivProfile.layer.borderColor = RGB(236, 236, 236).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configurationData(_ data:Any?) {
        guard let data = data as? [String:Any] else {
            return
        }
        self.data = data
        ivThumb.image = nil
        lbTitle.text = nil
        ivProfile.image = nil
        lbName.text = nil
        lbDate.text = nil
        lbCommentCnt.text = "0"
        
        ivThumb.layer.borderColor = RGB(236, 236, 236).cgColor
        ivProfile.layer.borderColor = RGB(236, 236, 236).cgColor
        if let thumb_url = data["thumb_url"] as? String, thumb_url.isEmpty == false {
            ivThumb.setImageCache(url: thumb_url, placeholderImgName: nil)
            ivThumb.layer.borderColor = UIColor.clear.cgColor
        }
        
        if let post_title = data["post_title"] as? String {
            lbTitle.text = post_title
        }
        
        if let mem_nickname = data["mem_nickname"] as? String {
            lbName.text = mem_nickname
        }
        if let mem_icon = data["mem_icon"] as? String, mem_icon.isEmpty == false {
            ivProfile.setImageCache(url: mem_icon, placeholderImgName: nil)
            ivProfile.layer.borderColor = UIColor.clear.cgColor
        }
        
        if let post_updated_datetime = data["post_updated_datetime"] as? String {
            let df = CDateFormatter.init()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = df.date(from: post_updated_datetime) {
                df.dateFormat = "yyyy.MM.dd HH:mm"
                let dateStr = df.string(for: date)
                lbDate.text = dateStr
            }
        }
        
        if let post_comment_count = data["post_comment_count"] {
            let commentStr = "\(post_comment_count)".addComma()
            lbCommentCnt.text = commentStr
        }
        if let mem_photo = data["mem_photo"] as? String, mem_photo.isEmpty == false {
            ivProfile.setImageCache(url: mem_photo, placeholderImgName: nil)
        }
     }
}
