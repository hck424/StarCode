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
        
        guard let data = data else {
            return
        }
        if let faq_title = data["faq_title"] as? String {
            lbTitle.text = faq_title
        }
//        if let faq_datetime = data["faq_datetime"] as? String {
//
//        }
        if let faq_content = data["faq_content"] as? String {
            do {
                let attr = try NSMutableAttributedString.init(htmlString: faq_content)
                attr.addAttribute(.font, value: UIFont.systemFont(ofSize: lbContent.font.pointSize, weight: .regular), range: NSMakeRange(0, attr.string.length))
                lbContent.attributedText = attr
                lbContent.textAlignment = NSTextAlignment.justified
            }
            catch {
                
            }
            
        }
    }
    
    @IBAction func onClickedButtonAction(_ sender: UIButton) {
        if sender == btnExpand || sender == btnTop {
            btnExpand.isSelected = !btnExpand.isSelected
            if btnExpand.isSelected {
                contentView.isHidden = false
            }
            else {
                contentView.isHidden = true
            }
        }
    }
}
