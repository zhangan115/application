//
//  MoyaProvider+Rx.swift
//  iom365
//
//  Created by piggybear on 2018/2/26.
//  Copyright © 2018年 piggybear. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

extension MoyaProvider {
    func rxRequest(_ target: Target) -> Single<JSON> {
        weak var weakSelf:MoyaProvider? = self
        return Single<JSON>.create { (single) -> Disposable in
            if weakSelf == nil {
                return Disposables.create()
            }
            let this = weakSelf!
            let cancellableToken = this.request(target){ (result) in
                switch result {
                case .success(let responseObject):
                    PGProvider.successLogic(responseObject: responseObject, success: { (json) in
                        single(.success(json))
                    }, failure: { (error) in
                        if let error = error {
                            single(.error(error))
                        }
                    }, relogin: {
                        self.requestResult(target, success: { (json) in
                            single(.success(json))
                        }, failure: { (error) in
                            if let error = error {
                                single(.error(error))
                            }
                        })
                    })
                case let .failure(error):
                    PGProvider.errorLogic(error)
                    single(.error(error))
                }
            }
            return Disposables.create{
                cancellableToken.cancel()
            }
        }
    }
}
