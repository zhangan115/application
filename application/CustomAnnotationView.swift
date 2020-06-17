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
    
    lazy var calloutView: CustomCalloutView = {
        let view = CustomCalloutView()
        self.addSubview(view)
        return view
    }()
    
    var workModel: WorkModel!
    var currentLocation: CLLocation?
    
    func setIdexAndModel(model:WorkModel,currentLocation:CLLocation){
        self.workModel = model
        calloutView.setData(workData: model,currentLocation: currentLocation)
    }
    
    func hideRightView(){
        calloutView.rightView.alpha = 0
    }
    
    func showRightView(){
        calloutView.rightView.alpha = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        calloutView.frame = CGRect(x: 0, y: 0, w: 200, h: 35)
        calloutView.center = CGPoint(x: self.bounds.size.width / 2 + self.calloutOffset.x,
                                     y: -calloutView.bounds.size.height / 2 + self.calloutOffset.y)
        self.addSubview(calloutView)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if (self.isSelected == selected) {
            return
        }
        print("===>")
        print(selected)
        super.setSelected(selected, animated: animated)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view
    }
    
}
