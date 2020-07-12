//
//  CustomerCalloutView1.swift
//  application
//
//  Created by sitech on 2020/7/12.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class CustomerCalloutView1: UIView {
    
    lazy var rightView: UIView = {
        let view =  UIView()
        view.layer.masksToBounds = true
        view.alpha = 1
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor(hexString: "#FFF5CD")
        self.addSubview(view)
        return view
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
        rightView.snp.updateConstraints{(make)in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(76)
        }
        disLable.snp.updateConstraints{(make)in
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }
    }
    
    func setData(workData:WorkModel,currentLocation:CLLocation){
        let abs = currentLocation.distance(from: CLLocation(latitude: workData.taskLocationLatitude, longitude: workData.taskLocationLongitude))/1000
        let distance = String(format: "%.2f", abs)
        disLable.text = distance + "km"
    }
}
