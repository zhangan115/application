//
//  ModelBean.swift
//  iom365
//
//  Created by piggybear on 2018/2/27.
//  Copyright © 2018年 piggybear. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol Mappable {
    init(fromJson json: JSON!)
}

class ModelBean<T: Mappable> {
    var data: T?
    var errorCode: Int!
    var listModel: [T]?
    
    func mapModel(from json: JSON) {
        if json.isEmpty{
            return
        }
        data = T(fromJson: json["data"])
        errorCode = json["errorCode"].intValue
    }
    
    func mapListModel(from json: JSON) {
        if json.isEmpty{
            return
        }
        let list = json["data"].arrayValue
        var models: [T] = [T]()
        for item in list {
            models.append(T(fromJson: item))
        }
        listModel = models
        errorCode = json["errorCode"].intValue
    }
}
