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
let hostUrl = "/v2"
let appType:AppType = .user
#else
let hostUrl = "/a2"
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
let kPushSetting = "PushSetting"
let kPushUserData = "PushUserData"
#if Cust
let kMemPassword = "CustMemPassword"
let kMemId = "CustMemId"
let kMemJoinType = "CustMemJoinType"
let kMemUserid = "CustMemUserid"
let kMemUsername = "CustMemUsername"
let kMemNickname = "CustMemNickname"
let kMemPhoto = "CustMemPhoto"
let kMemPhone = "CustMemPhone"
let kMemIcon = "CustMemIcon"
let kMemLevel = "CustMemLevel"
let kMemChu = "CustMemChu"
let kMemStar = "CustMemStar"
let kMemHeart = "CustMemHeart"
let kLang = "CustLang"
let kToken = "CustToken"
#else
let kMemPassword = "ProMemPassword"
let kMemId = "ProMemId"
let kMemJoinType = "ProMemJoinType"
let kMemUserid = "ProMemUserid"
let kMemUsername = "ProMemUsername"
let kMemNickname = "ProMemNickname"
let kMemPhoto = "ProMemPhoto"
let kMemPhone = "ProMemPhone"
let kMemIcon = "ProMemIcon"
let kMemLevel = "ProMemLevel"
let kMemChu = "ProMemChu"
let kMemStar = "ProMemStar"
let kMemHeart = "ProMemHeart"
let kLang = "ProLang"
let kToken = "ProToken"
#endif


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


