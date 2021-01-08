//
//  NoticeDetailViewController.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/22.
//

import UIKit

class NoticeDetailViewController: BaseViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var btnOk: CButton!
    @IBOutlet weak var textView: CTextView!
    @IBOutlet weak var svImage: UIStackView!
    @IBOutlet weak var heightContent: NSLayoutConstraint!
    
    var data:[String:Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "공지사항", #selector(actionPopViewCtrl))
        
        self.requestNoticeDetail()
    }
    
    func requestNoticeDetail() {
        guard let post_id = data["post_id"] else {
            return
        }
        let param:[String:Any] = ["akey":akey, "post_id": post_id]
        ApiManager.shared.requestNoticeDetail(param: param) { (response) in
            if let response = response, let data = response["data"] as? [String:Any] {
                self.data = data
                self.configurationUi()
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }

    }
    func configurationUi() {
        if let post_title = data["post_title"] as? String {
            lbTitle.text = post_title
        }
        if let post_datetime = data["post_datetime"] as? String {
            let df = CDateFormatter.init()
            df.dateFormat = "yyyy-MM-dd HH.mm.ss"
            if let date = df.date(from: post_datetime) {
                df.dateFormat = "yyyy.MM.dd HH.mm.ss"
                lbDate.text = df.string(from: date)
            }
        }
        textView.isHidden = true
        if let post_content = data["post_content"] as? String {
            textView.isHidden = false
            do {
                let attr = try NSAttributedString.init(htmlString: post_content)
                textView.attributedText = attr
                let height = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
                heightContent.constant = height
            }
            catch {
                
            }
        }
        
        guard let files = data["files"] as? Array<[String:Any]> else {
            return
        }
        
        for item in files {
            if let pfi_filename = item["pfi_filename"] as? String {
                let imageView = UIImageView.init()
                svImage.addArrangedSubview(imageView)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                
                let userInfo:[String : Any] = ["targetView":imageView]
                ImageCache.downLoadImg(url: pfi_filename, userInfo: userInfo) { (result, userInfo) in
                    guard let image = result as? UIImage, let userInfo = userInfo as? [String:Any] else {
                        return
                    }
                    guard let targetView = userInfo["targetView"] as? UIImageView else {
                        return
                    }
                    targetView.image = image
                    let height:CGFloat = (targetView.bounds.width * image.size.height)/image.size.width
                
                    targetView.heightAnchor.constraint(equalToConstant: height).isActive = true
                }
            }
        }
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender == btnOk {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
