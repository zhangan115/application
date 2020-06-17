//
//  JSON+Model.swift
//  iom365
//
//  Created by piggybear on 2018/2/27.
//  Copyright © 2018年 piggybear. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON {
    public func toModel<T: Mappable>(type: T.Type) -> T? {
        let model = ModelBean<T>()
        model.mapModel(from: self)
        return model.data
    }
    
    public func toListModel<T: Mappable>(type: T.Type) -> [T]? {
        let model = ModelBean<T>()
        model.mapListModel(from: self)
        return model.listModel
    }
}
