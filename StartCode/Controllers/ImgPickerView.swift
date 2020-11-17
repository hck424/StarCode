//
//  ImgPickerView.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/16.
//

import UIKit

class ImgPickerView: UIView {
    @IBOutlet weak var ivThumb: UIImageView!
    @IBOutlet weak var btnDel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
        self.layer.borderColor = RGB(239, 239, 239).cgColor
        self.layer.borderWidth = 1.0
    }

    @IBAction func onClickedBtnActions(_ sender: Any) {
        self.removeFromSuperview()
    }
}
