//
//  UserDataChooseCell.swift
//  application
//
//  Created by sitech on 2020/6/18.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class UserDataChooseCell: UITableViewCell {
    
    @IBOutlet weak var bgView:UIView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var contentLable:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 4
    }

}
