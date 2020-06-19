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
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var moneyLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(hexString: "#666666")
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var icon:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "wallet_icon_down")
         self.contentView.addSubview(view)
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        timeButton.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(12)
        }
        moneyLabel.snp.updateConstraints{(make) in
            make.top.equalTo(self.timeButton.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(12)
        }
        icon.snp.updateConstraints{(make) in
            make.left.equalTo(self.timeButton.snp.right).offset(4)
            make.centerY.equalTo(self.timeButton)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(chooseTime))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func chooseTime(){
        print("===>")
    }
    
}
