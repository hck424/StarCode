//
//  HomeSectionView.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/16.
//

import UIKit

class HomeSectionView: UIView {

    @IBOutlet weak var btnTitle: UIButton!
    var section = 0
    var didSelectedClosure:((_ index:Int) -> Void)?
    @IBAction func onClickedBtnAction(_ sender: UIButton) {
        didSelectedClosure?(section)
    }
}
