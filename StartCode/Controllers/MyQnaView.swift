//
//  MyQnaView.swift
//  StartCode
//
//  Created by 김학철 on 2020/12/20.
//

import UIKit
enum MyQnaViewType {
    case question, answer
}
class MyQnaView: UIView {
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var ivType: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var btnWarning: UIButton!
    @IBOutlet weak var btnPass: UIButton!
    @IBOutlet weak var btnArrowLeft: UIButton!
    @IBOutlet weak var btnArrowRight: UIButton!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: "QnaColCell", bundle: nil), forCellWithReuseIdentifier: "QnaColCell")
        }
    }
    var questionType:QnaType = .oneToQna
    
    var indexPath:IndexPath = [] {
        didSet {
            if type == .answer {
                btnArrowLeft.isHidden = true
                btnArrowRight.isHidden = true
                if arrFile.count > 1 {
                    if indexPath.row == 0 {
                        btnArrowLeft.isHidden = true
                        btnArrowRight.isHidden = false
                    }
                    else if indexPath.row == (arrFile.count-1) {
                        btnArrowLeft.isHidden = false
                        btnArrowRight.isHidden = true
                    }
                    else {
                        btnArrowLeft.isHidden = false
                        btnArrowRight.isHidden = false
                    }
                }
            }
        }
    }
    var data:[String:Any] = [:]
    var type: MyQnaViewType = .question
    var arrFile:Array<[String:Any]> = []
    
    func configurationData(_ data:[String:Any], _ type:MyQnaViewType) {
        self.data = data
        self.type = type
        var result = ""
        var nickname = ""
        if let post_nickname = data["post_nickname"] as? String {
            nickname = post_nickname
            result.append(nickname)
        }
        var tmpStr = ""
        if type == .question {
            seperatorView.isHidden = true
            btnArrowLeft.isHidden = true
            btnArrowRight.isHidden = true
            btnPass.isHidden = true
            btnWarning.isHidden = true
            ivType.image = UIImage(named: "ic_question")
            
            if questionType == .aiQna {
                tmpStr = "님의 Ai 메이크업 진단"
            }
            else if questionType == .beautyQna {
                tmpStr = "님의 뷰티 질문"
            }
            else if questionType == .makeupQna {
                tmpStr = "님의 메이크업 진단"
            }
            else if let post_title = data["post_title"] as? String {
                result = post_title
            }
        }
        else if type == .answer {
            seperatorView.isHidden = false
            ivType.image = UIImage(named: "ic_answer")
            tmpStr = "전문가님의 답변"
        }
        
        result.append(tmpStr)
        if tmpStr.isEmpty == false {
            let attr = NSMutableAttributedString.init(string: result)
            attr.addAttribute(.foregroundColor, value: RGB(128, 0, 255), range: NSMakeRange(0, nickname.length))
            lbTitle.attributedText = attr
        }
        else {
            lbTitle.text = result
        }
        lbDate.text = ""
        if let post_datetime = data["post_datetime"] as? String {
            let df = CDateFormatter.init()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = df.date(from: post_datetime) {
                df.dateFormat = "yyyy.MM.dd HH:mm"
                lbDate.text = df.string(from: date)
            }
        }
        
        if let files = data["files"] as? Array<[String:Any]>, files.isEmpty == false {
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
            layout.minimumLineSpacing = 20
//            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            collectionView.collectionViewLayout = layout
            collectionView.reloadData()
            layout.delegate = self
            self.indexPath = IndexPath(row: 0, section: 0)
        }
        else {
            collectionView.isHidden = true
        }
    }
    
    @IBAction func onClickedBtnActions(_ sender: UIButton) {
        if sender == btnArrowRight {
            var index = indexPath.row + 1
            if index >= arrFile.count {
                index = arrFile.count-1
            }
            self.indexPath = IndexPath(row: index, section: 0)
            self.collectionView.scrollToItem(at:indexPath , at: .right, animated: true)
        }
        else if sender == btnArrowLeft {
            var index = indexPath.row - 1
            if index < 0 {
                index = 0
            }
            self.indexPath = IndexPath(row: index, section: 0)
            self.collectionView.scrollToItem(at:indexPath , at: .left, animated: true)
        }
    }
    
}
extension MyQnaView: UICollectionViewDataSource, UICollectionViewDelegate, CustomColFlowLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFile.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QnaColCell", for: indexPath) as! QnaColCell
        if let data = arrFile[indexPath.row] as? [String:Any] {
            cell.configurationData(data, type)
        }
        return cell
    }
    func didEndDecelatedFloawLayout(_ indexPath: IndexPath, _ point: CGPoint) {
        self.indexPath = indexPath
    }
}

