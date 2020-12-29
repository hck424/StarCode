//
//  PopupViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/16.
//

import UIKit
import AudioToolbox
enum PopupType {
    case list, alert
}

enum PopupActionStyle {
    case cancel, ok
}

typealias PopupClosure = (_ vcs:PopupViewController, _ selItem:Any?, _ index:Int) ->Void

class PopupViewController: UIViewController {

    @IBOutlet weak var heightContentView: NSLayoutConstraint!
    @IBOutlet weak var btnFullClose: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var svContentView: UIStackView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var svTitle: UIStackView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var svActions: UIStackView!
    @IBOutlet weak var bottomContainer: NSLayoutConstraint!
    
    var arrTextView:[CTextView] = []
    
    var tblView:UITableView? = nil
    var type:PopupType = .list
    var listData:Array<Any>?
    var data:[String:Any]?
    var keys:Array<String>?
    var arrBtn:Array<UIButton> = []
    
    var popupTitle:Any? = nil
    var message:Any? = nil
    
    var completion:PopupClosure?

    convenience init(type:PopupType, title:Any? = nil, message:Any? = nil, completion:PopupClosure?) {
        self.init()
        self.type = type
        self.popupTitle = title
        self.message = message
        self.completion = completion
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    convenience init(type:PopupType, title:Any? = nil, data:Array<Any>?, keys:[String]? = nil, completion:PopupClosure?) {
        self.init()
        self.type = type
        self.popupTitle = title
        self.listData = data
        self.keys = keys
        self.completion = completion
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = CACornerMask(TL: true, TR: true, BL: false, BR: false)
        
        self.view.layoutIfNeeded()
        
        svTitle.isHidden = true
        if let popupTitle = popupTitle as? NSAttributedString {
            svTitle.isHidden = false
            lbTitle.attributedText = popupTitle
        }
        else if let popupTitle = popupTitle as? String {
            svTitle.isHidden = false
            lbTitle.text = popupTitle
        }
       
        btnClose.isHidden = false
        svActions.isHidden = true
        if (type == .list) {
            btnClose.isHidden = true
        
            tblView = UITableView.init(frame: svContentView.bounds, style: .plain)
            svContentView.addArrangedSubview(tblView!)
            tblView?.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            tblView?.delegate = self
            tblView?.dataSource = self
            
            self.view.layoutIfNeeded()
            guard let tblView = tblView else {
                return
            }
            
            tblView.reloadData {
                self.view.layoutIfNeeded()
                let height = tblView.contentSize.height
                self.heightContentView.constant = height

                UIView.animate(withDuration: 0.1) {
                    self.view.layoutIfNeeded()
                } completion: { (finish) in
                    tblView.reloadData()
                }
            }
        }
        else {
            if let message = message {
                let lbMessage = UILabel.init()
                lbMessage.textAlignment = .center
                lbMessage.numberOfLines = 0
                svContentView.addArrangedSubview(lbMessage)
                
                if message is NSAttributedString {
                    lbMessage.attributedText = (message as! NSAttributedString)
                }
                else if message is String {
                    lbMessage.font = UIFont.systemFont(ofSize: 15, weight: .regular)
                    lbMessage.text = message as? String
                }
                
                svContentView.isLayoutMarginsRelativeArrangement = true
                svContentView.layoutMargins = UIEdgeInsets(top: 30, left: 20, bottom: 30, right: 20)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationHandler(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationHandler(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        self.view.endEditing(true)
    }
    
    func addTextView(_ placeHolderString:String) {
        self.view.layoutIfNeeded()
        let sv = UIStackView.init()
        svContentView.addArrangedSubview(sv)
        sv.isLayoutMarginsRelativeArrangement = true
        sv.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        let tv = CTextView.init()
        sv.addArrangedSubview(tv)
        tv.placeHolderString = placeHolderString
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.heightAnchor.constraint(equalToConstant: 120).isActive = true
        tv.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        tv.cornerRadius = 8.0
        tv.insetLeft = 10
        tv.insetTop = 10
        tv.insetBottom = 10
        tv.insetRigth = 10
        tv.borderWidth = 1.0
        tv.borderColor = RGB(221, 221, 221)
        tv.setNeedsDisplay()
        arrTextView.append(tv)
    }
    func addAction(_ style:PopupActionStyle, _ title: Any) {
        self.view.layoutIfNeeded()
        
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        
        if style == .ok {
            btn.setBackgroundImage(UIImage(named: "btn_rectangle"), for: .normal)
            if let title = title as? NSAttributedString {
                btn.setAttributedTitle(title, for: .normal)
            }
            else if let title = title as? String {
                btn.setTitle(title, for: .normal)
                btn.setTitleColor(UIColor.systemBackground, for: .normal)
            }
        }
        else {
            btn.backgroundColor = RGB(232, 232, 232)
            if let title = title as? NSAttributedString {
                btn.setAttributedTitle(title, for: .normal)
            }
            else if let title = title as? String {
                btn.setTitle(title, for: .normal)
                btn.setTitleColor(RGB(153, 153, 153), for: .normal)
            }
        }
        svActions.isHidden = false
        svActions.addArrangedSubview(btn)
        btn.addTarget(self, action: #selector(onClickedBtnActions(_:)), for: .touchUpInside)
        btn.tag = 100+arrBtn.count
        arrBtn.append(btn)
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender == btnClose {
            self.dismiss(animated: false, completion: nil)
        }
        if sender == btnFullClose {
            if arrTextView.isEmpty == false {
                self.view.endEditing(true)
            }
            else {
                self.dismiss(animated: false, completion: nil)
            }
        }
        else if sender.tag >= 100 {
            if sender.tag == 100 {
                self.completion?(self, nil, sender.tag-100)
            }
            else {
                if arrTextView.isEmpty == false {
                    if let textView = arrTextView.first, textView.text.isEmpty == true {
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                        return
                    }
                    self.completion?(self, nil, sender.tag-100)
                }
                else {
                    self.completion?(self, nil, sender.tag-100)
                }
            }
            
        }
    }
    
    ///mark notificationHandler
    @objc func notificationHandler(_ notification: Notification) {
        if notification.name == UIResponder.keyboardWillShowNotification
            || notification.name == UIResponder.keyboardWillHideNotification {
            
            let heightKeyboard = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size.height
            let duration = CGFloat((notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue ?? 0.0)
     
            if notification.name == UIResponder.keyboardWillShowNotification {
                bottomContainer.constant = heightKeyboard
                UIView.animate(withDuration: TimeInterval(duration), animations: { [self] in
                    self.view.layoutIfNeeded()
                })
            }
            else if notification.name == UIResponder.keyboardWillHideNotification {
                bottomContainer.constant = 0
                UIView.animate(withDuration: TimeInterval(duration)) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}

extension PopupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let listData = listData {
            return listData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "PopupCell") as? PopupCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("PopupCell", owner: self, options: nil)?.first as? PopupCell
        }
        cell?.svContent.isLayoutMarginsRelativeArrangement = true
        cell?.svContent.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        if let listData = listData {
            if let item = listData[indexPath.row] as? String {
                cell?.lbTitle.text = item
            }
            else if let item = listData[indexPath.row] as? [String:Any], let keys = keys {
                var result = ""
                for key in keys {
                    if let value = item[key] {
                        result.append("\(value)")
                    }
                }
                cell?.lbTitle.text = result
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let listData = listData, let item = listData[indexPath.row] as? Any else {
            return
        }
        
        self.completion?(self, item, indexPath.row)
    }
    
}
extension PopupViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let textView = textView as? CTextView {
            textView.placeholderLabel?.isHidden = !textView.text.isEmpty
        }
    }
}
