//
//  WorkEndCell.swift
//  application
//
//  Created by sitech on 2020/6/24.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkEndCell: UITableViewCell {
    
    @IBOutlet var endReasonLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
    }
    
    func setModel(model:WorkModel){
        
    }

    
}
