//
//  WorkInspectCell.swift
//  application
//
//  Created by sitech on 2020/6/24.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkInspectCell: UITableViewCell {
    
    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    
    @IBOutlet var label3: UILabel!
    @IBOutlet var label4: UILabel!
    @IBOutlet var label5: UILabel!
    @IBOutlet var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
    }
    
    func setModel(model:WorkModel){
        if model.taskState == WorkState.WORK_PROGRESS.rawValue {
            // 有过验收，没有通过
            label1.isHidden = false
            label2.isHidden = false
            label3.isHidden = false
            label3.text = model.lastNote
            label4.isHidden = true
            label5.isHidden = true
            icon.isHidden = false
        }else if model.taskState == WorkState.WORK_CHECK.rawValue {
            //等待验收
            label1.isHidden = true
            label2.isHidden = true
            label3.isHidden = true
            label4.isHidden = false
            label5.isHidden = false
            icon.isHidden = true
        }else if model.taskState == WorkState.WORK_FINISH.rawValue {
            label1.text = "验收通过"
            label3.text = model.lastNote
        }
    }
    
}
