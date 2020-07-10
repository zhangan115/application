//
//  WorkMethodHeaderView.swift
//  application
//
//  Created by sitech on 2020/7/10.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkMethodHeaderView: UITableViewHeaderFooterView {
    
    lazy var bgView:UIView = {
        let view = UIView()
        view.backgroundColor = ColorConstants.tableViewBackground
        self.contentView.addSubview(view)
        return view
    }()
    
    lazy var centerLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15,weight: .medium)
        label.textColor = UIColor(hexString: "#333333")
        self.bgView.addSubview(label)
        return label
    }()
    
    lazy var centerLabel1: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(hexString: "#888888")
        self.bgView.addSubview(label)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = ColorConstants.tableViewBackground
        bgView.snp.updateConstraints{ (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(12)
        }
        centerLabel.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(12)
        }
        centerLabel1.snp.updateConstraints { (make) in
            make.left.equalTo(self.centerLabel.snp.right).offset(0)
            make.bottom.equalTo(self.centerLabel)
        }
    }
    
    func setModel(isFirst:Bool = false,model:WorkMethod){
        if isFirst {
            bgView.snp.updateConstraints{ (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalToSuperview().offset(0)
                make.height.equalTo(12)
            }
        }else{
            bgView.snp.updateConstraints{ (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalToSuperview().offset(0)
                make.height.equalTo(0)
            }
        }
        centerLabel.text = model.headerTitle
        centerLabel1.text = model.headerContent
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
