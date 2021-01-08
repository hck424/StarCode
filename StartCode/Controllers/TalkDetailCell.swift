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
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var photoScrollView: UIScrollView!
    @IBOutlet weak var svPhoto: UIStackView!
    @IBOutlet weak var btnWarning: UIButton!
    @IBOutlet weak var btnLikeCnt: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    
    var didActionClosure:((_ selData:[String:Any]?, _ action:ActionType) ->Void)?
    var data:[String:Any] = [:]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configurationData(_ data:[String:Any]) {
        self.data = data
        btnModify.isHidden = true
        btnDelete.isHidden = true
        btnWarning.isHidden = false
        btnLikeCnt.isHidden = false
        
        lbContent.text = nil
        lbExpertName.text = nil
        lbDate.text = nil
        photoScrollView.isHidden = true
        
        if let cmt_content = data["cmt_content"] as? String{
            lbContent.text = cmt_content
        }
        if let mem_id = data["mem_id"] as? String{
            if mem_id == SharedData.instance.memId {
                btnModify.isHidden = false
                btnDelete.isHidden = false
                btnLikeCnt.isHidden = true
                btnWarning.isHidden = true
                btnModify.setNeedsDisplay()
                btnDelete.setNeedsDisplay()
            }
        }
        
        if let cmt_class = data["cmt_class"] as? String, let cmt_nickname = data["cmt_nickname"] as? String {
            let result:String = "\(cmt_class) \(cmt_nickname)"
            let attr = NSMutableAttributedString.init(string: result)
            attr.addAttribute(.foregroundColor, value: RGB(150, 0, 255), range: ((result as? NSString)!.range(of: cmt_class)))
            lbExpertName.attributedText = attr
        }
        
        if let cmt_datetime = data["cmt_datetime"] as? String {
            let df = CDateFormatter.init()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = df.date(from: cmt_datetime) {
                df.dateFormat = "yyyy.MM.dd HH:mm"
                lbDate.text = df.string(from: date)
            }
        }
        if var cmt_like = data["cmt_like"] as? String {
            cmt_like = cmt_like.addComma()
            btnLikeCnt.setTitle(cmt_like, for: .normal)
        }
        if var cmt_blame = data["cmt_blame"] as? String {
            cmt_blame = cmt_blame.addComma()
            btnWarning.setTitle(cmt_blame, for: .normal)
        }
        
        guard let files = data["files"] as? [[String:Any]], files.isEmpty == false else {
            return
        }
        
        photoScrollView.isHidden = false
        for item in files {
            if let cfi_filename = item["cfi_filename"] as? String {
                let ivThumb = UIImageView.init()
                svPhoto.addArrangedSubview(ivThumb)
                ivThumb.setImageCache(url: cfi_filename, placeholderImgName: nil)
                ivThumb.translatesAutoresizingMaskIntoConstraints = false
                ivThumb.widthAnchor.constraint(equalToConstant: 200).isActive = true
                ivThumb.contentMode = .scaleAspectFill
                ivThumb.clipsToBounds = true
            }
        }
    }
    @IBAction func onClickedBtnAction(_ sender: UIButton) {
        if sender == btnModify {
            self.didActionClosure?(data, .modify)
        }
        else if sender == btnDelete {
            self.didActionClosure?(data, .delete)
        }
        else if sender == btnWarning {
            self.didActionClosure?(data, .warning)
        }
        else if sender == btnLikeCnt {
            self.didActionClosure?(data, .like)
        }
        else if sender == btnComment {
            self.didActionClosure?(data, .comment)
        }
    }
}
