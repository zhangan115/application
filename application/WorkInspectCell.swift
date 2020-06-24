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
        self.backgroundColor = UIColor.white
    }
    
    func setModel(model:WorkModel){
        
    }
    
}
