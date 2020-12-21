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
    @IBOutlet weak var heightImage: NSLayoutConstraint!
    var didCloureActions:((_ actionIndex:Int)->())? {
        didSet {
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configurationData(_ data: [String:Any]?) {
        ivThumb.image = nil
        lbTitle.text = ""
        lbDate.text = ""
        btnState.isHidden = true
        ivThumb.isHidden = true
        guard let data = data else {
            return
        }
        
        if let post_title = data["post_title"] as? String {
            lbTitle.text = post_title
        }
        if let post_datetime = data["post_datetime"] as? String {
            let df = CDateFormatter.init()
            df.dateFormat = "yyyy-MM-dd HH.mm.ss"
            if let date = df.date(from: post_datetime) {
                df.dateFormat = "yyyy.MM.dd HH.mm"
                lbDate.text = df.string(from: date)
            }
        }
        if let post_category = data["post_category"] as? String, post_category.isEmpty == false {
            btnState.setTitle(post_category, for: .normal)
            btnState.isHidden = false
        }
        if let thumb_url = data["thumb_url"] as? String {
            ivThumb.isHidden = false
            let userInfo:[String : Any] = ["targetView":ivThumb]
           
            ImageCache.downLoadImg(url: thumb_url, userInfo: userInfo) { (result, userInfo) in
                guard let image = result as? UIImage, let userInfo = userInfo as? [String:Any] else {
                    return
                }
                guard let targetView = userInfo["targetView"] as? UIImageView else {
                    return
                }
                targetView.image = image
                let height:CGFloat = (targetView.bounds.width * image.size.height)/image.size.width
                self.heightImage.constant = height
                
            }
        }
    }
}
