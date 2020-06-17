//
//  BottomWorkView.swift
//  application
//
//  Created by sitech on 2020/6/15.
//  Copyright © 2020 Sitop. All rights reserved.
//

import Foundation
class BottomWorkView: UIView {
    
    lazy var raibWorkBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_icon_grab_small"), for: .normal)
        button.addTarget(self, action: #selector(raibWork), for: .touchUpInside)
        self.addSubview(button)
        return button
    }()
    
    lazy var serviceBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_icon_service_small"), for: .normal)
        button.addTarget(self, action: #selector(showService), for: .touchUpInside)
        self.addSubview(button)
        return button
    }()
    
    lazy var locationBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_icon_position_small"), for: .normal)
        button.addTarget(self, action: #selector(location), for: .touchUpInside)
        self.addSubview(button)
        return button
    }()
    
    lazy var refreshBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_icon_refresh_small"), for: .normal)
        button.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        self.addSubview(button)
        return button
    }()
    
    lazy var workDataView :WorkDataView = {
        let view  = WorkDataView()
        view.tapClosure = {(index)in
            self.tapClosure?(index)
        }
        self.addSubview(view)
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        workDataView.snp.updateConstraints{(make)in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(208)
        }
        raibWorkBtn.snp.updateConstraints{(make)in
            make.bottom.equalTo(self.workDataView.snp.top).offset(-8)
            make.left.equalToSuperview().offset(8)
            make.width.equalTo(98)
            make.height.equalTo(31)
            make.top.greaterThanOrEqualToSuperview().offset(10)
        }
        refreshBtn.snp.updateConstraints{(make)in
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalTo(self.workDataView.snp.top).offset(-8)
            make.height.width.equalTo(31)
            make.top.greaterThanOrEqualToSuperview().offset(10)
        }
        locationBtn.snp.updateConstraints{(make)in
            make.right.equalTo(self.refreshBtn.snp.left).offset(-8)
            make.bottom.equalTo(self.workDataView.snp.top).offset(-8)
            make.height.width.equalTo(31)
            make.top.greaterThanOrEqualToSuperview().offset(10)
        }
        serviceBtn.snp.updateConstraints{(make)in
            make.right.equalTo(self.locationBtn.snp.left).offset(-8)
            make.bottom.equalTo(self.workDataView.snp.top).offset(-8)
            make.height.width.equalTo(31)
            make.top.greaterThanOrEqualToSuperview().offset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tapClosure: ((Int)->())?
    
    //客服
    @objc func showService(){
        tapClosure?(3)
    }
    //抢单
    @objc func raibWork(){
        tapClosure?(0)
    }
    //位置
    @objc func location(){
        tapClosure?(1)
    }
    //刷新
    @objc func refresh(){
        tapClosure?(2)
    }
    
}
