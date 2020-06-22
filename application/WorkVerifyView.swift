//
//  WorkVerifyView.swift
//  application
//
//  Created by sitech on 2020/6/22.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkVerifyView: UIView {

    lazy var imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "public_img_null"))
        self.addSubview(view)
        return view
    }()
   
    lazy var label : UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor(hexString: "#999999")
        view.text = "您还未认证，完成认证，即刻抢单"
        self.addSubview(view)
        return view
    }()
    
    lazy var button : UIButton = {
        let view = UIButton()
        view.setTitle("实名认证", for: .normal)
        view.setBackgroundColor(UIColor(hexString: "#FFCC00")!, forState: .normal)
        view.setTitleColor(UIColor (hexString: "#333333")!, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.addTarget(self, action: #selector(toVerify), for: .touchUpInside)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        self.addSubview(view)
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(50)
        }
        label.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.imageView.snp.bottom).offset(12)
        }
        button.snp.updateConstraints { (make) in
            make.top.equalTo(self.label.snp.bottom).offset(66)
            make.left.equalToSuperview().offset(60)
            make.right.equalToSuperview().offset(-60)
            make.height.equalTo(44)
        }
    }
    
    @objc func toVerify(){
        let controller = UserIdentityController()
        self.currentViewController().pushVC(controller)
    }
}
