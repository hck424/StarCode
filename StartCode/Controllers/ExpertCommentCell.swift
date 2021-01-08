//
//  ExpertCommentCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/18.
//

import UIKit

class ExpertCommentCell: UITableViewCell {

    @IBOutlet weak var lbNickName: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet var arrStar: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        arrStar = arrStar.sorted(by: { (obj1, obj2) -> Bool in
            return obj1.tag < obj2.tag
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configurationData(_ data:Any?) {
        
        lbNickName.text = ""
        lbDate.text = ""
        lbContent.text = ""
        
        guard let data = data as? [String:Any] else {
            return
        }
        
        if let mr_write_mem_nickname = data["mr_write_mem_nickname"] as? String {
            lbNickName.text = mr_write_mem_nickname
        }
        if let mr_cdate = data["mr_cdate"] as? String {
            let df = CDateFormatter.init()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = df.date(from: mr_cdate) {
                df.dateFormat = "yyyy.MM.dd HH.mm.ss"
                lbDate.text = df.string(from: date)
            }
        }
        if let mem_review = data["mem_review"] as? String {
            lbContent.text = mem_review
        }
        if let mem_star = data["mem_star"] as? String, let intStar = Int(mem_star) {
            var i = 0
            for ivStart in arrStar {
                if i < intStar {
                    ivStart.image = UIImage(named: "ic_grade_star_m")
                }
                else {
                    ivStart.image = UIImage(named: "ic_grade_star_m_off")
                }
                i += 1
            }
        }
    }
}
