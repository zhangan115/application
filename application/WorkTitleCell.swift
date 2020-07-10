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
    
    var line:[UIView] = []
    
    @IBOutlet var workState : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setModel(model:WorkModel){
        let w = (screenWidth - 60 ) / 10 * 8 / 4
        line.append(UIView(x: screenWidth/10 + 6, y: 0, w: w, h: 1))
        line.append(UIView(x: 3 * screenWidth / 10  + 6, y: 0, w:w, h: 1))
        line.append(UIView(x: screenWidth/2 + 6, y: 0, w: w, h: 1))
        line.append(UIView(x: 7 * screenWidth / 10 + 6, y: 0, w: w, h: 1))
        
        drawDashLine(lineView: line[0], lineLength: 3, lineSpacing: 0, lineColor: UIColor(hexString: "#333333")!)
        drawDashLine(lineView: line[1], lineLength: 3, lineSpacing: 3, lineColor: UIColor(hexString: "#666666")!)
        drawDashLine(lineView: line[2], lineLength: 3, lineSpacing: 3, lineColor: UIColor(hexString: "#666666")!)
        drawDashLine(lineView: line[3], lineLength: 3, lineSpacing: 3, lineColor: UIColor(hexString: "#666666")!)
        
        self.line1.addSubviews(line)
        
        let bgLayer1 = CAGradientLayer()
        bgLayer1.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 80)
        if model.isTerminated {
            bgLayer1.colors = [UIColor(hexString: "#E6E6E6")!.cgColor, UIColor(hexString: "#D6D6D6")!.cgColor]
        }else{
            bgLayer1.colors = [UIColor(hexString: "#FFE171")!.cgColor, UIColor(hexString: "#FFC15E")!.cgColor]
        }
        bgLayer1.locations = [0, 1]
        bgLayer1.startPoint = CGPoint(x: 0, y: 0.5)
        bgLayer1.endPoint = CGPoint(x: 0.5, y: 0.5)
        self.bgView.layer.addSublayer(bgLayer1)
        line2.backgroundColor = UIColor(hexString: "#333333")
        
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
        
        if model.taskState >= WorkState.WORK_PROGRESS.rawValue {
            workState.text = "进行中"
            icons[2].image = UIImage(named: "detail_circuit_icon_hook_sel")
            labels[2].textColor = UIColor(hexString: "#333333")
            drawDashLine(lineView: line[1], lineLength: 3, lineSpacing: 0, lineColor: UIColor(hexString: "#333333")!)
            
        }
        if model.taskState >= WorkState.WORK_CHECK.rawValue {
            workState.text = "待验收"
            icons[3].image = UIImage(named: "detail_circuit_icon_hook_sel")
            labels[3].textColor = UIColor(hexString: "#333333")
            drawDashLine(lineView: line[2], lineLength: 3, lineSpacing: 0, lineColor: UIColor(hexString: "#333333")!)
        }
        if model.taskState >= WorkState.WORK_FINISH.rawValue {
            workState.text = "已完成"
            icons[4].image = UIImage(named: "detail_circuit_icon_hook_sel")
            labels[4].textColor = UIColor(hexString: "#333333")
            drawDashLine(lineView: line[3], lineLength: 3, lineSpacing: 0, lineColor: UIColor(hexString: "#333333")!)
        }
        
    }
    
}
