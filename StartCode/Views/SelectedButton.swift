//
//  SelectedButton.swift
//  PetChart
//
//  Created by 김학철 on 2020/10/01.
//

import UIKit

class SelectedButton: UIButton {
    var data:Any? = nil
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            if cornerRadius > 0 { setNeedsLayout()}
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            if borderWidth > 0 { setNeedsLayout()}
        }
    }
    @IBInspectable var tl: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var tr: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var bl: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var br: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var selBorderColor: UIColor = UIColor.clear {
        didSet {
            setNeedsLayout()
        }
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.isSelected {
            self.layer.borderColor = selBorderColor.cgColor
            self.layer.borderWidth = borderWidth
            self.layer.cornerRadius = cornerRadius
            self.layer.maskedCorners = CACornerMask(TL: tl, TR: tr, BL: bl, BR: br)
        }
        else {
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = borderWidth
            self.layer.cornerRadius = cornerRadius
            self.layer.maskedCorners = CACornerMask(TL: tl, TR: tr, BL: bl, BR: br)
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.decorationNormalBtn()
    }
    override var isSelected: Bool {
        didSet {
            if isSelected {
                decorationSelectedBtn()
            }
            else {
                decorationNormalBtn()
            }
        }
    }
    func decorationSelectedBtn() {
        
        self.setTitleColor(selBorderColor, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: (self.titleLabel?.font.pointSize)!, weight: .bold)
        setNeedsLayout()
    }
    func decorationNormalBtn() {
        self.setTitleColor(RGB(155, 155, 155), for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: (self.titleLabel?.font.pointSize)!, weight: .regular)
        setNeedsLayout()
    }
}
