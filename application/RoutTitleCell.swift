//
//  RoutTitleCell.swift
//  application
//
//  Created by Anson on 2020/7/7.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class RoutTitleCell: UITableViewCell {
    
    @IBOutlet var titleLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
    }

    func setModel(_ section:Int,model:DataItem){
        titleLabel.text = (section + 1).toString + ". " + model.itemName
    }
    
}
