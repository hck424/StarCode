//
//  CameraOverlayView.swift
//  PetChart
//
//  Created by 김학철 on 2020/10/01.
//

import UIKit
protocol CameraOverlayViewDelegate {
    func cameraOverlayViewCancelAction()
    func cameraOverlayViewShotAction()
}

@IBDesignable class CameraOverlayView: UIView {

    @IBOutlet weak var btnClose: UIButton!
    @IBInspectable @IBOutlet weak var btnShot: CButton!
    var delegate: CameraOverlayViewDelegate?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func onClickedButtonActions(_ sender: UIButton) {
        
        if sender == btnClose {
            delegate?.cameraOverlayViewCancelAction()
        }
        else if sender == btnShot {
            delegate?.cameraOverlayViewShotAction()
        }
    }
}
