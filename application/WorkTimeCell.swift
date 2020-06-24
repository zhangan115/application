//
//  WorkTimeCell.swift
//  application
//
//  Created by sitech on 2020/6/24.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkTimeCell: UITableViewCell {
    
    @IBOutlet var timeTitleLabel : UILabel!
    @IBOutlet var timeLabel : UILabel!
    @IBOutlet var chooseTimeBtn : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
    }
    
    func setModel(model:WorkModel){
        
    }
    
    @IBAction func chooseTime(sender:UIButton){
        
    }

 
}
