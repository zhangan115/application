//
//  BaseHomeController.swift
//  iom365
//
//  Created by piggybear on 2018/2/23.
//  Copyright © 2018年 piggybear. All rights reserved.
//

import UIKit

class BaseHomeController: UIViewController,UIGestureRecognizerDelegate {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self == self.navigationController?.viewControllers.first {
            return false
        }
        return true
    }

}
