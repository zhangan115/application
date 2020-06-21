//
//  VerifyContentVIew.swift
//  application
//
//  Created by Anson on 2020/6/21.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class VerifyContentView: UIView {
    
    lazy var label : UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(view)
        return view
    }()
    
    lazy var imageView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "home_window_icon_check")
        view.isHidden = true
        self.addSubview(view)
        return view
    }()
    
    lazy var button : UIButton = {
        let view = UIButton()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 2
        view.setTitle("去完成", for: .normal)
        view.setTitle("待完成", for: .disabled)
        view.setBackgroundColor(UIColor(hexString: "#FFCC00")!, forState: .normal)
        view.setBackgroundColor(UIColor(hexString: "#CCCCCC")!, forState: .disabled)
        view.setTitleColor(UIColor(hexString: "#454545"), for: .normal)
        view.setTitleColor(UIColor(hexString: "#F6F6F6"), for: .disabled)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        view.isHidden = true
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
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 4
        label.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        button.snp.updateConstraints{(make)in
            make.centerY.equalToSuperview()
            make.width.equalTo(62)
            make.height.equalTo(32)
            make.right.equalTo(-16)
        }
        imageView.snp.updateConstraints{(make)in
            make.centerY.equalToSuperview()
            make.width.equalTo(16)
            make.height.equalTo(16)
            make.right.equalTo(-16)
        }
    }
    
    func setData(num:Int){
        if let user = UserModel.unarchiver() {
            if num == 1 {
                label.text = "完成注册"
                label.textColor = UIColor(hexString: "#333333")
                imageView.isHidden = false
                self.backgroundColor = UIColor(hexString: "#FFCC00")
            }
            if num == 2 {
                label.text = "实名认证"
                button.isEnabled = true
                if user.certificationType! == 0 {
                    label.textColor = UIColor(hexString: "#454545")
                    self.backgroundColor = UIColor(hexString: "#F1F1F1")
                    button.isHidden = false
                }else{
                    label.textColor = UIColor(hexString: "#333333")
                    self.backgroundColor = UIColor(hexString: "#FFCC00")
                    imageView.isHidden = false
                }
            }
            if num == 3 {
                label.text = "资格认证"
                label.textColor = UIColor(hexString: "#454545")
                imageView.isHidden = true
                self.backgroundColor = UIColor(hexString: "#F1F1F1")
                button.isHidden = false
                if user.certificationType! == 1 {
                    label.textColor = UIColor(hexString: "#454545")
                    button.isHidden = false
                }else{
                    label.textColor = UIColor(hexString: "#333333")
                    button.isEnabled = false
                }
            }
        }
    }
    
}
