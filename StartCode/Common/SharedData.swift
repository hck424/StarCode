//
//  SharedData.swift
//  PetChart
//
//  Created by 김학철 on 2020/10/03.
//

import UIKit

class SharedData: NSObject {
    static var instance = SharedData()

    var pToken: String? = nil
    var userIdx:Int = -1
    class func getUserId() -> String? {
        guard let userid = UserDefaults.standard.object(forKey: kUserId) as? String else {
            return nil
        }
        return userid
    }
//    class func getLoginType() -> String? {
//        guard let userid = UserDefaults.standard.object(forKey: kLoginType) as? String else {
//            return nil
//        }
//        return userid
//    }
//    class func getToken() ->String? {
//        guard let token = UserDefaults.standard.object(forKey: kPToken) as? String else {
//            return nil
//        }
//        return token
//    }
    class func objectForKey(key: String)-> Any? {
        guard let object = UserDefaults.standard.object(forKey: key) else {
            return nil
        }
        return object
    }
    class func setObjectForKey(key: String?, value: Any?) {
        guard let key = key, let value = value else {
            return
        }
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func removeObjectForKey(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
}
