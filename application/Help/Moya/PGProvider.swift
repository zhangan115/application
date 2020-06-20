//
//  PGProvider.swift
//  edetection
//
//  Created by piggybear on 01/05/2017.
//  Copyright © 2017 piggybear. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import Result
import PKHUD
import RxCocoa
import RxSwift

final class PGProvider: NSObject {
    
    typealias Success = (_ responseJson: JSON) -> Void
    typealias Failure = ((_ error: MoyaError?) -> Void)?
    typealias Relogin = ()->()
    
    class func networkPlugin(_ offset: Bool = false) -> PluginType {
        let networkPlugin = NetworkActivityPlugin { change,_ in
            switch(change){
            case .began:
                NSObject().currentViewController().view.showActivityIndicatorView(offset: offset)
            case .ended:
                NSObject().currentViewController().view.hideActivityIndicatorView()
            }
        }
        return networkPlugin
    }
    
    public class func successLogic (responseObject: Response, success:  @escaping Success, failure: Failure, relogin: @escaping Relogin) {
        let cookie: HTTPCookie? = HTTPCookieStorage.shared.cookies(for: (responseObject.request?.url)!)?.first
        if let cookie = cookie {
            let cookieModel = Cookie(name: cookie.name, value: cookie.value, domain: cookie.domain, isSecure: cookie.isSecure, path: cookie.path)
            Cookie.archiver(cookieModel)
        }
        let statusCode = responseObject.statusCode
        if statusCode == 200 {
            let json = try! JSON(data: responseObject.data)
            let errorCode = json["errorCode"].intValue
            if errorCode == 0 {
                print(json)
                success(json)
            }else {
                if errorCode == -100 || errorCode == -101 { //cookie失效 实现重新登录
                    PGAlamofireManager.cancelAllOperations()
                    showPKHUD(message: json["message"].stringValue, completion: { _ in
                        UserDefaults.standard.set(false, forKey: kIsLogin)
                        if UIApplication.shared.keyWindow?.currentViewController().isKind(of: UserLoginViewController.self) ?? false {
                            return
                        }
                        UIApplication.shared.keyWindow?.rootViewController = PGBaseNavigationController(rootViewController: UserLoginViewController())
                    })
                }else if json["message"].stringValue != "" {
                    showPKHUD(message: json["message"].stringValue)
                    if let failure = failure {
                        failure(nil)
                    }
                }else {
                    showPKHUD(message: "出现了一点小故障，请稍后重试")
                    if let failure = failure {
                        failure(nil)
                    }
                }
            }
        }else{
            showPKHUD(message: "出现了一点小故障，请稍后重试")
            if let failure = failure {
                failure(nil)
            }
        }
    }
    
    public class func errorLogic(_ error: MoyaError) {
        if case let .underlying(error1, nil) = error {
            let error2 = error1 as NSError
            if error2.code == -999 { //如果是取消当前网络请求的话，不做提示
                return
            }else {
                showPKHUD(message: error.errorDescription!)
            }
        }else {
            showPKHUD(message: error.errorDescription!)
        }
    }
}

