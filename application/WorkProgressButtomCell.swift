//
//  WorkProgressButtomCell.swift
//  application
//
//  Created by sitech on 2020/7/9.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import PGActionSheet
import RealmSwift

class WorkProgressButtomCell: UITableViewCell {
    
    @IBOutlet var subButton : UIButton!
    @IBOutlet var checkStateView:UIView!
    @IBOutlet var routView:UIView!
    @IBOutlet var progressLable:UILabel!
    
    @IBOutlet weak var routHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    
    let realm = try! Realm()
    var workModel:WorkModel!
    var subCallBack:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
        subButton.layer.masksToBounds = true
        subButton.layer.cornerRadius = 4
        
        subButton.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        subButton.setTitleColor(UIColor(hexString: "#F6F6F6"), for: .disabled)
        subButton.setBackgroundColor(UIColor(hexString: "#FFCC00")!, forState: .normal)
        subButton.setBackgroundColor(UIColor(hexString: "#CCCCCC")!, forState: .disabled)
        let tap = UITapGestureRecognizer(target: self, action: #selector(showRoutController))
        self.routView.addGestureRecognizer(tap)
    }
    
    func setModel(workModel:WorkModel){
        self.workModel = workModel
        //进行中 没有被终止
        if workModel.taskState == WorkState.WORK_PROGRESS.rawValue && !workModel.isTerminated {
            subButton.isHidden = false
            buttonHeight.constant = 34
        }else{
            subButton.isHidden = true
            buttonHeight.constant = 0
        }
        if workModel.taskState == WorkState.WORK_CHECK.rawValue && !workModel.isTerminated {
            checkStateView.isHidden = false
        }else{
            checkStateView.isHidden = true
        }
        if workModel.taskType == WorkType.WORK_TYPE_ROUT.rawValue {
            routView.isHidden = false
            routHeight.constant = 40
        }else{
            routView.isHidden = true
            routHeight.constant = 0
        }
        let taskId : Int = workModel.taskId
        let objects = self.realm.objects(TaskRoutRealm.self).filter("taskId == \(taskId)")
        if workModel.afterFinishFile != nil {
            if workModel.afterFinishFile?.nodeDataList != nil && !workModel.afterFinishFile!.nodeDataList.isEmpty {
                let count = workModel.afterFinishFile!.nodeDataList.count
                progressLable.text = "完成" + ((objects.count * 100 / count)  ).toString + "%"
            }
        }
    }
    
    @IBAction func sub(_ sender:UIButton){
        self.subCallBack?()
    }
    
    @objc func showRoutController(){
        let controller = WorkRoutController()
        controller.workModel = self.workModel
        controller.callback = {
            self.setModel(workModel: self.workModel)
        }
        self.currentViewController().pushVC(controller)
    }
}
