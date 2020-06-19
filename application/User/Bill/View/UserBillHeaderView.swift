//
//  UserBillHeaderView.swift
//  application
//
//  Created by sitech on 2020/6/18.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import PGDatePicker
class UserBillHeaderView: UITableViewHeaderFooterView {
    
    lazy var timeButton: UIButton = {
        let label = UIButton()
        label.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        label.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var moneyLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(hexString: "#666666")
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var icon:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "wallet_icon_down")
        self.contentView.addSubview(view)
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        timeButton.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(12)
        }
        moneyLabel.snp.updateConstraints{(make) in
            make.top.equalTo(self.timeButton.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(12)
        }
        icon.snp.updateConstraints{(make) in
            make.left.equalTo(self.timeButton.snp.right).offset(4)
            make.centerY.equalTo(self.timeButton)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(chooseTime))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func chooseTime(){
        showTimePick(0)
    }
    
    var callback:((Int)->())?
    
    private func showTimePick(_ tag :Int) {
        let startDatePickerManager = PGDatePickManager()
        let datePicker = startDatePickerManager.datePicker!
        startDatePickerManager.isShadeBackground = true
        datePicker.tag = tag
        datePicker.delegate = self
        datePicker.datePickerMode = .yearAndMonth
        datePicker.isHiddenMiddleText = false
        datePicker.datePickerType = .segment
        self.currentViewController().present(startDatePickerManager, animated: false, completion: nil)
    }
}

extension UserBillHeaderView: PGDatePickerDelegate {
    
    func datePicker(_ datePicker: PGDatePicker!, didSelectDate dateComponents: DateComponents!) {
        if let date = Calendar.current.date(from: dateComponents) {
            if datePicker.tag == 0 {
                let dateString: String! = self.endOfMonth(year: date.year, month: date.month).toString(format: "yyyy-MM-dd")
                let time = date.toString(format: dateString + " 23:59:59")
                let endTime = date2TimeStamp(time: time, dateFormat: "yyyy-MM-dd HH:mm:ss").toInt
                self.callback?(endTime)
            }
        }
    }
    
    func endOfMonth(year: Int, month: Int, returnEndTime:Bool = false) -> Date {
        let calendar = NSCalendar.current
        var components = DateComponents()
        components.month = 1
        if returnEndTime {
            components.second = -1
        } else {
            components.day = -1
        }
        let endOfYear = calendar.date(byAdding: components,to: startOfMonth(year: year, month:month))!
        return endOfYear
    }
    
    func startOfMonth(year: Int, month: Int) -> Date {
        let calendar = NSCalendar.current
        var startComps = DateComponents()
        startComps.day = 1
        startComps.month = month
        startComps.year = year
        let startDate = calendar.date(from: startComps)!
        return startDate
    }
}
