//
//  ChuPurchaseBtn.swift
//  StartCode
//
//  Created by 김학철 on 2020/12/03.
//

import UIKit

class ChuPurchaseBtn: CButton {

    @IBOutlet weak var lbChuCnt: UILabel!
    @IBOutlet weak var lbChuBonus: UILabel!
    @IBOutlet weak var lbMoney: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    let colorBorderNor = RGB(221, 221, 221)
    let colorBorderSel = RGB(128, 0, 255)
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.decorationUi(isSelected)
            }
            else {
                self.decorationUi(isSelected)
            }
        }
    }
    
    func decorationUi(_ isSelected:Bool) {
        if isSelected {
            self.borderWidth = 1.0
            self.cornerRadius = 8.0
            self.borderColor = colorBorderSel
            lbMoney.font = UIFont.systemFont(ofSize: lbMoney.font.pointSize, weight: .bold)
            lbMoney.textColor = colorBorderSel
        }
        else {
            self.borderWidth = 1.0
            self.cornerRadius = 8.0
            self.borderColor = colorBorderNor
            lbMoney.font = UIFont.systemFont(ofSize: lbMoney.font.pointSize, weight: .regular)
            lbMoney.textColor = UIColor.label
        }
    }
    func configurationData(_ data:[String:Any]) {
        
        self.data = data
        lbChuCnt.text = ""
        lbChuBonus.text = ""
        lbMoney.text = "0원"
        
        if let p_price = data["p_price"] as? String {
            lbMoney.text = "\(p_price.addComma())원"
        }
        
        if let p_summary = data["p_summary"] as? String {
            do {
                let attr = try NSAttributedString.init(htmlString: p_summary)
                lbChuCnt.attributedText = attr
            }
            catch {
                
            }
        }
        
        self.decorationUi(false)
    }
    
}
