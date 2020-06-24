//
//  WorkCostCell.swift
//  application
//
//  Created by sitech on 2020/6/24.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkCostCell: UITableViewCell {
    
    @IBOutlet var constLable:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setModel(model:WorkModel){
        self.constLable.text = "￥" + model.cost
    }
    
}
