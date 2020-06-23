//
//  WorkListHeaderView.swift
//  application
//
//  Created by sitech on 2020/6/23.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkListHeaderView: UITableViewHeaderFooterView {
    
    lazy var centerLabel: UILabel = {
        let label = UILabel()
        label.text = "紧急联系人"
        label.font = UIFont.systemFont(ofSize: 20,weight: .medium)
        label.textColor = UIColor(hexString: "#333333")
        self.contentView.addSubview(label)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        centerLabel.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(10)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text:String){
        centerLabel.text = text
    }
    
}
