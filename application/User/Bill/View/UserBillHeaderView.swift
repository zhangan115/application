//
//  UserBillHeaderView.swift
//  application
//
//  Created by sitech on 2020/6/18.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class UserBillHeaderView: UITableViewHeaderFooterView {
    
    lazy var timeButton: UIButton = {
        let label = UIButton()
        label.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        label.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        label.setImage(UIImage(named: "wallet_icon_down"), for: .normal)
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var moneyLabel: UILabel = {
        let label = UILabel()
        label.text = "紧急联系人"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(hexString: "#666666")
        self.contentView.addSubview(label)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        timeButton.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(12)
        }
        moneyLabel.snp.updateConstraints{ (make) in
            make.top.equalTo(self.timeButton.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(12)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
