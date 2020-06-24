//
//  WorkInfoCell.swift
//  application
//
//  Created by sitech on 2020/6/24.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkInfoCell: UITableViewCell {
    
    @IBOutlet var labels:[UILabel]!
    @IBOutlet var workTypeBtn:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
      
    }


    func setModel(model:WorkModel){
        
    }
    
    @IBAction func showLocation(sender:UIButton){
        
    }

}
