//
//  WorkEnclosureCell.swift
//  application
//
//  Created by sitech on 2020/6/24.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkEnclosureCell: UITableViewCell {
    
    @IBOutlet var icon:UIImageView!
    @IBOutlet var label:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
    }
    
    func setModel(model:TaskAttachment){
        label.text = model.fileName
        icon.image = UIImage(named: "icon_ppt")
    }
    
}
