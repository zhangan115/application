//
//  WorkTimeCell.swift
//  application
//
//  Created by sitech on 2020/6/24.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import PGDatePicker
class WorkTimeCell: UITableViewCell {
    @IBOutlet var timeBlackLabel : UILabel!
    @IBOutlet var timeTitleLabel : UILabel!
    @IBOutlet var timeLabel : UILabel!
    @IBOutlet var chooseTimeBtn : UIButton!
    var callBack:((Int)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
    }
    
    func setModel(model:WorkModel){
        if model.taskState == WorkState.WORK_BEGIN.rawValue {
            self.timeBlackLabel.text = "预计时间"
            chooseTimeBtn.isHidden = false
            timeTitleLabel.text = "预计作业时间"
            if model.taskType == WorkType.WORK_TYPE_ROUT.rawValue {
                timeLabel.text = dateString(millisecond: TimeInterval(model.planArriveTime), dateFormat: "yyyy-MM-dd")
            }else{
                timeLabel.text = dateString(millisecond: TimeInterval(model.planStartTime), dateFormat: "yyyy-MM-dd")
            }
        }else{
            self.timeBlackLabel.text = "作业时间"
            chooseTimeBtn.isHidden = true
            timeTitleLabel.text = "作业开始时间"
            if let time = model.actualStartTime {
                timeLabel.text = dateString(millisecond: TimeInterval(time), dateFormat: "yyyy-MM-dd HH:mm")
            }else{
                timeLabel.text =  ""
            }
        }
        if model.isTerminated || model.taskType != WorkType.WORK_TYPE_ROUT.rawValue{
            chooseTimeBtn.isHidden = true
        }
    }
    
    @IBAction func chooseTime(sender:UIButton){
        showTimePick(0)
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
extension WorkTimeCell: PGDatePickerDelegate {
    
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
