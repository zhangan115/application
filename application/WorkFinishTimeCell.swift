//
//  WorkFinishTimeCell.swift
//  application
//
//  Created by sitech on 2020/6/24.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkFinishTimeCell: UITableViewCell {
    
    @IBOutlet var startTimeLabel : UILabel!
    @IBOutlet var endTimeLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
    }
    
    func setModel(model:WorkModel){
        startTimeLabel.text = dateString(millisecond: TimeInterval( model.actualStartTime ?? 0), dateFormat: "yyyy-MM-dd HH:mm")
        endTimeLabel.text = dateString(millisecond: TimeInterval( model.actualEndTime ?? 0), dateFormat: "yyyy-MM-dd HH:mm")
    }
    
}
