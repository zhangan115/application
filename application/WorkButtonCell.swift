//
//  WorkButtonCell.swift
//  application
//
//  Created by sitech on 2020/6/24.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import PGDatePicker

class WorkButtonCell: UITableViewCell {
    
    @IBOutlet var button:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4
    }
    
    private var workModel:WorkModel?
    
    func setModel(model:WorkModel){
        self.workModel = model
    }
    
    var callBack:((Int?)->())?
    
    @IBAction func buttonClick(sender:UIButton){
        if self.workModel!.canDo{
            if self.workModel!.taskState == WorkState.WORK_ROB.rawValue {
                let userModel = UserModel.unarchiver()
                      if userModel == nil{
                          return
                      }
                      if userModel!.isFreeze ?? false {
                          let controller = UserFreezyController()
                          controller.modalPresentationStyle = .custom
                          self.currentViewController().present(controller, animated: true, completion: {
                              controller.initView()
                          })
                          return
                      }
                if self.workModel!.taskType == WorkType.WORK_TYPE_ROUT.rawValue {
                     showTimePick(0)
                }else{
                     self.callBack?(nil)
                }
            }else if workModel!.taskState == WorkState.WORK_BEGIN.rawValue {
                self.callBack?(nil)
            }
        }else {
            self.contentView.toast("请完善资质")
        }
    }
    
    private func showTimePick(_ tag :Int) {
        let startDatePickerManager = PGDatePickManager()
        let datePicker = startDatePickerManager.datePicker!
        startDatePickerManager.isShadeBackground = true
        datePicker.tag = tag
        datePicker.delegate = self
        datePicker.datePickerMode = .date
        datePicker.isHiddenMiddleText = false
        datePicker.datePickerType = .segment
        self.currentViewController().present(startDatePickerManager, animated: false, completion: nil)
    }
    
}

extension WorkButtonCell: PGDatePickerDelegate {
    
    func datePicker(_ datePicker: PGDatePicker!, didSelectDate dateComponents: DateComponents!) {
        if let date = Calendar.current.date(from: dateComponents) {
            if datePicker.tag == 0 {
                let dateString: String! = date.toString(format: "yyyy-MM-dd")
                let timeStr = date.toString(format: dateString + " 23:59:59")
                let time = date2TimeStamp(time: timeStr, dateFormat: "yyyy-MM-dd HH:mm:ss").toInt
                DispatchQueue.delay(time: 1.5, execute: {[weak self] in
                    self?.callBack?(time)
                })
            }
        }
    }
}
