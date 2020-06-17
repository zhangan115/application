//
//  TestView.swift
//  application
//
//  Created by sitech on 2020/6/17.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class TestView: UIView {
    
    lazy var button2 : UIButton = {
        let button = UIButton()
        button.setTitle("测试Button2", for: .normal)
        button.setBackgroundColor(UIColor.green, forState: .normal)
        button.addTarget(self, action: #selector(fuckIos), for: .touchUpInside)
        self.addSubview(button)
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button2.snp.updateConstraints{(make)in
            make.left.top.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
    }
    
    @objc func fuckIos(){
        print("fuck")
    }
    
}
