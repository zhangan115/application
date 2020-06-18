//
//  UserDataSureCell.swift
//  application
//
//  Created by sitech on 2020/6/18.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class UserDataSureCell: UITableViewCell {
    
    @IBOutlet weak var saveBgView:UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        saveBgView.layer.masksToBounds = true
        saveBgView.layer.cornerRadius = 4
    }
    
}
