//
//  CustomerInfoCell.swift
//  application
//
//  Created by sitech on 2020/6/24.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class CustomerInfoCell: UITableViewCell {
    
    @IBOutlet var customerName:UILabel!
    @IBOutlet var customerPhone:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
    }
    
    func setModel(model:WorkModel) -> Void {
        
    }

    
}
