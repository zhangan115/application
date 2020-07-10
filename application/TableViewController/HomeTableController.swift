//
//  HomeTableController.swift
//  iom365
//
//  Created by piggybear on 2018/2/24.
//  Copyright © 2018年 piggybear. All rights reserved.
//

import UIKit

class HomeTableController: BeanTableController {
    
    var isPresent = false
    open var showBackButton = true
    override func viewDidLoad() {
        super.viewDidLoad()
        if showBackButton {
            backButtonLogic()
        }
    }
    
    func backButtonLogic() {
        let button = UIButton(x: 0, y: 0, w: 40, h: 40, target: self, action: #selector(pop))
        button.setImage(UIImage(named: "label_icon_back"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    func rightMoreButton(){
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "work_detail_icon_more"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        button.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        button.addTarget(self, action: #selector(rightBarAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc func rightBarAction(){
        
    }
    
    @objc func pop() {
        if isPresent {
            self.dismiss(animated: true, completion: nil)
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
}
