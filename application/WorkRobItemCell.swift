//
//  WorkRobItemCell.swift
//  application
//
//  Created by sitech on 2020/6/23.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkRobItemCell: UITableViewCell {

    lazy var workListItemView : WorkRobItemView = {
        let view = WorkRobItemView()
        self.addSubview(view)
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
        workListItemView.snp.updateConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
       func setModel(model:WorkModel){
        workListItemView.setData(workData: model)
    }

}
