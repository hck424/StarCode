//
//  TutorialViewController.swift
//  PetChart
//
//  Created by 김학철 on 2020/09/26.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnClose: UIButton!
    var curPage: NSInteger = 0 {
        didSet {
            print("set \(curPage)")
            if curPage == 4 {
                btnStart.isHidden = false
            }
            else {
                btnStart.isHidden = true
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        pageControl.numberOfPages = 5
        pageControl.currentPage = curPage
    }

    @IBAction func pageControllerValueChange(_ sender: UIPageControl) {
        curPage = sender.currentPage
        let offsetX: CGFloat = CGFloat(curPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: offsetX, y: scrollView.contentOffset.y), animated: true)
    }
    
    @IBAction func onClickedButtonActions(_ sender: UIButton) {
        if sender == btnStart
            || sender == btnClose {
         
//            UserDefaults.standard .setValue("Y", forKey: IsShowTutorial)
//            UserDefaults.standard.synchronize()
//            AppDelegate.instance()?.callMainVc()
        }
    }
}

extension TutorialViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.curPage = NSInteger(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = curPage;
    }
}
