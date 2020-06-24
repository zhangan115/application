//
//  HeaderWorkEnclosureView.swift
//  application
//
//  Created by sitech on 2020/6/24.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class HeaderWorkEnclosureView: UITableViewHeaderFooterView {
    
    lazy var centerLabel: UILabel = {
        let label = UILabel()
        label.text = "附件"
        label.font = UIFont.systemFont(ofSize: 20,weight: .medium)
        label.textColor = UIColor(hexString: "#333333")
        self.contentView.addSubview(label)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        centerLabel.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(22)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
