//
//  LoginSelectViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/13.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import AuthenticationServices
import CryptoSwift

class LoginSelectViewController: BaseViewController {

    @IBOutlet weak var btnSignUp: CButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnNaver: UIButton!
    @IBOutlet weak var btnKakao: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnApple: CButton!
    
    var user: UserInfo? = nil
    var currentNonce: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let title = btnSignIn.titleLabel?.text {
            let attr = NSAttributedString.init(string: title, attributes: [NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue])
            btnSignIn.setAttributedTitle(attr, for: .normal)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender == btnSignUp {
            let vc = LoginViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if sender == btnFacebook {
            if let joinType = SharedData.objectForKey(kMemJoinType) as? String, let userId = SharedData.objectForKey(kMemUserid) as? String, joinType == "facebook", userId.isEmpty == false {
                self.requestSignUp(joinType, userId: userId)
            }
            else {
                FbController().login(viewcontorller: self) { (user: UserInfo?, error: Error?) in
                    guard let user = user, let _ = user.mem_userid else {
                        return
                    }
                    print("facebook userId:  \(user.mem_userid ?? "")")
                    self.requestValiedSocialLogin(user)
                }
            }
        }
        else if sender == btnNaver {
            if let joinType = SharedData.objectForKey(kMemJoinType) as? String, let userId = SharedData.objectForKey(kMemUserid) as? String, joinType == "naver", userId.isEmpty == false {
                self.requestSignUp(joinType, userId: userId)
            }
            else {
                NaverController().login(viewcontorller: self) { (user: UserInfo?, error: Error?) in
                    guard let user = user, let _ = user.mem_userid else {
                        return
                    }
                    print("naver userId: \(user.mem_userid ?? "")")
                    self.requestValiedSocialLogin(user)
                }
            }
            
        }
        else if sender == btnKakao {
            if let joinType = SharedData.objectForKey(kMemJoinType) as? String, let userId = SharedData.objectForKey(kMemUserid) as? String, joinType == "kakao", userId.isEmpty == false {
                self.requestSignUp(joinType, userId: userId)
            }
            else {
                KakaoController().login(viewcontorller: self) { (user: UserInfo?, error: Error?) in
                    guard let user = user, let _ = user.mem_userid else {
                        return
                    }
                    self.requestValiedSocialLogin(user)
                }
            }
        }
        else if sender == btnApple {
            let request = createAppIdRequest()
            let autorizationController = ASAuthorizationController(authorizationRequests: [request])
            autorizationController.delegate = self
            autorizationController.presentationContextProvider = self
            autorizationController.performRequests()
        }
        else if sender == btnSignIn {
            let vc = MrTermsViewController.init()
            vc.user = UserInfo.init(JSON: ["join_type":"none"])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func reqeustSignUp(_ param:[String:Any]) {
        let password = param["password"]
        ApiManager.shared.requestMemberSignIn(param: param) { (response) in
            if let response = response, let code = response["code"] as? NSNumber {
                if code.intValue == 200 {
                    guard let user = response["user"] as? [String:Any] else {
                        return
                    }
                    SharedData.instance.saveUserInfo(user: user)
                    SharedData.setObjectForKey(password, kMemPassword)
                    AppDelegate.instance()?.callMainVc()
                }
                else {
                    if let message = response["message"] as? String {
                        self.showToast(message)
                    }
                }
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }

    }
    func requestSignUp(_ joinType:String, userId: String) {
        var param:[String:Any] = [:]
        param["akey"] = akey
        param["userid"] = userId
        param["password"] = userId
        param["platform"] = "ios"
        param["device_id"] = Utility.getUUID()
        param["join_type"] = joinType
        param["push_token"] = Messaging.messaging().fcmToken ?? ""
        self.reqeustSignUp(param)
    }
    
    //소설로그인 가입여부 체크
    func requestValiedSocialLogin(_ user:UserInfo) {
        guard let userId = user.mem_userid, let join_type = user.join_type else {
            return
        }
        let param = ["akey":akey, "user_id":userId, "join_type":join_type]
        
        ApiManager.shared.requestMemberIdCheck(param: param) { (response) in
            if let response = response, let code = response["code"] as? NSNumber {
                //200 사용가능한 아이디, 즉 회원가입이 안됬다는 뜻
                if code.intValue == 200 {
                    let vc = MrTermsViewController.init()
                    vc.user = user
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    var param:[String:Any] = [:]
                    param["akey"] = akey
                    param["userid"] = userId
                    param["password"] = userId
                    param["platform"] = "ios"
                    param["device_id"] = Utility.getUUID()
                    param["join_type"] = join_type
                    param["push_token"] = Messaging.messaging().fcmToken ?? ""
                    self.reqeustSignUp(param)
                }
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
    
    func createAppIdRequest() -> ASAuthorizationAppleIDRequest {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let nonce = self.randomNonceString()
        request.nonce = self.sha256(nonce)
        
        currentNonce = nonce
        return request
    }
    
}

extension  LoginSelectViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = inputData.sha256()
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    //delegate
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let none = currentNonce else {
                fatalError("Invalid state: A login callbak was recevied, but no loin request was sent")
                return
            }
            guard let appIdToken = appleIdCredential.identityToken else {
                print("Unable to fetch idntify token")
                return
            }
            
            guard let idToken = String(data: appIdToken, encoding: .utf8) else {
                print("Unable to serialize token string from data:\(appIdToken.description)")
                return
            }
            self.user = UserInfo.init(JSON: ["access_token": idToken])
            print ("user appid token : \(idToken)")
            
            // Initialize a Firebase credential.
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idToken,
                                                      rawNonce: none)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error.localizedDescription)
                    return
                }
                else {
                    self.user?.mem_userid = authResult?.user.uid
                    self.user?.mem_email = authResult?.user.email
                    self.user?.mem_nickname = authResult?.user.displayName
                    self.user?.join_type = "apple"
                    self.requestValiedSocialLogin(self.user!)
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return (self.view.window)!
    }

}
