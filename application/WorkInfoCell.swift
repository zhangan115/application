//
//  WorkInfoCell.swift
//  application
//
//  Created by sitech on 2020/6/24.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import MapKit
import Contacts
class WorkInfoCell: UITableViewCell {
    
    @IBOutlet var labels:[UILabel]!
    @IBOutlet var workTypeBtn:UIButton!
    var workData:WorkModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
    }
    
    func setModel(model:WorkModel){
        self.workData = model
        self.workTypeBtn.layer.masksToBounds = true
        self.workTypeBtn.layer.cornerRadius = 10
        if model.taskType == WorkType.WORK_TYPE_BASE.rawValue {
            self.workTypeBtn.setTitle("基础单", for: .normal)
            self.workTypeBtn.setBackgroundColor(UIColor(hexString: "#FFCC00")!, forState: .normal)
        }else if model.taskType == WorkType.WORK_TYPE_ROUT.rawValue {
            self.workTypeBtn.setTitle("巡检单", for: .normal)
            self.workTypeBtn.setBackgroundColor(UIColor(hexString: "#00A0FF")!, forState: .normal)
        }else{
            self.workTypeBtn.setTitle("技术单", for: .normal)
            self.workTypeBtn.setBackgroundColor(UIColor(hexString: "#FF3232")!, forState: .normal)
        }
        labels[0].text = model.taskName
        labels[1].text = getDistance(model)
        labels[2].text = model.taskLocation
        labels[3].text = dateString(millisecond: TimeInterval(model.planStartTime), dateFormat: "yyyy-MM-dd HH:mm:ss")
        labels[4].text = dateString(millisecond: TimeInterval(model.planEndTime), dateFormat: "yyyy-MM-dd HH:mm:ss")
        labels[5].text = model.equipmentType
        labels[6].text = model.equipmentName
        labels[7].text = model.equipmentCode
        labels[8].text = getTaskNeedSkill(model)
        labels[9].text = model.taskContent
    }
    
    @IBAction func showLocation(sender:UIButton){
        goToSystemMap()
    }
    
    func goToSystemMap(){
        let toLocation1 = CLLocationCoordinate2D(latitude: self.workData.taskLocationLatitude, longitude: self.workData.taskLocationLongitude)
        let currentLocation = MKMapItem.forCurrentLocation()
        var address :[String : Any] = [:]
        address[CNPostalAddressStreetKey] = self.workData.taskLocation
        let toLocation = MKMapItem.init(placemark: MKPlacemark.init(coordinate: toLocation1, addressDictionary: address))
        MKMapItem.openMaps(with: [currentLocation, toLocation],launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey:true])
    }
}
