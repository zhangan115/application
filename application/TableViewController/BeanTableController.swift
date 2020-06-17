//
//  BeanTableController.swift
//  iom365
//
//  Created by piggybear on 2018/2/28.
//  Copyright © 2018年 piggybear. All rights reserved.
//

import UIKit

class BeanTableController: UITableViewController,UIGestureRecognizerDelegate {
    
    var isCanFinish = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    func hiddenNaviBarLine() {
        for item in (self.navBar?.subviews)! {
            if item.className == "_UIBarBackground" {
                item.subviews.first?.isHidden = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self == self.navigationController?.viewControllers.first {
            return isCanFinish
        }
        return true
    }
    
}

