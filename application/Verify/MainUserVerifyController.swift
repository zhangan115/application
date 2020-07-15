//
//  MainUserVerifyController.swift
//  application
//
//  Created by Anson on 2020/6/21.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import SnapKit

class MainUserVerifyController: UIViewController {
    
    lazy var num1 : NumVerifyView = {
        let view = NumVerifyView()
        view.setData(num:1)
        self.bgView.addSubview(view)
        return view
    }()
    
    lazy var num2 : NumVerifyView = {
        let view = NumVerifyView()
        self.bgView.addSubview(view)
        return view
    }()
    
    lazy var num3 : NumVerifyView = {
        let view = NumVerifyView()
        return view
    }()
    
    lazy var content1 : VerifyContentView = {
        let view = VerifyContentView()
        view.setData(num:1)
        self.bgView.addSubview(view)
        return view
    }()
    
    lazy var content2 : VerifyContentView = {
        let view = VerifyContentView()
        view.setData(num:2)
        view.button.tag = 1
        view.button.addTarget(self, action: #selector(verify(sender:)), for: .touchUpInside)
        self.bgView.addSubview(view)
        return view
    }()
    
    lazy var content3 : VerifyContentView = {
        let view = VerifyContentView()
        view.setData(num:3)
        view.button.tag = 2
        view.button.addTarget(self, action: #selector(verify(sender:)), for: .touchUpInside)
        return view
    }()
    
    lazy var bgTitleView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#FFF4F4F4")
        self.view.addSubview(view)
        return view
    }()
    
    lazy var leftLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#BBBBBB")
        self.bgTitleView.addSubview(view)
        return view
    }()
    
    lazy var rightLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#BBBBBB")
        self.bgTitleView.addSubview(view)
        return view
    }()
    
    lazy var titleLabel : UILabel = {
        let view = UILabel()
        view.text = "简单2步，即刻抢单"
        view.textColor = UIColor(hexString: "#FF666666")
        view.font = UIFont.systemFont(ofSize: 14)
        self.bgTitleView.addSubview(view)
        return view
    }()
    
    lazy var closeBtn : UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "home_window_icon_close"), for: .normal)
        view.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        self.bgTitleView.addSubview(view)
        return view
    }()
    
    lazy var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        self.view.addSubview(view)
        return view
    }()
    
    lazy var numLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#F5F4F1")
        self.bgView.insertSubview(view, at: 0)
        return view
    }()
    
    var type:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView(self.type)
    }
    
    func initView(_ type:Int){
        let isShowElectrician = type == 0
        if isShowElectrician {
            self.bgView.addSubview(num3)
            self.bgView.addSubview(content3)
            self.titleLabel.text = "简单3步，即刻抢单"
        }
        bgView.snp.updateConstraints{(make)in
            make.bottom.left.right.equalToSuperview()
            if isShowElectrician {
                make.height.equalTo(192)
            }else{
                make.height.equalTo(133)
            }
        }
        bgTitleView.snp.updateConstraints{(make)in
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
            make.bottom.equalTo(self.bgView.snp.top)
        }
        titleLabel.snp.updateConstraints{(make)in
            make.centerX.centerY.equalToSuperview()
        }
        
        leftLine.snp.updateConstraints{(make)in
            make.width.equalTo(20)
            make.height.equalTo(1)
            make.centerY.equalToSuperview()
            make.right.equalTo(self.titleLabel.snp.left).offset(-10)
        }
        rightLine.snp.updateConstraints{(make)in
            make.width.equalTo(20)
            make.height.equalTo(1)
            make.centerY.equalToSuperview()
            make.left.equalTo(self.titleLabel.snp.right).offset(10)
        }
        closeBtn.snp.updateConstraints{(make)in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
        }
        num1.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(14)
            make.top.equalToSuperview().offset(22)
            make.height.width.equalTo(30)
        }
        num1.setData(num: 1)
        num2.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(14)
            make.top.equalTo(self.num1.snp.bottom).offset(29)
            make.height.width.equalTo(30)
        }
        num2.setData(num: 2)
        if isShowElectrician {
            num3.snp.updateConstraints{(make)in
                make.left.equalToSuperview().offset(14)
                make.height.width.equalTo(30)
                make.top.equalTo(self.num2.snp.bottom).offset(29)
            }
            num3.setData(num: 3)
        }
        
        content1.snp.updateConstraints{(make)in
            make.left.equalTo(num1.snp.right).offset(10)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(44)
            make.right.equalToSuperview().offset(-20)
        }
        content2.snp.updateConstraints{(make)in
            make.left.equalTo(num2.snp.right).offset(10)
            make.top.equalTo(content1.snp.bottom).offset(15)
            make.height.equalTo(44)
            make.right.equalToSuperview().offset(-20)
        }
        if isShowElectrician {
            content3.snp.updateConstraints{(make)in
                make.left.equalTo(num3.snp.right).offset(10)
                make.height.equalTo(44)
                make.top.equalTo(content2.snp.bottom).offset(15)
                make.right.equalToSuperview().offset(-20)
            }
        }
        numLine.snp.updateConstraints{(make)in
            make.top.equalToSuperview().offset(52)
            make.bottom.equalToSuperview().offset(-52)
            make.left.equalToSuperview().offset(28)
            make.width.equalTo(2)
        }
    }
    
    var callback:((Int)->())?
    
    @objc func closeAction(){
        self.dismiss(animated: true, completion: {
            self.callback?(-1)
        })
    }
    
    @objc func verify(sender:UIButton){
        let tag = sender.tag
        self.dismiss(animated: true, completion: {
            self.callback?(tag)
        })
    }
}
