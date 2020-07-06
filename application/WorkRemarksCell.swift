//
//  WorkRemarksCell.swift
//  application
//
//  Created by sitech on 2020/6/24.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkRemarksCell: UITableViewCell {
    
    @IBOutlet var remarkLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
    }

    func setModel(model:WorkModel){
        remarkLabel.text = model.taskNote
    }
    
}
