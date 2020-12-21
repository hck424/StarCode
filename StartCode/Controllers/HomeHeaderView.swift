//
//  HomeHeaderView.swift
//  StartCode
//
//  Created by 김학철 on 2020/11/15.
//

import UIKit

class HomeHeaderView: UIView {
    var typeIndex = 0
    @IBOutlet weak var bannerView: FSPagerView! {
        didSet {
            
            typeIndex = 0
        }
    }
    var arrBanner:[[String:Any]] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        guard let bannerView = bannerView else {
//            return
//        }
//        commonInit()
    }
    
    func commonInit() {
        self.bannerView.register(UINib(nibName: "BannerCell", bundle: nil), forCellWithReuseIdentifier: "BannerCell")
        self.bannerView.automaticSlidingInterval = 3.0
        self.bannerView.isInfinite = true
        self.bannerView.decelerationDistance = FSPagerView.automaticDistance
        
        let newScale = CGFloat(0.9)
        self.bannerView.itemSize = self.bannerView.frame.size.applying(CGAffineTransform(scaleX: newScale, y: newScale))
        self.bannerView.interitemSpacing = 10
        self.bannerView.delegate = self
        self.bannerView.dataSource = self
    }
    
    func configurationData(_ data: [[String:Any]]?) {
        guard let data = data else {
            return
        }
        self.arrBanner = data
        self.commonInit()
        bannerView.reloadData()
    }
}

extension HomeHeaderView: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return arrBanner.count
    }
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "BannerCell", at: index) as! BannerCell
        if let item = arrBanner[index] as? [String:Any] {
            cell.configurationData(item)
        }
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
        pagerView.deselectItem(at: index, animated: true)
        print("pageview didselcted index: \(index)")
    }
    
}
