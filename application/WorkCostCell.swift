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
    @IBOutlet var titleLable:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
    }
    
    func setModel(model:WorkModel){
        if model.isTerminated {
            if model.actualFee == nil || model.actualFee.count == 0 {
                titleLable.text = "待客服核算工单费用"
                self.constLable.text = "￥???"
            }else{
                self.constLable.text = "￥" + model.taskFee
            }
        }else{
            self.constLable.text = "￥" + model.taskFee
        }
        
    }
    
}
