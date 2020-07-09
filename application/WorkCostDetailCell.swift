//
//  WorkCostDetailCell.swift
//  application
//
//  Created by sitech on 2020/7/9.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkCostDetailCell: UITableViewCell {
    
    @IBOutlet var constLable1:UILabel!
    @IBOutlet var constLable2:UILabel!
    @IBOutlet var constLable3:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
    }
    
    func setModel(model:WorkModel){
        constLable1.text = "￥" + model.taskFee
        if model.cutFeeDetail == nil || model.cutFeeDetail!.count == 0 {
            constLable2.text = "扣款"
        }else{
            constLable2.text = model.cutFeeDetail!
        }
        let taskFeeFloat = model.taskFee.toFloat()
        let actualFeeFloat = model.actualFee.toFloat()
        if taskFeeFloat != nil && actualFeeFloat != nil {
            let value = taskFeeFloat! - actualFeeFloat!
            constLable3.text =  "-￥" + String(value)
        }else{
            constLable3.text =  "-￥ ???"
        }
        
    }
}
