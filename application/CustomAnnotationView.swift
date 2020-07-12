//
//  CustomAnnotationView.swift
//  iom365
//
//  Created by piggybear on 2018/1/20.
//  Copyright © 2018年 piggybear. All rights reserved.
//

import Foundation
import SnapKit

class CustomAnnotationView: MAAnnotationView {
    
    var calloutView: CustomerCalloutView1!
    
    var workModel: WorkModel!
    var currentLocation: CLLocation!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if (self.isSelected == selected) {
            return
        }
        if selected {
            calloutView = CustomerCalloutView1()
            calloutView.layer.cornerRadius = 12
            self.addSubview(calloutView)
            calloutView.frame = CGRect(x: 0, y: 0, w: 67, h: 24)
            calloutView.center = CGPoint(x: self.bounds.size.width / 2 + self.calloutOffset.x,
                                         y: -calloutView.bounds.size.height / 2 + self.calloutOffset.y)
            let abs = currentLocation.distance(from: CLLocation(latitude: workModel.taskLocationLatitude, longitude: workModel.taskLocationLongitude))/1000
            let distance = String(format: "%.2f", abs)
            calloutView.disLable.text = distance + "km"
        }else {
            calloutView.removeFromSuperview()
        }
        super.setSelected(selected, animated: animated)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view
    }
    
}
