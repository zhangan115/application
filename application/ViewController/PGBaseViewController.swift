//
//  PGBaseViewController.swift
//  edetection
//
//  Created by piggybear on 30/04/2017.
//  Copyright © 2017 piggybear. All rights reserved.
//

import UIKit

class PGBaseViewController: BaseHomeController {
    
    var isPresent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButtonLogic()
    }
    
    func backButtonLogic() {
        let button = UIButton(x: 0, y: 0, w: 40, h: 40, target: self, action: #selector(pop))
        button.setImage(UIImage(named: "label_icon_back"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc func pop() {
        if isPresent {
            self.dismiss(animated: true, completion: nil)
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func hiddenNaviBarLine() {
        for item in (self.navBar?.subviews)! {
            if item.className == "_UIBarBackground" {
                item.subviews.first?.isHidden = true
            }
        }
    }
}
