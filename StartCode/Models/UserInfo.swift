//
//  UserInfo.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/24.
//

import UIKit
import ObjectMapper
class UserInfo:  Mappable {
    //none, facebook, kakao, naver, apple, google
    var akey: String?
    var mem_device_id: String?
    var join_type: String?
    var mem_userid: String?
    var mem_password: String?
    var mem_nickname: String?
    var mem_profile_content: String?
    var mem_birthday: String?
    var mem_sex: String?
    var mem_phone: String?
    var authkey: String?
    var map_id: String?
    var mem_is_14_agree: String?
    var mem_is_termsservice_agree: String?
    var mem_is_privacy_agree: String?
    var mem_is_marketing_agree: String?
    var platform: String?
    var push_token: String?
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        akey <- map["akey"]
        mem_device_id <- map["mem_device_id"]
        join_type <- map["join_type"]
        mem_userid <- map["mem_userid"]
        mem_password <- map["mem_password"]
        mem_nickname <- map["mem_nickname"]
        mem_profile_content <- map["mem_profile_content"]
        mem_birthday <- map["mem_birthday"]
        mem_sex <- map["mem_sex"]
        mem_phone <- map["mem_phone"]
        authkey <- map["authkey"]
        map_id <- map["map_id"]
        mem_is_14_agree <- map["mem_is_14_agree"]
        mem_is_termsservice_agree <- map["mem_is_termsservice_agree"]
        mem_is_privacy_agree <- map["mem_is_privacy_agree"]
        mem_is_marketing_agree <- map["mem_is_marketing_agree"]
        platform <- map["platform"]
        push_token <- map["push_token"]
    }
    
    func description() -> String {
        var des = ""
        des.append("akey: \(akey ?? "")\n")
        des.append("mem_device_id: \(mem_device_id ?? "")\n")
        des.append("join_type: \(join_type ?? "")\n")
        des.append("mem_userid: \(mem_userid ?? "")\n")
        des.append("mem_password: \(mem_password ?? "")\n")
        des.append("mem_nickname: \(mem_nickname ?? "")\n")
        des.append("mem_profile_content: \(mem_profile_content ?? "")\n")
        des.append("mem_birthday: \(mem_birthday ?? "")\n")
        des.append("mem_sex: \(mem_sex ?? "")\n")
        des.append("mem_phone: \(mem_phone ?? "")\n")
        des.append("authkey: \(authkey ?? "")\n")
        des.append("map_id: \(map_id ?? "")\n")
        des.append("mem_is_14_agree: \(mem_is_14_agree ?? "")\n")
        des.append("mem_is_termsservice_agree: \(mem_is_termsservice_agree ?? "")\n")
        des.append("mem_is_privacy_agree: \(mem_is_privacy_agree ?? "")\n")
        des.append("mem_is_marketing_agree: \(mem_is_marketing_agree ?? "")\n")
        des.append("platform: \(platform ?? "")\n")
        des.append("push_token: \(push_token ?? "")\n")
        return des
    }
}
