//
//  MethodCell.swift
//  application
//
//  Created by sitech on 2020/7/10.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class MethodCell: UITableViewCell {

    @IBOutlet var label1:UILabel!
    @IBOutlet var label2:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
    }
    
}
