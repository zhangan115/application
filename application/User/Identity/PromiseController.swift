//
//  PromiseController.swift
//  application
//
//  Created by Anson on 2020/6/21.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class PromiseController: UIViewController {
    
    lazy var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#000000")
        view.alpha = 0.4
        self.view.insertSubview(view, at: 0)
        return view
    }()
    
    lazy var sureButton : UIButton = {
        let button = UIButton()
        button.setTitle("我已阅读并同意", for: .normal)
        button.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.setBackgroundColor(UIColor(hexString: "#FFCC00")!, forState: .normal)
        button.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4
        self.view.addSubview(button)
        return button
    }()
    
    @objc func sureAction(){
        self.dismissVC(completion: {
             UserDefaults.standard.set(true, forKey: kUserPromise)
        })
    }
    
    lazy var yellowBgUIView : UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        view.backgroundColor = UIColor(hexString: "FFCC00")
        self.view.addSubview(view)
        return view
    }()
    
    
    lazy var titleLabel : UILabel = {
        let view = UILabel()
        view.text = "个人健康承诺书"
        view.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        view.textColor = UIColor(hexString: "#333333")!
        self.yellowBgUIView.addSubview(view)
        return view
    }()
    
    lazy var leftLine : UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(hexString: "#333333")
        self.yellowBgUIView.addSubview(line)
        return line
    }()
    
    lazy var rightLine : UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(hexString: "#333333")
        self.yellowBgUIView.addSubview(line)
        return line
    }()
    
    lazy var whiteBgView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        self.yellowBgUIView.addSubview(view)
        return view
    }()
    
    lazy var bigLabel : UILabel = {
        let view = UILabel()
        view.text = "我已认真阅读以上要求，特此承诺！"
        view.textColor = UIColor(hexString: "#454545")
        view.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.whiteBgView.addSubview(view)
        return view
    }()
    lazy var contentLabel : UILabel = {
        let view = UILabel()
        view.text = "      我承诺，我的身体健康，没有患有心脏病、癫痫、高血压（相关心脑血管等疾病）、突发性眩晕、震颤麻痹、无法自控的精神疾病、痴呆、呼吸系统类疾病。" +
            "没有患有影响身体活动的神经系统等妨碍安全操作疾病。" +
            "没有存在吸食、注射毒品、长期服用依赖性精神药品成瘾尚未戒除。" +
            "我的辨色力、视力、听力、四肢、躯干、血压均正常。" +
        "我的身体健康状况完全可以胜任本平台用户的准入要求，如有隐瞒，导致在工单作业的过程中出现任何由于身体疾病而导致的后果，相关责任均由我本人承担。"
        view.textColor = UIColor(hexString: "#454545")
        view.font = UIFont.systemFont(ofSize: 14)
        view.numberOfLines = 0
        self.whiteBgView.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func initView(){
        bgView.snp.updateConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        sureButton.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-80)
        }
        yellowBgUIView.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(80)
            make.bottom.equalTo(self.sureButton.snp.top).offset(-5)
        }
        titleLabel.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(12)
        }
        leftLine.snp.updateConstraints { (make) in
            make.height.equalTo(2)
            make.width.equalTo(40)
            make.right.equalTo(self.titleLabel.snp.left).offset(-10)
            make.centerY.equalTo(self.titleLabel.snp.centerY)
        }
        rightLine.snp.updateConstraints { (make) in
            make.height.equalTo(2)
            make.width.equalTo(40)
            make.left.equalTo(self.titleLabel.snp.right).offset(10)
            make.centerY.equalTo(self.titleLabel.snp.centerY)
        }
        whiteBgView.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.bottom.equalToSuperview().offset(-15)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(12)
        }
        bigLabel.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
        }
        contentLabel.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
            
        }
    }
    
}
