//
//  KakaoController.swift
//  PetChart
//
//  Created by 김학철 on 2020/09/28.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

class KakaoController: NSObject {
    var completion:((_ userInfo:UserInfo?, _ error:Error?) ->Void)?
    var user:UserInfo?
    func login(viewcontorller: UIViewController, completion:((UserInfo?, Error?) ->Void)?) {
        self.completion = completion
        if AuthApi.isKakaoTalkLoginAvailable() {
            AuthApi.shared.loginWithKakaoTalk { (token: OAuthToken?, error:Error?) in
                if let error = error {
                    print(error)
                    self.completion?(nil, error)
                    return
                }
                else {
                    print("login kakaotalk success.")
                    self.user = UserInfo.init(JSON: ["access_token": token?.accessToken ?? ""])
//                    self.user?.expiresIn = token?.expiresIn
//                    self.user?.expiredAt = token?.expiredAt
//                    self.user?.refreshToken = token?.refreshToken
                    self.requestKakaoUserInfo()
                }
            }
        }
        else {
            completion?(nil, nil)
        }
    }
    func requestKakaoUserInfo() {
        UserApi.shared.me { (user: User?, error: Error?) in
            if let error = error {
                self.completion?(nil, error)
                return
            }
            
            guard let user = user else {
                self.completion?(nil, error)
                return
            }
            self.user?.join_type = "kakao"
            self.user?.mem_userid = "\(user.id)"
            self.user?.mem_password = "\(user.id)"
            self.completion?(self.user, nil)
        }
    }
    
    func logout(completion: @escaping (_ error: Error?) -> Void) {
        UserApi.shared.logout { (error: Error?) in
            if let error = error {
                print("kakao logout error: \(error)")
                completion(error)
            }
            else {
                print("kakao logout success.")
                completion(nil)
            }
        }
    }
}
