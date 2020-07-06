//
//  HeaderWorkEnclosureView.swift
//  application
//
//  Created by sitech on 2020/6/24.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class HeaderWorkEnclosureView: UITableViewHeaderFooterView {
    
    lazy var bgView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        self.contentView.addSubview(view)
        return view
    }()
    
    lazy var centerLabel: UILabel = {
        let label = UILabel()
        label.text = "附件"
        label.font = UIFont.systemFont(ofSize: 20,weight: .medium)
        label.textColor = UIColor(hexString: "#333333")
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
