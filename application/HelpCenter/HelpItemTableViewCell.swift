//
//  HelpItemTableViewCell.swift
//  application
//
//  Created by sitech on 2020/6/16.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class HelpItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLable:UILabel!
    @IBOutlet weak var contentLable:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
    }
    
}
