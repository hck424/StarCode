//
//  PhotoView.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/16.
//

import UIKit
import Photos
protocol ImgPickerViewDelegate {
    func didClickDelAction(object: Any?)
}
class PhotoView: UIView {
    @IBOutlet weak var ivThumb: UIImageView!
    @IBOutlet weak var btnDel: UIButton!
    var asset: PHAsset?
    var delegate: ImgPickerViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
        self.layer.borderColor = RGB(239, 239, 239).cgColor
        self.layer.borderWidth = 1.0
    }
    func decoration() {
        guard let asset = asset else {
            return
        }
        
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: PHImageRequestOptions()) { (result, _) in
            guard let result = result else {
                return
            }
            self.ivThumb.image = result
            
        }
    }
    @IBAction func onClickedBtnActions(_ sender: Any) {
        delegate?.didClickDelAction(object: self)
    }
}
