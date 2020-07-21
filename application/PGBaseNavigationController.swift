//
//  PGBaseNavigationController.swift
//  edetection
//
//  Created by piggybear on 02/05/2017.
//  Copyright © 2017 piggybear. All rights reserved.
//

import UIKit
import Foundation

class PGBaseNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarTheme()
        setupNavigationBarButttonTheme()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
        //iOS 11中防止在push时tabBar上移
        if #available(iOS 11.0, *), self.tabBarController != nil {
            var frame: CGRect = (self.tabBarController?.tabBar.frame)!
            frame.origin.y = UIScreen.main.bounds.size.height - frame.size.height
            self.tabBarController?.tabBar.frame = frame
        }
    }

    /**
     设置导航栏主题
     */
    private func setupNavigationBarTheme() {
        let navi = UINavigationBar.appearance()
        navi.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#333333")!, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        navi.isTranslucent = false
        navi.barTintColor = setNaviBarColor()
    }
    
    /**
     设置导航栏按钮主题
     */
    private func setupNavigationBarButttonTheme() {
        let barButtonItem = UIBarButtonItem.appearance()
        let dic = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white]
        barButtonItem.setTitleTextAttributes(dic, for: .normal)
    }
    
    /**
     设置导航栏的颜色
     */
    func setNaviBarColor() -> UIColor? {
        return UIColor.white
    }
}
