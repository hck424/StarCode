//
//  QnaColCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/12/20.
//

import UIKit

class QnaColCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgItemView: UIView!
    @IBOutlet weak var lbItem: UILabel!
    @IBOutlet var arrIvStar: [UIImageView]!
    @IBOutlet weak var ivThumb: UIImageView!
    var data:[String:Any] = [:]
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func configurationData(_ data:[String:Any]) {
        self.data = data
    }
}
