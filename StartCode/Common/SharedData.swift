//
//  SharedData.swift
//  PetChart
//
//  Created by 김학철 on 2020/10/03.
//

import UIKit
class SharedData: NSObject {
    static var instance = SharedData()
    
    var memId: String?
    var token: String?
    var memJoinType:String?
    var memUserId:String?
    var memChu:Int = 0
    var enableChangeTabMenu:Bool = false
    let categorys = ["전체", "연예인", "패션", "헤어", "픽!쳐톡", "화장법", "다이어트"]
    
    func saveUserInfo(user:[String:Any]) {
        if let mem_id = user["mem_id"] as? String {
            SharedData.instance.memId = mem_id
            SharedData.setObjectForKey(mem_id, kMemId)
        }
        if let mem_join_type = user["mem_join_type"] as? String {
            SharedData.instance.memJoinType = mem_join_type
            SharedData.setObjectForKey(mem_join_type, kMemJoinType)
        }
        if let mem_userid = user["mem_userid"] as? String {
            SharedData.instance.memUserId = mem_userid
            SharedData.setObjectForKey(mem_userid, kMemUserid)
        }
        if let mem_username = user["mem_username"] as? String {
            SharedData.setObjectForKey(mem_username, kMemUsername)
        }
        if let mem_nickname = user["mem_nickname"] as? String {
            SharedData.setObjectForKey(mem_nickname, kMemNickname)
        }
        if let mem_photo = user["mem_photo"] as? String {
            SharedData.setObjectForKey(mem_photo, kMemPhoto)
        }
        if let mem_phone = user["mem_phone"] as? String {
            SharedData.setObjectForKey(mem_phone, kMemPhone)
        }
        if let mem_icon = user["mem_icon"] as? String {
            SharedData.setObjectForKey(mem_icon, kMemIcon)
        }
        if let mem_level = user["mem_level"] as? String {
            SharedData.setObjectForKey(mem_level, kMemLevel)
        }
        if let mem_chu = user["mem_chu"] as? String, let intChu = Int(mem_chu) {
            SharedData.setObjectForKey(intChu, kMemChu)
            SharedData.instance.memChu = intChu
        }
        else if let mem_chu = user["mem_chu"] as? Int {
            SharedData.setObjectForKey(mem_chu, kMemChu)
            SharedData.instance.memChu = mem_chu
        }
        
        if let mem_star = user["mem_star"] as? String {
            SharedData.setObjectForKey(mem_star, kMemStar)
        }
        if let mem_heart = user["mem_heart"] as? String {
            SharedData.setObjectForKey(mem_heart, kMemHeart)
        }
        if let lang = user["lang"] as? String {
            SharedData.setObjectForKey(lang, kLang)
        }
        if let token = user["token"] as? String {
            SharedData.setObjectForKey(token, kToken)
            SharedData.instance.token = token
        }
    }
    class func objectForKey(_ key: String)-> Any? {
        guard let object = UserDefaults.standard.object(forKey: key) else {
            return nil
        }
        return object
    }
    class func setObjectForKey(_ value: Any?, _ key: String?) {
        guard let key = key, let value = value else {
            return
        }
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    class func removeObjectForKey(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
}
