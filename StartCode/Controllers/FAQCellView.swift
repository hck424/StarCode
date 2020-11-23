//
//  FAQCellView.swift
//  PetChart
//
//  Created by 김학철 on 2020/10/14.
//

import UIKit
class FAQCellView: UIView {
    @IBOutlet weak var btnTop: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnExpand: CButton!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    func configurationData(_ data:[String:Any]?) {
        btnExpand.data = data
        btnExpand.isSelected = false
        contentView.isHidden = true
        lbTitle.text = ""
        lbContent.text = ""
        lbContent.attributedText = nil
        
//        guard let data = data else {
//            return
//        }
        
//        if let registdata = data["update_date"] as? String {
//            let df = CDateFormatter.init()
//            df.dateFormat = "yyyy.MM.dd HH:mm:ss"
//            guard let date = df.date(from: registdata) else {
//                return
//            }
//            df.dateFormat = "yyyy.MM.dd"
//            let strDate = df.string(from: date)
//        }
        lbTitle.text = "자주하는질문 FAQ 타이틀 영역입니다."
        lbContent.text = "자주하는질문 FAQ 답변 내용 영역입니다. 자주하는질문 FAQ 답변 내용 영역입니다. 자주하는질문 FAQ 답변 내용 영역입니다. 자주하는질문 FAQ 답변 내용 영역입니다."
        
//        if let title = data["title"] as? String {
//            lbTitle.text = title
//        }
//        
//        if let content = data["content"] as? String {
//            lbContent.attributedText = try? NSAttributedString.init(htmlString: content)
//        }
    }
    
    @IBAction func onClickedButtonAction(_ sender: UIButton) {
        if sender == btnExpand || sender == btnTop {
            btnExpand.isSelected = !btnExpand.isSelected
            if btnExpand.isSelected {
                contentView.isHidden = false
//                lbTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            }
            else {
                contentView.isHidden = true
//                lbTitle.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            }
        }
    }
}
