//
//  PGBaseTableView.swift
//  Evpro
//
//  Created by piggybear on 2017/11/17.
//  Copyright © 2017年 piggybear. All rights reserved.
//

import UIKit

class BaseTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.tableFooterView = UIView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

