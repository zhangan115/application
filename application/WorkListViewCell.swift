//
//  WorkListViewCell.swift
//  application
//
//  Created by sitech on 2020/6/22.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkListViewCell: UITableViewCell {

 lazy var workListItemView : WorkListItemView = {
     let view = WorkListItemView()
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
 
    func setModel(model:WorkModel,requestType:Int){
     workListItemView.setData(workData: model,requestType: requestType)
 }

}
