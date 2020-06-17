//
//  UserCenterItemView.swift
//  application
//
//  Created by sitech on 2020/6/17.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class UserCenterItemView: UIView {
    
    lazy var label: UILabel = {
        let view = UILabel()
        view.text = "实名认证"
        view.textColor = UIColor(hexString: "#333333")
        view.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(view)
        return view
    }()
    
    lazy var userArror :UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "work_detail_icon_next")
        self.addSubview(view)
        return view
    }()
    
    lazy var label1: UILabel = {
        let view = UILabel()
        view.text = "待认证"
        view.textColor = UIColor(hexString: "#bbbbbb")
        view.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(view)
        return view
    }()
    
    lazy var icon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "user_icon_check")
        self.addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    var item:Int!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 4
        self.backgroundColor = UIColor.white
        let tap = UITapGestureRecognizer(target: self, action: #selector(showInfo))
        addGestureRecognizer(tap)
        label.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        userArror.snp.updateConstraints{(make)in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
        }
        label1.snp.updateConstraints{(make)in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.userArror.snp.left).offset(-12)
        }
        icon.snp.updateConstraints{(make)in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.userArror.snp.left).offset(-12)
        }
    }
    
    func setData(_ item:Int){
        self.item = item
        let user = UserModel.unarchiver()
        if let user = user {
            if item == 0 {
                if user.certificationType! > 0 {
                    label1.isHidden = true
                    icon.isHidden = false
                }else{
                    label1.isHidden = false
                    icon.isHidden = true
                }
            }else{
                if user.certificationType! > 1 {
                    label1.isHidden = true
                    icon.isHidden = false
                }else{
                    label1.isHidden = false
                    icon.isHidden = true
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showInfo(){
        if item == 0 {
            let controller = UserIdentityController()
            self.currentViewController().pushVC(controller)
        }else{
            if UserModel.unarchiver()!.certificationType == 0 {
                let alertController = UIAlertController(title: "请先进行实名认证。", message: "", preferredStyle: .alert)
                let noAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let sureAction = UIAlertAction(title: "确定", style: .default, handler: {(_)->Void in
                    let controller = UserIdentityController()
                    self.currentViewController().pushVC(controller)
                })
                alertController.addAction(noAction)
                alertController.addAction(sureAction)
                self.currentViewController().present(alertController, animated: true, completion: nil)
                return
            }
            let controller = UserElectricianController()
            self.currentViewController().pushVC(controller)
        }
    }
    
}
