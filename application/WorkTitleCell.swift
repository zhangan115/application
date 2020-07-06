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
    @IBOutlet var icons : [UIImageView]!
    @IBOutlet var labels:[UILabel]!
    @IBOutlet var line1 : UIView! // 虚线
    @IBOutlet var line2 : UIView! // 实线
    
    @IBOutlet var workState : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setModel(model:WorkModel){
        let bgLayer1 = CAGradientLayer()
        bgLayer1.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 80)
        bgLayer1.colors = [UIColor(hexString: "#FFE171")!.cgColor, UIColor(hexString: "#FFC15E")!.cgColor]
        bgLayer1.locations = [0, 1]
        bgLayer1.startPoint = CGPoint(x: 0, y: 0.5)
        bgLayer1.endPoint = CGPoint(x: 0.5, y: 0.5)
        self.bgView.layer.addSublayer(bgLayer1)
        line2.backgroundColor = UIColor(hexString: "#333333")
        drawDashLine(lineView: line1, lineLength: 3, lineSpacing: 3, lineColor: UIColor(hexString: "#666666")!)
       
        labels[0].textColor = UIColor(hexString: "#333333")
        labels[1].textColor = UIColor(hexString: "#333333")
        labels[2].textColor = UIColor(hexString: "#666666")
        labels[3].textColor = UIColor(hexString: "#666666")
        labels[4].textColor = UIColor(hexString: "#666666")
            
        icons[0].image = UIImage(named: "detail_circuit_icon_hook_sel")
        icons[1].image = UIImage(named: "detail_circuit_icon_hook_sel")
        icons[2].image = UIImage(named: "detail_circuit_icon_hook_nor")
        icons[3].image = UIImage(named: "detail_circuit_icon_hook_nor")
        icons[4].image = UIImage(named: "detail_circuit_icon_hook_nor")
     
        let xValue = screenWidth / 10
         line1.frame = CGRect(x: xValue, y: 0, width: screenWidth / 5 * 4, height: 1)
        line2.frame = CGRect(x: xValue, y: 0, width: screenWidth / 5, height: 1)
        
        if model.taskState >= WorkState.WORK_PROGRESS.rawValue {
            icons[2].image = UIImage(named: "detail_circuit_icon_hook_sel")
            labels[2].textColor = UIColor(hexString: "#333333")
           line2.frame = CGRect(x: xValue, y: 0, width: screenWidth / 5 * 2, height: 1)
        }
        if model.taskState >= WorkState.WORK_CHECK.rawValue {
            icons[3].image = UIImage(named: "detail_circuit_icon_hook_sel")
            labels[3].textColor = UIColor(hexString: "#333333")
            line2.frame = CGRect(x: xValue, y: 0, width: screenWidth / 5 * 3, height: 1)
        }
        if model.taskState >= WorkState.WORK_FINISH.rawValue {
            icons[4].image = UIImage(named: "detail_circuit_icon_hook_sel")
            labels[4].textColor = UIColor(hexString: "#333333")
           line2.frame = CGRect(x: xValue, y: 0, width: screenWidth / 5 * 4, height: 1)
        }
        
    }
    
}
