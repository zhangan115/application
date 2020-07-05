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
        var str = model.customerContact!
        if str.count >= 3 {
            let startIndex = str.index(str.startIndex, offsetBy:str.count-2)
            let endIndex = str.index(str.startIndex, offsetBy:str.count)
            let range = startIndex...endIndex
            str.replaceSubrange(range, with:"**")
        }
        customerName.text = str
        var phoneStr = model.customerPhone!
        if phoneStr.count == 11 {
            let startIndex = str.index(str.startIndex, offsetBy:4)
            let endIndex = str.index(str.startIndex, offsetBy:8)
            let range = startIndex...endIndex
            phoneStr.replaceSubrange(range, with:"****")
        }
        customerPhone.text = phoneStr
    }
    
}
