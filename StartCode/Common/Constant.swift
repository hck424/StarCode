//
//  Constant.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/13.
//

import Foundation
import UIKit

enum AppType {
    case user, expert
}

let baseUrl = "https://api.ohguohgu.com/api"
let akey = "5XpADsQTqF8hXqnekIKpyKamGUNdui1p"

#if Cust
let hostUrl = "/v1"
let appType:AppType = .user
#else
let hostUrl = "/a1"
let appType:AppType = .expert
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
let kPushSetting = "PushSetting"
let kPushUserData = "PushUserData"
enum SectionType {
    case button
    case makeupExport
    case popularPost
    case ad
    case exportDailyLife
    case myFaq
    case makeupDiagnosis
    case beautyQna
}


