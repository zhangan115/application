//
//  WorkViewController.swift
//  application
//
//  Created by sitech on 2020/6/17.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import SnapKit
class WorkViewController: PGBaseViewController {

    lazy var button1 : UIButton = {
        let button = UIButton()
        button.setTitle("测试Button", for: .normal)
        button.setBackgroundColor(UIColor.red, forState: .normal)
        button.addTarget(self, action: #selector(fuckIos), for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }()
    
    lazy var testView:UIView = {
        let view = TestView()
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "测试UIButton"
        self.view.backgroundColor = UIColor.white
        button1.snp.updateConstraints{(make)in
            make.left.top.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
        testView.snp.updateConstraints{(make)in
            make.top.equalTo(self.button1.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
    }
    
    @objc func fuckIos(){
        print("fuck")
    }
    

}
