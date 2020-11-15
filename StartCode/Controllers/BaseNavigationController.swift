//
//  BaseNavigationController.swift
//  PetChart
//
//  Created by 김학철 on 2020/09/26.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

extension BaseNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        print("==== willshow ====")
        if viewController.isEqual(viewControllers.first) {
            viewController.navigationController?.tabBarController?.tabBar.isHidden = false
        }
        else {
            viewController.navigationController?.tabBarController?.tabBar.isHidden = true
        }
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//        print("==== didshow ====")
        if viewController.isEqual(viewControllers.first) {
            viewController.navigationController?.tabBarController?.tabBar.isHidden = false
        }
        else {
            viewController.navigationController?.tabBarController?.tabBar.isHidden = true
        }
    }
}
