//
//  NetView.swift
//  application
//
//  Created by sitech on 2020/6/22.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import MBProgressHUD
class NetView: UIView {
    
    var callback:(()->())?
    
    lazy var imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "img_internet"))
        self.addSubview(view)
        return view
    }()
    
    lazy var label : UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor(hexString: "#999999")
        view.text = "内容加载失败，请检查网络"
        self.addSubview(view)
        return view
    }()
    
    lazy var button : UIButton = {
        let view = UIButton()
        view.setTitle("重新加载", for: .normal)
        view.setBackgroundColor(UIColor(hexString: "#FFCC00")!, forState: .normal)
        view.setTitleColor(UIColor (hexString: "#333333")!, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.addTarget(self, action: #selector(toRequest), for: .touchUpInside)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
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
        imageView.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(165)
        }
        label.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.imageView.snp.bottom).offset(22)
        }
        button.snp.updateConstraints { (make) in
            make.top.equalTo(self.label.snp.bottom).offset(66)
            make.left.equalToSuperview().offset(60)
            make.right.equalToSuperview().offset(-60)
            make.height.equalTo(44)
        }
    }
    
    @objc func toRequest(){
        callback?()
    }
    
    func showProgress(){
        self.showHUD(message: "加载中...")
    }
    
    func showEmpty(_ emptyText:String = "暂无数据"){
        self.hiddenHUD()
        self.isHidden = false
        self.alpha = 1
        imageView.image = UIImage(named: "public_img_null")
        button.isHidden = true
        label.text = emptyText
    }
    
    func showNetError(){
        self.hiddenHUD()
        self.isHidden = false
        self.alpha = 1
        imageView.image = UIImage(named: "img_internet")
        button.isHidden = false
        label.text = "内容加载失败，请检查网络"
    }
    
    func hideView(){
        self.hiddenHUD()
        self.isHidden = true
        self.alpha = 0
    }
    
}
