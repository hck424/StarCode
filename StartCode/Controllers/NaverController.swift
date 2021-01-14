//
//  NaverController.swift
//  PetChart
//
//  Created by 김학철 on 2020/09/28.
//

import UIKit
import NaverThirdPartyLogin

class NaverController: NSObject {
    var completion:((_ userInfo:UserInfo?, _ error:Error?) ->Void)?
    var user:UserInfo?
    
    func login(viewcontorller: UIViewController, completion:((UserInfo?, Error?) ->Void)?) {
        self.completion = completion
        
        let connection = NaverThirdPartyLoginConnection.getSharedInstance()
        connection?.delegate = self
        if let valid = connection?.isValidAccessTokenExpireTimeNow(), valid == false {
            connection?.requestThirdPartyLogin()
        }
        else {
            connection?.requestAccessTokenWithRefreshToken()
            self.reqeustFetchUserInfo()
        }
    }
    
    func reqeustFetchUserInfo() {
        guard let naverConnection = NaverThirdPartyLoginConnection.getSharedInstance() else { return }
        guard let accessToken = naverConnection.accessToken else { return }
        let authorization = "Bearer \(accessToken)"
        
        if let url = URL(string: "https://openapi.naver.com/v1/nid/me") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue(authorization, forHTTPHeaderField: "Authorization")
            
            AppDelegate.instance()?.startIndicator()
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                AppDelegate.instance()?.stopIndicator()
                guard let data = data else { return }
                
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                    guard let response = json["response"] as? [String: AnyObject] else { return }
                    
                    self.user = UserInfo.init(JSON: ["access_token": accessToken])
                    
                    guard let id = response["id"] as? String else {
                        return
                    }
                    
                    self.user?.join_type = "naver"
                    self.user?.mem_userid = "\(id)"
                    self.user?.mem_password = "\(id)"
                    
                    DispatchQueue.main.async { [self] in
                        print("=== naver login: \(self.user?.description() ?? "")")
                        self.completion?(self.user, nil)
                        self.completion = nil
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        self.completion?(nil, error)
                        self.completion = nil
                    }
                }
            }.resume()
        }
    }
    
    func logout(completion: @escaping (_ error: Error?) -> Void) {
        NaverThirdPartyLoginConnection.getSharedInstance()?.requestDeleteToken()
        print("naver logout success")
        completion(nil)
    }
}

extension NaverController: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        // 로그인 성공 (로그인된 상태에서 requestThirdPartyLogin()를 호출하면 이 메서드는 불리지 않는다.)
        self.reqeustFetchUserInfo()
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        // 로그인된 상태(로그아웃이나 연동해제 하지않은 상태)에서 로그인 재시도
        self.reqeustFetchUserInfo()
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
         // 연동해제 콜백
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
         //  접근 토큰, 갱신 토큰, 연동 해제등이 실패
    }
    
}
