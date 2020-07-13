//
//  UserFreezyController.swift
//  application
//
//  Created by Anson on 2020/6/21.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class UserFreezyController: UIViewController {
    
    lazy var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#000000")
        view.alpha = 0.4
        self.view.addSubview(view)
        return view
    }()
    
    lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        self.view.addSubview(view)
        return view
    }()
    
    lazy var titleContentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#FFCC00")
        self.contentView.addSubview(view)
        return view
    }()
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "冻结提示"
        label.textColor = UIColor(hexString: "#333333")
        label.font = UIFont.systemFont(ofSize: 14)
        self.titleContentView.addSubview(label)
        return label
    }()
    
    lazy var closeButton : UIButton  = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_window_icon_close"), for: .normal)
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        self.titleContentView.addSubview(button)
        return button
    }()
    
    lazy var freezyResonLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(hexString: "#333333")
        label.font = UIFont.systemFont(ofSize: 16)
        self.titleContentView.addSubview(label)
        return label
    }()
    
    lazy var freezyTimeLabel : UILabel = {
        let label = UILabel()
        label.text = "冻结提示"
        label.textColor = UIColor(hexString: "#333333")
        label.font = UIFont.systemFont(ofSize: 14)
        self.titleContentView.addSubview(label)
        return label
    }()
    
    @objc func close(){
        self.dismiss(animated: true, completion: {
            
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func initView(){
        bgView.snp.updateConstraints{(make)in
            make.left.right.top.bottom.equalToSuperview()
        }
        contentView.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(122)
            make.centerX.centerY.equalToSuperview()
        }
        titleContentView.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        titleLabel.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        closeButton.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
        }
        freezyResonLabel.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(20)
        }
        freezyTimeLabel.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(self.freezyResonLabel.snp.bottom).offset(12)
        }
        if let userModel = UserModel.unarchiver() {
            freezyResonLabel.text = userModel.freezeReason
            let timeStr = dateString(millisecond: TimeInterval(userModel.freezeTime ?? 0), dateFormat: "yyyy-MM-dd HH:mm:ss")
            let attrs1 : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14,weight: .medium)
                , NSAttributedString.Key.foregroundColor : UIColor(hexString: "#FF3232")!]
            let attrs2 : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)
                           , NSAttributedString.Key.foregroundColor : UIColor(hexString: "#333333")!]
            let attributedString1 = NSMutableAttributedString(string:timeStr, attributes:attrs1)
            let attributedString2 = NSMutableAttributedString(string:"可再次接单", attributes:attrs2)
            attributedString1.append(attributedString2)
            freezyTimeLabel.attributedText = attributedString1
        }
    }
    
    
}
