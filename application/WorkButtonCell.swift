//
//  WorkButtonCell.swift
//  application
//
//  Created by sitech on 2020/6/24.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkButtonCell: UITableViewCell {
    
    @IBOutlet var button:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4
    }
    
    func setModel(model:WorkModel){
        
    }
    
    @IBAction func buttonClick(sender:UIButton){
        
        
    }
    
}
