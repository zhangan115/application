//
//  CustomCalloutView.swift
//  application
//
//  Created by sitech on 2020/6/16.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import SnapKit
class CustomCalloutView: UIView {
    
    lazy var rightView: UIView = {
        let view =  UIView()
        view.layer.masksToBounds = true
        view.alpha = 0
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor(hexString: "#FFF5CD")
        self.addSubview(view)
        return view
    }()
    
    lazy var centerView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "map_bg_line")
        self.addSubview(imageView)
        return imageView
    }()
    
    lazy var disLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(hexString: "#454545")
        self.rightView.addSubview(label)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        centerView.snp.updateConstraints{(make)in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(35)
        }
        rightView.snp.updateConstraints{(make)in
            make.top.equalTo(centerView).offset(3)
            make.left.equalTo(centerView.snp.right).offset(-12)
            make.height.equalTo(24)
            make.width.equalTo(70)
        }
        disLable.snp.updateConstraints{(make)in
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }
    }
    
    func setData(workData:WorkModel,currentLocation:CLLocation){
        if workData.taskType == WorkType.WORK_TYPE_BASE.rawValue{
            centerView.image = UIImage(named: "home_icon_basis")
        }else if workData.taskType == WorkType.WORK_TYPE_ROUT.rawValue{
            centerView.image = UIImage(named: "home_icon_inspection")
        }else{
            centerView.image = UIImage(named: "home_icon_skill")
        }
       let abs = currentLocation.distance(from: CLLocation(latitude: workData.taskLocationLatitude, longitude: workData.taskLocationLongitude))/1000
        let distance = String(format: "%.2f", abs)
        disLable.text = distance + "km"
    }
    
}
