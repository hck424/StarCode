//
//  CSlider.swift
//  StartCode
//
//  Created by 김학철 on 2020/12/30.
//

import UIKit

class CSlider: UISlider {
    @IBInspectable var trackHeight: CGFloat = 2
    
    override func draw(_ rect: CGRect) {
        
    }
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: trackHeight))
    }
}
