//
//  WorkInComeView.swift
//  application
//
//  Created by Anson on 2020/7/11.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkInComeView: UIView {
    
    
    lazy var label : UILabel = {
        let view = UILabel()
        view.textColor = UIColor(hexString: "#666666")
        view.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(view)
        return view
    }()
    
    lazy var label1 : UILabel = {
        let view = UILabel()
        view.textColor = UIColor(hexString: "#FF2020")
        view.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        self.addSubview(view)
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
        }
        label1.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
