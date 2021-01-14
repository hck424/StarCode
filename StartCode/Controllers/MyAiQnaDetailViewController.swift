//
//  MyAiQnaDetailViewController.swift
//  StartCode
//
//  Created by 김학철 on 2021/01/13.
//

import UIKit

class MyAiQnaDetailViewController: BaseViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var svQuestion: UIStackView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var svAnswer: UIStackView!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var lbAwerExpert: UILabel!
    @IBOutlet weak var lbItemRecomend: UILabel!
    @IBOutlet weak var svItemRecomend: UIStackView!
    @IBOutlet weak var lbRecomendExpert: UILabel!
    @IBOutlet weak var svRecomentExpert: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: "ExpertColCell", bundle: nil), forCellWithReuseIdentifier: "ExpertColCell")
        }
    }
    var arrData:Array<[String:Any]> = []
    var type:QnaType = .oneToQna
    var data:[String:Any]?
    var aiResult:[String:Any]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CNavigationBar.drawBackButton(self, "Ai 질문", #selector(actionPopViewCtrl))
        self.requestMyQuestDetail()
    }
    func requestMyQuestDetail() {
        guard let token = SharedData.instance.token else {
            return
        }
        guard let data = data, let post_id = data["post_id"] as? String else {
            return
        }
        let param = ["token":token, "post_id":post_id]
        
        
        ApiManager.shared.requestAskDetail(param: param) { (response) in
            if let response = response, let data = response["data"] as? [String:Any],
               let code = response["code"] as? Int, code == 200 {
                self.data = data
                self.configurationUi()
            }
            else {
                self.showErrorAlertView(response)
            }
        } failure: { (error) in
            self.showErrorAlertView(error)
        }
    }
    
    func configurationUi() {
        guard let data = data else {
            return
        }
        self.view.layoutIfNeeded()
        let questionView = Bundle.main.loadNibNamed("MyQnaView", owner: self, options: nil)?.first as! MyQnaView
        svQuestion.addArrangedSubview(questionView)
        
        self.view.layoutIfNeeded()
        questionView.questionType = type
        questionView.configurationData(data, .question)
        
        if let aiResult = aiResult {
            svAnswer.isHidden = false
            let ai = "AI"
            let str1 = "\(ai) 님의 답변"
            let str2 = "\(ai) 추천 화장품"
            let str3 = "\(ai) 추천 맞춤 전문가"
            
            
            let attr = NSMutableAttributedString.init(string: str1)
            attr.addAttribute(.foregroundColor, value: RGB(128, 0, 255), range: (str1 as NSString).range(of: ai))
            lbAwerExpert.attributedText = attr
            
            
            let attr2 = NSMutableAttributedString.init(string: str2)
            attr2.addAttribute(.foregroundColor, value: RGB(128, 0, 255), range: (str2 as NSString).range(of: ai))
            lbItemRecomend.attributedText = attr2
            
            let attr3 = NSMutableAttributedString.init(string: str3)
            attr3.addAttribute(.foregroundColor, value: RGB(128, 0, 255), range: (str3 as NSString).range(of: ai))
            lbRecomendExpert.attributedText = attr3
            
            lbContent.text = ""
            if let reco_text = aiResult["reco_text"] as? String {
                lbContent.text = reco_text
            }
            
            lbDate.text = ""
            let df = CDateFormatter.init()
            df.dateFormat = "yyyy.MM.dd HH:mm:ss"
            lbDate.text =  df.string(from: Date())
            
            if let reco_cosmetics = aiResult["reco_cosmetics"] as? [String], reco_cosmetics.isEmpty == false  {
                for item in reco_cosmetics {
                    let sv = UIStackView.init()
                    
                    svItemRecomend.addArrangedSubview(sv)
                    sv.alignment = .center
                    sv.axis = .horizontal
                    sv.spacing = 8
                    
                    if let img  = UIImage(named: "ic_list_check") {
                        let iv = UIImageView.init()
                        sv.addArrangedSubview(iv)
                        
                        iv.image = img
                        
                        iv.translatesAutoresizingMaskIntoConstraints = false
                        iv.widthAnchor.constraint(equalToConstant: img.size.width).isActive = true
                        iv.heightAnchor.constraint(equalToConstant: img.size.height).isActive = true
                    }
                    
                    let lbItem = UILabel.init()
                    sv.addArrangedSubview(lbItem)
                    lbItem.text = item
                    lbItem.font = UIFont.systemFont(ofSize: 14)
                    lbItem.numberOfLines = 0
                }
            }
            
            if let  reco_mentor = aiResult["reco_mentor"] as? Array<[String:Any]>, reco_mentor.isEmpty == false {
                self.arrData = reco_mentor
                
                svRecomentExpert.isHidden = false
                self.view.layoutIfNeeded()
                
                let layout = UICollectionViewFlowLayout.init()
                layout.scrollDirection = .horizontal
                let width:CGFloat = 78+8
                layout.itemSize = CGSize(width: width, height: collectionView.bounds.height)
                layout.minimumLineSpacing = 0
                layout.minimumInteritemSpacing = 0
                collectionView.contentInset = UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 17)
                collectionView.collectionViewLayout = layout
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            else {
                svRecomentExpert.isHidden = true
            }
        }
    }
}

extension MyAiQnaDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpertColCell", for: indexPath) as! ExpertColCell
        
        if let item = arrData[indexPath.row] as?[String:Any] {
            cell.configurationData(item)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
    }
}
