//
//  WorkMoreItemCell.swift
//  application
//
//  Created by sitech on 2020/7/10.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkMoreItemCell: UITableViewCell {
    
    @IBOutlet var label:UILabel!
    @IBOutlet var icon:UIImageView!
    @IBOutlet var bgView:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.backgroundColor = UIColor.white
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 4
    }

}
