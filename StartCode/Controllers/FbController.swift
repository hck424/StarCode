//
//  FbController.swift
//  PetChart
//
//  Created by 김학철 on 2020/09/28.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

class FbController: NSObject {
    var completion:((_ userInfo:UserInfo?, _ error:Error?) ->Void)?
    var user:UserInfo?
    
    func login(viewcontorller: UIViewController, completion:((UserInfo?, Error?) ->Void)?) {
        self.completion = completion;
        
        let loginManager = LoginManager()
        //Auth token 항상 살아 있어 다른계정으로 페이스북 로그인 할려니 안되 싹 날리고 로그인 한다.
        self.logout { (error) in
            if let token = AccessToken.current, !token.isExpired {
                self.user = UserInfo.init(JSON: ["access_token": token])
                self.fetchFacebookMe()
            }
            else {
                let readPermission:[Permission] = [.publicProfile]
                loginManager.logIn(permissions: readPermission, viewController: viewcontorller) { (result: LoginResult) in
                    switch result {
                    case .success(granted: _, declined: _, token: _):
                        self.signInFirebase()
                    case .cancelled:
                        print("facebook login cancel")
                        completion?(nil, nil);
                    case .failed(let err):
                        print(err)
                        completion?(nil, err);
                    }
                }
            }
        }
    }
    func signInFirebase() {
        
        guard let token = AccessToken.current?.tokenString else {
//            self.completion?(nil, nil)
            return
        }
        
        self.user = UserInfo.init(JSON: ["access_token": token])
        
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signIn(with: credential) { (user: AuthDataResult?, error: Error?) in
            if let error = error {
                print(error)
//                self.completion?(nil, error)
            }
            else {
                self.fetchFacebookMe()
            }
        }
    }
    func fetchFacebookMe() {
        
        let connection = GraphRequestConnection()
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: .get)
        
        connection.add(request) { (httpResponse, result, error: Error?) in
            if nil != error {
                print(error!)
                return
            }
            guard let result = result else {
                return
            }
            
            if let dic:Dictionary = result as? Dictionary<String, AnyObject>, let id = dic["id"] {
                self.user?.mem_userid = "\(id)"
                self.user?.mem_password = "\(id)"
                self.user?.join_type = "facebook"
                self.completion?(self.user, nil)
            }
        }
        connection.start()
    }
    
    func logout(completion: @escaping (_ error: Error?) -> Void) {
        let loginManager = LoginManager()
        
        loginManager.logOut()
        
        let auth = Auth.auth()
        do {
            try auth.signOut()
            
            print("fb logout success")
            completion(nil)
        } catch let error {
            print("fb logout error")
            completion(error)
        }
    }
}
