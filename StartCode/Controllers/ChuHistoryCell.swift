//
//  ChuHistoryCell.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/25.
//

import UIKit

class ChuHistoryCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var btnState: CButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configurationData(_ data: [String:Any]?) {
        lbTitle.text = ""
        lbDate.text = ""
        btnState.isHidden = true
        guard let data = data else {
            return
        }
        
        if let chu_contents = data["chu_contents"] as? String {
            lbTitle.text = chu_contents
        }
        
        if let post_datetime = data["chu_cdate"] as? String {
            let df = CDateFormatter.init()
            df.dateFormat = "yyyy-MM-dd HH.mm.ss"
            if let date = df.date(from: post_datetime) {
                df.dateFormat = "yyyy.MM.dd HH.mm"
                lbDate.text = df.string(from: date)
            }
        }
        
        guard let chu_type = data["chu_type"] as? String else {
            return
        }
        
        btnState.isHidden = false
        //        PCHG => 구매
        //        ACHG => 충전
        //        ECHG => 선물
        //        AC => 회수
        //        AE => 수정
        //        UP => 사용
        //        GC => 선물
        //        TC => 예치
        //        TG => 반납
        //        TP => 지급
        var chuDisplayName = ""
        var chuColor = RGB(155, 155, 155)
        if chu_type == "PCHG" {
            chuDisplayName = "구매"
            chuColor = RGB(128, 0, 255)
        }
        else if chu_type == "ACHG" {
            chuDisplayName = "충전"
        }
        else if chu_type == "ECHG" {
            chuDisplayName = "선물"
        }
        else if chu_type == "AC" {
            chuDisplayName = "회수"
        }
        else if chu_type == "AE" {
            chuDisplayName = "수정"
        }
        else if chu_type == "UP" {
            chuDisplayName = "사용"
        }
        else if chu_type == "GC" {
            chuDisplayName = "선물"
            chuColor = RGB(231, 104, 113)
        }
        else if chu_type == "TC" {
            chuDisplayName = "예치"
        }
        else if chu_type == "TG" {
            chuDisplayName = "반납"
        }
        else if chu_type == "TP" {
            chuDisplayName = "지급"
        }
        
        if chuDisplayName.isEmpty == false {
            btnState.setTitle(chuDisplayName, for: .normal)
            btnState.backgroundColor = chuColor
        }
    }
}
