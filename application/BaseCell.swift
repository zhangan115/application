//
//  PGBaseCell.swift
//  Evpro
//
//  Created by piggybear on 2017/11/17.
//  Copyright © 2017年 piggybear. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#1E296F")
        self.selectedBackgroundView = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
