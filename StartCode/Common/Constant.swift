//
//  Constant.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/13.
//

import Foundation
import UIKit
#if Cust
let baseUrl = "Dev base url"
#else
let baseUrl = "Pro base url"
#endif


public func RGB(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
    UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
}
public func RGBA(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
    UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a / 1.0)
}
let ColorAppDefault = RGB(139, 0, 255)

let IsShowTutorial = "IsShowTutorial"
let kJoinType = "JoinType"
let kUserId = "UserId"