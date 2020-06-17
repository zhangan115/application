//
//  Single+Model.swift
//  iom365
//
//  Created by piggybear on 2018/2/23.
//  Copyright © 2018年 piggybear. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya

enum PGError: Error {
    case DataIsNil
    case listModelIsNil
    case exception
}

extension PrimitiveSequence where TraitType == SingleTrait, E == JSON {
    public func toModel<T: Mappable>(type: T.Type) -> Single<T> {
        return flatMap { json -> Single<T> in
            let model = ModelBean<T>()
            model.mapModel(from: json)
            guard let data = model.data else {
                throw PGError.DataIsNil
            }
            return Single.just(data)
        }
    }
    
    public func toListModel<T: Mappable>(type: T.Type) -> Single<[T]> {
        return flatMap({ (json) -> Single<[T]> in
            let model = ModelBean<T>()
            model.mapListModel(from: json)
            guard let list = model.listModel else {
                throw PGError.listModelIsNil
            }
            return Single.just(list)
        })
    }
}
