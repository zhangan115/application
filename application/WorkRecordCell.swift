//
//  WorkRecordCell.swift
//  application
//
//  Created by sitech on 2020/7/10.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkRecordCell: UITableViewCell {
    
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var noteLabel:UILabel!
    @IBOutlet var timeLabel:UILabel!
    @IBOutlet weak var noteHeight: NSLayoutConstraint!
    
    @IBOutlet var topView:UIView!
    @IBOutlet var centerView:UIView!
    @IBOutlet var bottomView:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
        topView.backgroundColor = UIColor(hexString: "#DDDDDD")
        bottomView.backgroundColor = UIColor(hexString: "#DDDDDD")
        centerView.layer.masksToBounds = true
        centerView.layer.cornerRadius = 4
    }
    
    func setModel(model:TaskVerifyModel){
        if model.note.count == 0 {
            self.noteLabel.text = ""
            noteHeight.constant = 0
        }else{
            self.noteLabel.text = model.note
            noteHeight.constant = 10
        }
        self.titleLabel.text = model.title
        self.timeLabel.text = dateString(millisecond: TimeInterval(model.date), dateFormat: "yyyy-MM-dd HH:mm:ss")
    }
    
}
