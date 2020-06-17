//
//  UserInfoView.swift
//  application
//
//  Created by sitech on 2020/6/16.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import SnapKit

class UserInfoView: UIView {
    
    var userModel : UserModel!
    
    lazy var userIcon : UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        self.addSubview(view)
        return view
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#454545")
        label.font = UIFont.systemFont(ofSize: 16)
        self.addSubview(label)
        return label
    }()
    
    lazy var userType: UIView = {
        let layerView = UIView()
        layerView.layer.masksToBounds = true
        layerView.layer.cornerRadius = 9
        self.addSubview(layerView)
        return layerView
    }()
    
    lazy var userTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#999999")
        label.font = UIFont.systemFont(ofSize: 11)
        self.userType.addSubview(label)
        return label
    }()
    
    lazy var userData: UIView = {
        let layerView = UIView()
        layerView.layer.masksToBounds = true
        layerView.layer.cornerRadius = 4
        layerView.backgroundColor = UIColor(hexString: "#FFEACD")
        self.addSubview(layerView)
        return layerView
    }()
    
    lazy var icon1 : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "sidebar_icon_hat_white")
        self.userData.addSubview(view)
        return view
    }()
    
    lazy var userLabel1: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#454545")
        label.font = UIFont.systemFont(ofSize: 16)
        self.userData.addSubview(label)
        return label
    }()
    
    lazy var userLabel2: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#333333")
        label.font = UIFont.systemFont(ofSize: 12)
        self.userData.addSubview(label)
        return label
    }()
    
    lazy var userVerifyBtn: UIButton = {
        let button = UIButton()
        button.setTitle("立即加入", for: .normal)
        button.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setBackgroundColor(UIColor(hexString: "#FFCC00")!, forState: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(verify), for: .touchUpInside)
        self.userData.addSubview(button)
        return button
    }()
    
    lazy var icon2 : UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.image = UIImage(named: "sidebar_card_img_hat_bg")
        view.layer.cornerRadius = 20
        self.userData.addSubview(view)
        return view
    }()
    
    lazy var button1 : UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        button.setImage(UIImage(named: "sidebar_icon_wallet"), for: .normal)
        button.layout(imagePosition: .left, titleSpace: 8)
        button.setTitle("钱包", for: .normal)
        button.addTarget(self, action: #selector(wallet), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(button)
        return button
    }()
    
    lazy var button2 : UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        button.setImage(UIImage(named: "sidebar_icon_learn"), for: .normal)
        button.layout(imagePosition: .left, titleSpace: 8)
        button.setTitle("学习培训", for: .normal)
        button.addTarget(self, action: #selector(study), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(button)
        return button
    }()
    
    lazy var button3 : UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        button.setImage(UIImage(named: "sidebar_icon_help"), for: .normal)
        button.layout(imagePosition: .left, titleSpace: 8)
        button.setTitle("帮助中心", for: .normal)
        button.addTarget(self, action: #selector(help), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(button)
        return button
    }()
    
    lazy var button4 : UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        button.setImage(UIImage(named: "sidebar_icon_sservice"), for: .normal)
        button.setImage(UIImage(named: "sidebar_icon_sservice"), for: .selected)
        button.layout(imagePosition: .left, titleSpace: 8)
        button.setTitle("人工客服", for: .normal)
        button.addTarget(self, action: #selector(service), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(button)
        return button
    }()
    lazy var button5 : UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        button.setImage(UIImage(named: "sidebar_icon_set"), for: .normal)
        button.layout(imagePosition: .left, titleSpace: 8)
        button.setTitle("设置", for: .normal)
        button.addTarget(self, action: #selector(setting), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(button)
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userIcon.snp.updateConstraints{(make)in
            make.left.top.equalToSuperview()
            make.width.height.equalTo(40)
        }
        userNameLabel.snp.updateConstraints{(make)in
            make.top.equalToSuperview()
            make.left.equalTo(self.userIcon.snp.right).offset(10)
        }
        userType.snp.updateConstraints{(make)in
            make.left.equalTo(self.userIcon.snp.right).offset(10)
            make.top.equalTo(self.userNameLabel.snp.bottom).offset(6)
            make.width.equalTo(50)
            make.height.equalTo(18)
        }
        userTypeLabel.snp.updateConstraints{(make)in
            make.centerX.centerY.equalToSuperview()
        }
        userData.snp.updateConstraints{(make)in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.userIcon.snp.bottom).offset(12)
            make.height.greaterThanOrEqualTo(60)
        }
        icon1.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(8)
            make.width.height.equalTo(20)
        }
        userLabel1.snp.updateConstraints{(make)in
            make.left.equalTo(self.icon1.snp.right).offset(8)
            make.centerY.equalTo(self.icon1)
        }
        userLabel2.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(self.icon1.snp.bottom).offset(8)
        }
        icon2.snp.updateConstraints{(make)in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(57)
            make.height.equalTo(46)
        }
        userVerifyBtn.snp.updateConstraints{(make)in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-12)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        
        button1.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(0)
            make.top.equalTo(self.userData.snp.bottom).offset(32)
        }
        button2.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(0)
            make.top.equalTo(self.button1.snp.bottom).offset(25)
        }
        button3.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(0)
            make.top.equalTo(self.button2.snp.bottom).offset(25)
        }
        button4.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(0)
            make.top.equalTo(self.button3.snp.bottom).offset(25)
        }
        button5.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(0)
            make.top.equalTo(self.button4.snp.bottom).offset(25)
        }
    }
    
    func setData(_ model:UserModel){
        userIcon.loadNetWorkImage(model.portraitUrl ?? "", placeholder: "sidebar_img_header_nor")
        if model.realName != nil && model.realName!.count > 0 {
            userNameLabel.text = model.realName
        }else if model.userMobile != nil && model.userMobile!.count > 0 {
            if isPhoneNumber(phoneNumber: model.userMobile!) {
                var str = model.userMobile!
                let startIndex = str.index(str.startIndex, offsetBy:3)
                let endIndex = str.index(str.startIndex, offsetBy:7)
                let range = startIndex...endIndex
                str.replaceSubrange(range, with:"*****")
            }else {
                userNameLabel.text = model.userMobile!
            }
        }else{
            userNameLabel.text = model.username
        }
        if model.certificationType!>0 {
            userTypeLabel.text = "已认证"
            userTypeLabel.textColor = UIColor.white
            userType.backgroundColor = UIColor(hexString: "#00A0FF")
            icon1.image = UIImage(named: "sidebar_icon_hat_blue")
            userLabel2.text = "升级为技术电工，无限制抢单"
            userVerifyBtn.setTitle("", for: .normal)
            userLabel1.text = "基础电工"
            if model.certificationType!>1{
                icon1.image = UIImage(named: "sidebar_icon_hat_yellow")
                var contentText = "立即升级"
                userLabel1.text = "技术电工"
                userVerifyBtn.isHidden = true
                let text1 = getSpecialString(level: model.specialOperationGrade!)
                let text2 = getVocationalString(level: model.vocationalQualificationGrade!)
                if text1 != nil {
                    contentText = text1!
                }
                if text2 != nil {
                    if contentText.count > 0 {
                        contentText = contentText + "\n"
                    }
                    contentText = contentText + text2!
                }
                userLabel2.text = contentText
            }
        }else{
            userLabel1.text = "访客"
            userTypeLabel.text = "未认证"
            userTypeLabel.textColor = UIColor(hexString: "#999999")
            userType.backgroundColor = UIColor(hexString: "#EFEFEF")
            icon1.image = UIImage(named: "sidebar_icon_hat_white")
            userLabel2.text = "加入共享电工，可进行抢单"
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func verify(){
        
    }
    
    @objc func wallet() {
        
    }
    
    @objc func study() {
        
    }
    
    @objc func help() {
        
    }
    
    @objc func service() {
        let alertController = UIAlertController(title: kServicePhone, message:"是否拨打电话?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let sureAction = UIAlertAction(title: "拨打", style: .default, handler: {(_)->Void in
            callPhoneTelpro(phone: kServicePhone)
        })
        alertController.addAction(noAction)
        alertController.addAction(sureAction)
        self.currentViewController().present(alertController, animated: true, completion: nil)
    }
    
    @objc func setting() {
        
    }
}
