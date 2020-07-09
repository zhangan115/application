//
//  WorkInfoCell.swift
//  application
//
//  Created by sitech on 2020/6/24.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkInfoCell: UITableViewCell {
    
    @IBOutlet var labels:[UILabel]!
    @IBOutlet var workTypeBtn:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
    }
    
    func setModel(model:WorkModel){
        self.workTypeBtn.layer.masksToBounds = true
        self.workTypeBtn.layer.cornerRadius = 10
        if model.taskType == WorkType.WORK_TYPE_BASE.rawValue {
            self.workTypeBtn.setTitle("基础单", for: .normal)
            self.workTypeBtn.setBackgroundColor(UIColor(hexString: "#FFCC00")!, forState: .normal)
        }else if model.taskType == WorkType.WORK_TYPE_ROUT.rawValue {
            self.workTypeBtn.setTitle("巡检单", for: .normal)
            self.workTypeBtn.setBackgroundColor(UIColor(hexString: "#00A0FF")!, forState: .normal)
        }else{
            self.workTypeBtn.setTitle("技术单", for: .normal)
            self.workTypeBtn.setBackgroundColor(UIColor(hexString: "#FF3232")!, forState: .normal)
        }
        labels[0].text = model.taskName
        if model.distance < 3 {
            labels[1].text = "<3km"
        } else if model.distance < 6 && model.distance >= 3{
            labels[1].text = "<6km"
        } else if model.distance < 9 && model.distance >= 6{
            labels[1].text = "<9km"
        } else {
            labels[1].text = ">9km"
        }
        labels[2].text = model.taskLocation
        labels[3].text = dateString(millisecond: TimeInterval(model.planStartTime), dateFormat: "yyyy-MM-dd HH:mm:ss")
        labels[4].text = dateString(millisecond: TimeInterval(model.planEndTime), dateFormat: "yyyy-MM-dd HH:mm:ss")
        labels[5].text = model.equipmentType
        labels[6].text = model.equipmentName
        labels[7].text = model.equipmentCode
        labels[8].text = model.taskContent
    }
    
    @IBAction func showLocation(sender:UIButton){
        
    }
    
}
