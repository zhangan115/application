//
//  WorkEndItemViewCell.swift
//  application
//
//  Created by sitech on 2020/6/22.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkEndItemViewCell: UITableViewCell {
    
    lazy var workEndItemView : WorkEndItemView = {
        let view = WorkEndItemView()
        self.addSubview(view)
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
        workEndItemView.snp.updateConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    func setModel(model:WorkModel){
        workEndItemView.setData(workData: model)
    }
    
}
