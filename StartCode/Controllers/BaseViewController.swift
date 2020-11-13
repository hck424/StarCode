//
//  BaseViewController.swift
//  PetChart
//
//  Created by 김학철 on 2020/09/26.
//

import UIKit
import Toast_Swift
import JWTDecode
import NetworkExtension
import SystemConfiguration.CaptiveNetwork
import Lightbox
import Photos

enum SessionType: String {
    case empty = "empty"
    case expire = "expire"
    case valid = "valid"
}
class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
    }
 
    @objc func actionPopViewCtrl() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkSession(completion:@escaping (_ type: SessionType)-> Void) {
        if let token = SharedData.instance.pToken {
            do {
                let jwt = try decode(jwt: token)
                print ("=== token: \(token)")
                print ("=== jwt expire date: \(String(describing: jwt.expiresAt))")
                if jwt.expired {
                    completion(.expire)
                }
                else {
                    completion(.valid)
                }
            } catch {
                completion(.expire)
            }
        }
        else {
            completion(.empty)
        }
    }
    
    func showAlertWithLogin(isExpire:Bool) {
        var title = ""
        var msg = ""
        if isExpire {
            title = "인증시간 초과"
            msg = "인증 시간이 초과하였습니다.\n 로그인 하시겠습니까?"
        }
        else {
            title = "로그인 안내"
            msg = "로그인이 필요한 메뉴입니다.\n로그인하시겠습니까"
        }
        AlertView.showWithCancelAndOk(title: title, message: msg) { (index) in
            if index == 1 {
                self.gotoLoginVc()
            }
        }
    }
    
    func gotoLoginVc() {
        let vc = LoginViewController.init(nibName: "LoginViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func gotoMyinfoVc() {
        let vc = MyInfoViewController.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //FIXME:: wifi change
    func connetedWifi(wifi:WifiInfo, completion:@escaping(_ success:Bool, _ error:Error?) -> Void)  {
        let configuration = NEHotspotConfiguration.init(ssid: wifi.ssid!, passphrase: wifi.password!, isWEP: false)
        configuration.joinOnce = true
        AppDelegate.instance()?.startIndicator()
    
        NEHotspotConfigurationManager.shared.apply(configuration) { (error) in
            AppDelegate.instance()?.stopIndicator()
            if let error = error {
                completion(false, error)
                return
            }
            
            completion(true, nil)
            
        }
    }
    func getAllWifiList(completion:@escaping(_ list:[Any]?)->Void) {
        NEHotspotConfigurationManager.shared.getConfiguredSSIDs { (wifiList) in
            //한번 싹 날리고 다시 요청
            wifiList.forEach {
                NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: $0)
            }
            NEHotspotConfigurationManager.shared.getConfiguredSSIDs { (list) in
                completion(list)
            }
        }
    }
    func disconnetWifi(wifi:WifiInfo, completion:@escaping(_ success:Bool, _ error:Error?) -> Void)  {
        if let ssid = wifi.ssid {
            NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: ssid)
            completion(true, nil)
        }
        else {
            completion(false, nil)
        }
    }
    func fetchWifi() -> Array<WifiInfo> {
        guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
            return []
        }
        let wifiInfo:[WifiInfo] = interfaceNames.compactMap { name in
            guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String:AnyObject] else {
                return nil
            }
            guard let ssid = info[kCNNetworkInfoKeySSID as String] as? String else {
                return nil
            }
            guard let bssid = info[kCNNetworkInfoKeyBSSID as String] as? String else {
                return nil
            }
            return WifiInfo.init(interface: name, ssid: ssid, bssid: bssid, password: nil, model: nil)
        }
        return wifiInfo
    }
    
    func showPhoto(imgUrls:Array<String>) {
        if imgUrls.isEmpty == true {
            return
        }
        var images:[LightboxImage] = [LightboxImage]()
        for url in imgUrls {
            if let imgUrl = URL(string: url) {
                let lightbox = LightboxImage(imageURL: imgUrl)
                images.append(lightbox)
            }
        }
        let controller = LightboxController(images: images, startIndex: 0)
        controller.dynamicBackground = true
        present(controller, animated: true, completion: nil)
    }
}
extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
