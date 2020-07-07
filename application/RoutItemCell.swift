//
//  RoutItemCell.swift
//  application
//
//  Created by Anson on 2020/7/7.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class RoutItemCell: UITableViewCell {
    
    @IBOutlet var button:UIButton!
    @IBOutlet var label:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
    }

    func setModel(value:String?){
        button.isSelected = value == label.text
    }
    
}
