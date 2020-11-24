//
//  NetworkManager.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/23.
//

import UIKit
import Alamofire
import SwiftyJSON

typealias ResSuccess = ([String:Any]?) -> Void
typealias ResFailure = (Any?) -> Void

enum AppError: String, Error {
    case invalidResponseType = "response data type not dictionary"
    case reqeustStatusCodeOverRage = "response status code over range 200 ~ 300"
}

enum ContentType: String {
    case json = "application/json"
    case formdata = "multipart/form-data"
    case urlencoded = "application/x-www-form-urlencoded"
    case text = "text/plain"
}

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    func getFullUrl(_ url:String) -> String {
        return "\(baseUrl)\(hostUrl)\(url)"
    }
    
    func request(_ method: HTTPMethod, _ url: String, _ param:[String:Any]?, success:ResSuccess?, failure:ResFailure?) {
        let fullUrl = self.getFullUrl(url)
        guard let encodedUrl = fullUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        AppDelegate.instance()?.startIndicator()
        let startTime = CACurrentMediaTime()
        
        let header: HTTPHeaders = [.contentType(ContentType.urlencoded.rawValue), .accept(ContentType.json.rawValue)]
        let request = AF.request(encodedUrl, method: method, parameters: param, encoding: URLEncoding.httpBody, headers: header)
        request.responseJSON { (response:AFDataResponse<Any>) in
            let endTime = CACurrentMediaTime()
            if let url = response.request?.url?.absoluteString {
                print("\n\n =======request ======= \nurl: \(String(describing: url))")
                if let param = param {
                    print(String(describing: param))
                }
            }
            print("take time: \(endTime - startTime)")
            print("======= response ======= \n\(response)")
            AppDelegate.instance()?.stopIndicator()
            
            switch response.result {
            case .success(let result):
                let statusCode: Int = response.response!.statusCode as Int
                if (statusCode >= 200) && (statusCode <= 300) {
                    
                    if let result = result as? [String:Any] {
                        success?(result)
                    }
                    else {
                        failure?(AppError.invalidResponseType)
                    }
                }
                else {
                    failure?(AppError.reqeustStatusCodeOverRage)
                }
                break
            case .failure(let error as NSError?):
                failure?(error)
                break
            }
        }
    }
}


