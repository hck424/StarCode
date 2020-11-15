//
//  CTextField.swift
//  PetChart
//
//  Created by 김학철 on 2020/09/27.
//

import UIKit
@IBDesignable class CTextField: UITextField {
    var subLayer: CALayer?
    
    @IBInspectable var insetTB :CGFloat = 0.0 {
        didSet {
            if insetTB > 0 { setNeedsLayout() }
        }
    }
    @IBInspectable var insetLR :CGFloat = 0.0 {
        didSet {
            if insetLR > 0 { setNeedsLayout() }
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            if borderWidth > 0 { setNeedsLayout() }
        }
    }
    @IBInspectable var borderBottom: Bool = false {
        didSet {
            if borderBottom == true { setNeedsDisplay() }
        }
    }
    @IBInspectable var borderAll:Bool = false {
        didSet {
            if borderAll == true { setNeedsDisplay() }
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            if borderColor != nil { setNeedsLayout() }
        }
    }
    @IBInspectable var halfCornerRadius:Bool = false {
        didSet {
            if halfCornerRadius { setNeedsLayout() }
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            if cornerRadius > 0 { setNeedsLayout() }
        }
    }
    @IBInspectable var  colorPlaceHolder: UIColor? {
        didSet {
            if colorPlaceHolder != nil { setNeedsLayout() }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.autocorrectionType = UITextAutocorrectionType.no
        self.borderStyle = UITextField.BorderStyle.none
        
        if borderBottom && borderWidth > 0 && borderColor != nil {
            layer.masksToBounds = true
            if subLayer != nil {
                subLayer?.removeFromSuperlayer()
            }
            subLayer = CALayer.init()
            subLayer?.backgroundColor = borderColor?.cgColor
            subLayer?.frame = CGRect(x: 0, y: self.bounds.height - borderWidth, width: self.bounds.width, height: borderWidth)
            layer.addSublayer(subLayer!)
        }
        else if borderAll && borderWidth > 0 && borderColor != nil {
            layer.borderWidth = borderWidth
            layer.borderColor = borderColor?.cgColor
        }
        
        if halfCornerRadius {
            clipsToBounds = true
            layer.cornerRadius = self.bounds.height/2
        }
        else if cornerRadius > 0 {
            clipsToBounds = true
            layer.cornerRadius = cornerRadius
        }
        
        if colorPlaceHolder != nil && placeholder != nil {
            let attr = NSAttributedString.init(string: placeholder!, attributes: [NSAttributedString.Key.foregroundColor : colorPlaceHolder!])
            attributedText = attr
        }
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: insetTB, left: insetLR, bottom: insetTB, right: insetLR))
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: insetTB, left: insetLR, bottom: insetTB, right: insetLR))
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        if action == #selector(paste(_ :)) {
//
//        }
        return super.canPerformAction(action, withSender: sender)
    }
}
