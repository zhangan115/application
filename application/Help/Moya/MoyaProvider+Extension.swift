//
//  MoyaProvider+Extension.swift
//  iom365
//
//  Created by piggybear on 2018/2/26.
//  Copyright © 2018年 piggybear. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

extension MoyaProvider {
    func requestResult(_ target: Target, success: @escaping PGProvider.Success, failure: PGProvider.Failure) {
        request(target){ (result) in
            switch result {
            case .success(let responseObject):
                PGProvider.successLogic(responseObject: responseObject, success: success, failure: failure, relogin: {
                    self.requestResult(target, success: success, failure: failure)
                })
            case let .failure(err):
                PGProvider.errorLogic(err)
                guard failure != nil else {
                    return
                }
                if let failure = failure {
                    failure(err)
                }
            }
        }
    }
    
    func requestResult(_ target: Target, success: @escaping PGProvider.Success) {
        request(target){ (result) in
            switch result {
            case .success(let responseObject):
                PGProvider.successLogic(responseObject: responseObject, success: success, failure: nil, relogin: {
                    self.requestResult(target, success: success, failure: nil)
                })
            case let .failure(err):
                PGProvider.errorLogic(err)
            }
        }
    }
}
