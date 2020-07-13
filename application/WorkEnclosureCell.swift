//
//  WorkEnclosureCell.swift
//  application
//
//  Created by sitech on 2020/6/24.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkEnclosureCell: UITableViewCell {
    
    @IBOutlet var icon:UIImageView!
    @IBOutlet var label:UILabel!
    var model:TaskAttachment?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
        let tap = UITapGestureRecognizer(target: self, action: #selector(showFileController))
        self.addGestureRecognizer(tap)
    }
    
    func setModel(model:TaskAttachment){
        self.model = model
        label.text = model.fileName
        icon.image = UIImage(named: "icon_ppt")
    }
    
    @objc func showFileController(){
        if model != nil  {
            let controller = CheckFileViewController()
            controller.fileName = self.model!.fileName
            controller.fileUrl = self.model!.fileUrl
            self.currentViewController().pushVC(controller)
        }
    }
    
}
