//
//  PopupViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/16.
//

import UIKit
enum PopupType {
    case list, balance
}
typealias PopupClosure = (_ vcs:UIViewController, _ selData:Any?, _ actionIndex:Int) ->Void

class PopupViewController: UIViewController {

    @IBOutlet weak var heightContainer: NSLayoutConstraint!
    @IBOutlet weak var btnFullClose: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var svContainer: UIStackView!
    
    //balance view 잔액 팝업뷰
    @IBOutlet var balanceView: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    @IBOutlet weak var btnPurchase: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet var tblView: UITableView!
    
    var type:PopupType = .list
    var listData:Array<Any>?
    var data:[String:Any]?
    var keys:Array<String>?
    var completion:PopupClosure?
    
    convenience init(type:PopupType, data:Array<Any>?, keys:[String]?, completion:PopupClosure?) {
        self.init()
        self.type = type
        self.listData = data
        self.keys = keys
        self.completion = completion
    }
    convenience init(type:PopupType, data:[String:Any]?, completion:PopupClosure?) {
        self.init()
        self.type = type
        self.data = data
        self.completion = completion
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = CACornerMask(TL: true, TR: true, BL: false, BR: false)
        
        if type == .balance {
            svContainer.addArrangedSubview(balanceView)
            balanceView.translatesAutoresizingMaskIntoConstraints = false
            balanceView.heightAnchor.constraint(equalToConstant: 160).isActive = true
            self.configurationBalanceView()
        }
        else {
            svContainer.addArrangedSubview(tblView)
            tblView.delegate = self
            tblView.dataSource = self
            
            self.view.layoutIfNeeded()
            self.tblView.reloadData {
                self.view.layoutIfNeeded()
                let height = self.tblView.contentSize.height
                self.heightContainer.constant = height
                
                UIView.animate(withDuration: 0.1) {
                    self.view.layoutIfNeeded()
                } completion: { (finish) in
                    self.tblView.reloadData()
                }
            }
        }
    }
    
    func configurationBalanceView() {
        if type == .balance {
            lbTitle.isHidden = false
            lbTitle.text = "잔여 CHU"
            
            guard let data = data as? [String:Any], let coin = data["coin"] as? Int else {
                lbSubTitle.text = ""
                return
            }
            let tmpStr = "ea"
            let coinStr = "\(coin)".addComma()
            let result = "\(coinStr) \(tmpStr)"
            
            let attr = NSMutableAttributedString.init(string: result)
            attr.addAttribute(.foregroundColor, value: RGB(139, 0, 255), range: (result as NSString).range(of: coinStr))
            attr.addAttribute(.font, value: UIFont.systemFont(ofSize: 24, weight: .bold), range: (result as NSString).range(of: coinStr))
            attr.addAttribute(.foregroundColor, value: UIColor.label, range: (result as NSString).range(of: tmpStr))
            attr.addAttribute(.font, value: UIFont.systemFont(ofSize: 24, weight: .regular), range: (result as NSString).range(of: tmpStr))
            
            lbSubTitle.attributedText = attr
        }
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender == btnFullClose || sender == btnClose {
            self.dismissBlock(nil, index: -1)
        }
        else if sender == btnPurchase {
            self.dismissBlock(nil, index: 1)
        }
    }
    
    func dismissBlock(_ selData:Any?, index:Int) {
        self.completion?(self, selData, index)
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
            else {
                
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let listData = listData, let item = listData[indexPath.row] as? Any else {
            return
        }
        
        self.dismissBlock(item, index: indexPath.row)
    }
    
}
