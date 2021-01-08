//
//  ExQuestionView.swift
//  StartCodePro
//
//  Created by 김학철 on 2020/12/27.
//

import UIKit

class ExQuestionView: UIView {
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var btnWarning: UIButton!
    @IBOutlet weak var btnPass: UIButton!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    @IBOutlet weak var svTag: UIStackView!
    @IBOutlet weak var svTagContainer: UIStackView!
    
    @IBOutlet weak var lbRemaindTime: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: "QnaColCell", bundle: nil), forCellWithReuseIdentifier: "QnaColCell")
        }
    }
    var arrFile:Array<[String:Any]> = []
    var data:[String:Any] = [:]
    var type:QnaType = .oneToQna
    
    var tiemr: Timer?
    
    func configurationData(_ data:[String:Any], _ type:QnaType) {
        
        self.data = data
        self.type = type
        btnPass.isHidden = true
        btnWarning.isHidden = true
        lbRemaindTime.isHidden = true
        
        self.layoutIfNeeded()
        lbTitle.text = ""
        lbDate.text = ""
        lbRemaindTime.text = ""
        lbContent.text = ""
        
        if type == .oneToQna {
            if let post_title = data["post_title"] as? String {
                lbTitle.text = post_title
            }
        }
        else if type == .makeupQna || type == .beautyQna {
            var totalChu = "0"
            if let post_chu = data["post_chu"] {
                totalChu = "\(post_chu)".addComma()
            }
            let tmpStr = "CHU \(totalChu) 개"
            let result = "현재 누적된 \(tmpStr)"
            let attr = NSMutableAttributedString.init(string: result)
            attr.addAttribute(.foregroundColor, value: RGB(128, 0, 255), range: (result as NSString).range(of: tmpStr))
            attr.addAttribute(.font, value: UIFont.systemFont(ofSize: lbTitle.font.pointSize, weight: .regular), range: NSMakeRange(0, 6))
            lbTitle.attributedText = attr
        }
        svTagContainer.isHidden = true
        if let tags = data["tag"] as? Array<[String:Any]>, tags.isEmpty == false, type == .beautyQna {
            svTagContainer.isHidden = false
            
            for item in tags {
                if let pta_tag = item["pta_tag"] as? String {
                    let btn = CButton.init(type: .custom)
                    svTag.addArrangedSubview(btn)
                    
                    btn.backgroundColor = RGB(255, 112, 116)
                    btn.setTitle(pta_tag, for: .normal)
                    btn.titleLabel?.font = UIFont.systemFont(ofSize: 9, weight: .regular)
                    btn.setTitleColor(UIColor.white, for: .normal)
                    btn.contentEdgeInsets = UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6)
                    btn.halfCornerRadius = true
                }
            }
        }
        if let post_content = data["post_content"] as? String {
            lbContent.text = post_content
        }
        if let post_datetime = data["post_datetime"] as? String {
            let df = CDateFormatter.init()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = df.date(from: post_datetime) {
                df.dateFormat = "yyyy.MM.dd HH:mm"
                lbDate.text = df.string(from: date)
            }
        }
        
        if let files = data["files"] as? Array<[String:Any]>, files.isEmpty == false {
            self.layoutIfNeeded()
            self.arrFile = files
            collectionView.isHidden = false
            collectionView.delegate = self
            collectionView.dataSource = self
            
            let layout = CustomColFlowLayout.init()
            layout.scrollDirection = .horizontal
            
            let width = collectionView.bounds.width-40
            heightCollectionView.constant = width
            collectionView.decelerationRate = .fast
            layout.itemSize = CGSize(width: width, height: width)
            layout.minimumLineSpacing = 10
//            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            collectionView.collectionViewLayout = layout
            collectionView.reloadData()
            layout.delegate = self
            
        }
        else {
            collectionView.isHidden = true
        }
        
        let df = CDateFormatter.init()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let post_answer_compdate = data["post_answer_compdate"] as? String, let remainDate = df.date(from: post_answer_compdate) {
            let curDate = Date()
            if curDate < remainDate {
                lbRemaindTime.isHidden = false
                if self.tiemr != nil {
                    self.tiemr?.invalidate()
                    self.tiemr = nil
                }
                
                self.tiemr =  Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                    self.startDownTime(toDate: remainDate)
                }
            }
        }
    }
    
    func startDownTime(toDate:Date) {
        let comps = toDate - Date()
        var result = "잔여시간: "
        var tmpStr = "00:"
        if let hour = comps.hour, hour > 0 {
            tmpStr = String(format: "%02ld:", hour)
        }
        if let minute = comps.minute {
            tmpStr.append(String(format: "%02ld:", minute))
        }
        if let secod = comps.second {
            tmpStr.append(String(format: "%02ld", secod))
        }
        
        result.append(tmpStr)
        lbRemaindTime.text = result
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
    }
    
    deinit {
        if self.tiemr != nil {
            self.tiemr?.invalidate()
            self.tiemr = nil
        }
    }
    
}
extension ExQuestionView: UICollectionViewDataSource, UICollectionViewDelegate, CustomColFlowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFile.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QnaColCell", for: indexPath) as! QnaColCell
        if let data = arrFile[indexPath.row] as? [String:Any] {
            cell.configurationData(data, .question, type)
        }
        return cell
    }
    func didEndDecelatedFloawLayout(_ indexPath: IndexPath, _ point: CGPoint) {
    }
}

