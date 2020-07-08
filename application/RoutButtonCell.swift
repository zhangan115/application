//
//  RoutButtonCell.swift
//  application
//
//  Created by sitech on 2020/7/8.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class RoutButtonCell: UITableViewCell {
    
    @IBOutlet var button:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4
        button.setBackgroundColor(UIColor(hexString: "#FFCC00")!, forState: .normal)
        button.setBackgroundColor(UIColor(hexString: "#CCCCCC")!, forState: .disabled)
        button.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        button.setTitleColor(UIColor(hexString: "#F6F6F6"), for: .disabled)
    }
    
    var callback:(()->())?
    
    @IBAction func buttonAction(){
        callback?()
    }
    
}
