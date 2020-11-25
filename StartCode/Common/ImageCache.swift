//
//  ImageCache.swift
//  PetChart
//
//  Created by 김학철 on 2020/10/31.
//

import UIKit
import AlamofireImage
class ImageCache: NSObject {
    
    class func downLoadImg(url:String, userInfo:[String:Any]?, completion:@escaping(_ image: UIImage?, _ userinfo:[String:Any]?) -> Void) {
        let downloader = ImageDownloader()
        
        guard  let requestUrl = URL(string: url) else {
            completion(nil, nil)
            return
        }
        
        let request = URLRequest(url: requestUrl)
        
        downloader.download(request, completion:  { response in
//            debugPrint(response.response as Any)
//            debugPrint(response.result)
            if case .success(let image) = response.result {
                completion(image, userInfo)
            }
            else {
                completion(nil, userInfo)
            }
        })
    }
}
