//
//  CNavigationBar.swift
//  PetChart
//
//  Created by 김학철 on 2020/09/27.
//

import UIKit
public let TAG_NAVI_BACK: Int = 10000
public let TAG_NAVI_TITLE: Int = 10001
public let TAG_NAVI_USER: Int = 10002

class CNavigationBar: UINavigationBar {

    class func drawBackButton(_ controller: UIViewController, _ title: Any?, _ selctor:Selector) {
        
        let button: UIButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        button.tag = TAG_NAVI_BACK
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = UIColor.label
        if let title = title as? String {
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            button.setTitle(title, for: .normal)
            button.setTitleColor(UIColor.label, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            var width: CGFloat = button.sizeThatFits(CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: button.frame.size.height)).width
            if width > 250.0 {
                width = 250
            }
            
            button.frame = CGRect.init(x: 0, y: 0, width: width + button.titleEdgeInsets.left, height: button.frame.size.height)
        }
        else if let title = title as? NSAttributedString {
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            button.setAttributedTitle(title, for: .normal)
            
            var width: CGFloat = button.sizeThatFits(CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: button.frame.size.height)).width
            if width > 250.0 {
                width = 250
            }
            button.frame = CGRect.init(x: 0, y: 0, width: width + button.titleEdgeInsets.left, height: button.frame.size.height)
        }
        
        button.addTarget(controller, action: selctor, for: .touchUpInside)
        
        let barBtn = UIBarButtonItem.init(customView: button)
        controller.navigationItem.setLeftBarButton(barBtn, animated: false)
        
        let naviBar = controller.navigationController?.navigationBar
        naviBar?.isTranslucent = true
//        let img = UIImage.image(from: UIColor.white)!
        naviBar?.tintColor = UIColor.systemBackground
        naviBar?.barTintColor = UIColor.systemBackground
//        naviBar?.setBackgroundImage(img, for: UIBarMetrics.default)
//        naviBar?.shadowImage = UIImage.init()
//        UINavigationBar.appearance().shadowImage = UIImage.init()
    }
    
    class func drawTitle(_ controller: UIViewController, _ title: Any?, _ selctor:Selector?) {
        let button: UIButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        button.setTitleColor(UIColor.white, for: .normal)
        if let title:String = title as? String {
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        }
        else if let title:UIImage = title as? UIImage {
            button.setImage(title, for: .normal)
        }
        
        var width: CGFloat = button.sizeThatFits(CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: button.frame.size.height)).width
        if width > 250.0 {
            width = 250
        }
        button.frame = CGRect.init(x: 0, y: 0, width: width, height: button.frame.size.height)
        button.adjustsImageWhenHighlighted = false
        button.adjustsImageWhenDisabled = false
        
        controller.navigationItem.titleView = button;
        
        
        if let selctor = selctor {
            button.addTarget(controller, action: selctor, for: .touchUpInside)
        }
        
        let naviBar = controller.navigationController?.navigationBar
        naviBar?.isTranslucent = true
        let img = UIImage.image(from: UIColor.white)!
        naviBar?.tintColor = UIColor.white
        naviBar?.barTintColor = UIColor.white
        naviBar?.setBackgroundImage(img, for: UIBarMetrics.default)
        naviBar?.shadowImage = UIImage.init()
        UINavigationBar.appearance().shadowImage = UIImage.init()
    }
    
    class func drawRight(_ controller: UIViewController, _ title: String?, _ img:UIImage?, _ tag:Int,  _ selctor:Selector) {
        
        let button: UIButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        button.tag = tag
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        if let img = img {
            button.setImage(img, for: .normal)
        }
        
        if let title = title {
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
            let attr = NSAttributedString.init(string: title, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium)])
            button.setAttributedTitle(attr, for: .normal)
            
            var width: CGFloat = button.sizeThatFits(CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: button.frame.size.height)).width
            if width > 250.0 {
                width = 250
            }
            else if width < 44 {
                width = 44
            }
            
            button.frame = CGRect.init(x: 0, y: 0, width: width + button.titleEdgeInsets.left, height: button.frame.size.height)
        }
//        button.layer.borderWidth = 1.0
//        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(controller, action: selctor, for: .touchUpInside)
        
        let barBtn = UIBarButtonItem.init(customView: button)
        controller.navigationItem.setRightBarButton(barBtn, animated: false)
        
        let naviBar = controller.navigationController?.navigationBar
        
        naviBar?.isTranslucent = true
        let img = UIImage.image(from: UIColor.white)
        naviBar?.tintColor = UIColor.white
        naviBar?.barTintColor = UIColor.white
        naviBar?.setBackgroundImage(img, for: UIBarMetrics.default)
        naviBar?.shadowImage = UIImage.init()
        UINavigationBar.appearance().shadowImage = UIImage.init()
    }
    
    class func drawProfile(_ controller: UIViewController, _ selctor:Selector) {
        CNavigationBar .drawRight(controller, nil, UIImage(named: "group_3")!, TAG_NAVI_USER, selctor)
    }
    
}
