//
//  Utility.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/24.
//

import UIKit
import SwiftKeychainWrapper
class Utility: NSObject {
    class func isIphoneX() ->Bool {
        return ((AppDelegate.instance()?.window?.safeAreaInsets.bottom)! > 0.0)
    }
    class func getUUID() ->String {
        let uniqueDeviceId: String? = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.myKey.rawValue)
        
        if let uuid = uniqueDeviceId {
            return uuid
        }
        
        let uuidRef: CFUUID = CFUUIDCreate(nil)
        let uuidStringRef: CFString = CFUUIDCreateString(nil, uuidRef)
        let uuid:String = String(uuidStringRef)
        
        let saveSuccessful: Bool = KeychainWrapper.standard.set(uuid, forKey:KeychainWrapper.Key.myKey.rawValue)
        if saveSuccessful {
            return uuid
        }
        return ""
    }
}

extension KeychainWrapper.Key {
    static let myKey: KeychainWrapper.Key = KeychainWrapper.Key(rawValue: Bundle.bundleIdentifier)
}
