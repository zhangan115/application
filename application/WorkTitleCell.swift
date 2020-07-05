//
//  WorkTitleCell.swift
//  application
//
//  Created by sitech on 2020/6/24.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkTitleCell: UITableViewCell {
    
    @IBOutlet var bgView : UIView! // 背景
    @IBOutlet var icons : [UIImageView]! // 背景
    @IBOutlet var line1 : UIView! // 虚线
    @IBOutlet var line2 : UIView! // 实线
    
    @IBOutlet var workState : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setModel(model:WorkModel){
        let bgLayer1 = CAGradientLayer()
        bgLayer1.frame = CGRect(x: 10, y: 16, width: screenWidth-20, height: 94)
        bgLayer1.colors = [UIColor(hexString: "#FFE171")!.cgColor, UIColor(hexString: "#FFC15E")!.cgColor]
        bgLayer1.locations = [0, 1]
        bgLayer1.startPoint = CGPoint(x: 0, y: 0.5)
        bgLayer1.endPoint = CGPoint(x: 0.5, y: 0.5)
        bgLayer1.masksToBounds = true
        bgLayer1.cornerRadius = 4
        self.bgView.layer.addSublayer(bgLayer1)
        drawDashLine(lineView: line1, lineLength: 3, lineSpacing: 3, lineColor: UIColor(hexString: "#666666")!)
    }
    
}
