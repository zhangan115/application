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
    var workModel:WorkModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
        let tap = UITapGestureRecognizer(target: self, action: #selector(showEndController))
        self.contentView.addGestureRecognizer(tap)
    }
    
    func setModel(model:WorkModel){
        self.workModel = model
        endReasonLabel.text = model.terminateReason
    }
    
    @objc func showEndController(){
        let controller = WorkEndController()
        controller.workModel = self.workModel
        controller.stopReson = self.workModel.terminateReason
        self.currentViewController().pushVC(controller)
    }
    
}
