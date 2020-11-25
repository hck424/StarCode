//
//  PopupViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/16.
//

import UIKit
enum PopupType {
    case list, alert, textField
}
enum ActionStyle {
    case cancel, ok, textfild, textfieldAndButton
}

typealias ActionHalder = (_ action: AnyObject) ->Void
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
    
    var arrFiled:Array<UITextField>?
    
    var tblView:UITableView? = nil
    var type:PopupType = .list
    var listData:Array<Any>?
    var data:[String:Any]?
    var keys:Array<String>?
    var arrBtn:Array<UIButton>?
    
    var popupTitle:Any? = nil
    var message:Any? = nil
    var actionHandler:ActionHalder?
    var didSelectRowAtItem:((_ vcs:UIViewController, _ selItem:Any?, _ index:Int)->Void)?
    
    convenience init(type:PopupType, title:Any? = nil, message:Any? = nil) {
        self.init()
        self.type = type
        self.popupTitle = title
        self.message = message
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    convenience init(type:PopupType, title:Any? = nil, data:Array<Any>?, keys:[String]? = nil) {
        self.init()
        self.type = type
        self.popupTitle = title
        self.listData = data
        self.keys = keys
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
    
    func addTextField(_ title: Any?, _ style:ActionStyle, _  placeHolder:String? = nil, _ btnTitle:String? = nil, _ hitTxt:String? = nil) {
        self.view.layoutIfNeeded()
        if arrFiled == nil {
            arrFiled = Array<CTextField>()
        }
        
        let svField = UIStackView.init()
        
        svField.axis = .vertical
        svField.spacing = 0
        svField.distribution = .fill
        svContentView.isLayoutMarginsRelativeArrangement = true
        svContentView.layoutMargins = UIEdgeInsets(top: 30, left: 20, bottom: 10, right: 20)
        svContentView.addArrangedSubview(svField)
        svContentView.spacing = 0
        
        if let title = title {
            let lbTitle = UILabel.init()
            lbTitle.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
            if title is NSAttributedString {
                lbTitle.attributedText = title as? NSAttributedString
            }
            else if title is String {
                lbTitle.text = (title as! String)
            }
            svField.addArrangedSubview(lbTitle)
            lbTitle.tag = 100
        }
        
        let textField = CTextField.init()
        textField.insetTB = 3
        textField.insetLR = 0
        textField.delegate = self
        textField.placeholder = placeHolder
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        textField.tag = 101
        
        arrFiled?.append(textField)
        if style == .textfieldAndButton {
            let svTmp = UIStackView.init()
            svTmp.axis = .horizontal
            svTmp.spacing = 8
            svField.addArrangedSubview(svTmp)
            svTmp.addArrangedSubview(textField)
         
            let btn = UIButton.init()
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            btn.setTitleColor(RGB(139, 0, 255), for: .normal)
            if let btnTitle = btnTitle {
                btn.setTitle(btnTitle, for: .normal)
            }
            svTmp.addArrangedSubview(btn)
            btn.addTarget(self, action: #selector(onClickedBtnActions(_:)), for: .touchUpInside)
            btn.tag = 200+arrFiled!.count
            let lineView = UIView.init()
            svField.addArrangedSubview(lineView)
            lineView.translatesAutoresizingMaskIntoConstraints = false
            lineView.backgroundColor = RGB(216, 216, 216)
            lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        }
        else {
            svField.addArrangedSubview(textField)
            textField.borderBottom = true
            textField.borderWidth = 1.0
            textField.borderColor = RGB(216, 216, 216)
        }
        
        let hitView = UIView.init()
        svField.addArrangedSubview(hitView)
        hitView.translatesAutoresizingMaskIntoConstraints = false
        hitView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let lbHint = UILabel.init()
        lbHint.textAlignment = .right
        lbHint.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lbHint.textColor = RGB(230, 102, 102)
        hitView.addSubview(lbHint)
        if hitTxt != nil {
            lbHint.text = hitTxt
        }
        
        lbHint.leadingAnchor.constraint(equalTo: hitView.leadingAnchor).isActive = true
        lbHint.topAnchor.constraint(equalTo: hitView.topAnchor).isActive = true
        lbHint.bottomAnchor.constraint(equalTo: hitView.bottomAnchor).isActive = true
        lbHint.trailingAnchor.constraint(equalTo: hitView.trailingAnchor).isActive = true
        lbHint.tag = 102
    }
    
    func addAction(_ title: Any?, style:ActionStyle, hanlder: ActionHalder?) {
        self.view.layoutIfNeeded()
        
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        
        if style == .cancel {
            btn.backgroundColor = RGB(232, 232, 232)
            if let title = title as? NSAttributedString {
                btn.setAttributedTitle(title, for: .normal)
            }
            else if let title = title as? String {
                btn.setTitle(title, for: .normal)
                btn.setTitleColor(RGB(153, 153, 153), for: .normal)
            }
            btn.tag = 100
        }
        else if style == .ok {
            btn.setBackgroundImage(UIImage(named: "btn_rectangle"), for: .normal)
            if let title = title as? NSAttributedString {
                btn.setAttributedTitle(title, for: .normal)
            }
            else if let title = title as? String {
                btn.setTitle(title, for: .normal)
                btn.setTitleColor(UIColor.systemBackground, for: .normal)
            }
            btn.tag = 101
            self.actionHandler = hanlder
        }
        
        svActions.isHidden = false
        svActions.addArrangedSubview(btn)
        btn.addTarget(self, action: #selector(onClickedBtnActions(_:)), for: .touchUpInside)
        self.view.layoutIfNeeded()
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender == btnClose {
            self.dismiss(animated: false, completion: nil)
        }
        if sender == btnFullClose {
            if type == .textField {
                self.view.endEditing(true)
            }
            else {
                self.dismiss(animated: false, completion: nil)
            }
        }
        else {
            if let arrFiled = arrFiled {
                if (sender.tag >= 200) && (sender.tag < (arrFiled.count + 200)) {
                    let index = sender.tag - 200
                    let textField = arrFiled[index]
                    if textField.text?.isEmpty == true {
                        
                    }
                }
            }
            else if sender.tag == 100 {
                self.dismiss(animated: true, completion: nil)
            }
            else if sender.tag == 101 {
                actionHandler?(sender)
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
        
        if let didSelectRowAtItem = didSelectRowAtItem {
            didSelectRowAtItem(self, item, indexPath.row)
        }
    }
    
}
extension PopupViewController: UITextFieldDelegate {
    
}
