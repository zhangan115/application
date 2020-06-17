//
//  Tools.swift
//  edetection
//
//  Created by piggybear on 02/05/2017.
//  Copyright © 2017 piggybear. All rights reserved.
//

import Foundation
import PKHUD
import SwiftyJSON
import Moya
import Result

//MARK: - public method

public func showPKHUD (message: String, completion: ((Bool) -> Void)? = nil) {
    HUD.flash(.label(message), delay: 0.5, completion: completion)
}

public func dateString(millisecond: TimeInterval, dateFormat: String) -> String {
    let date = Date(timeIntervalSince1970: millisecond / 1000)
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    return formatter.string(from: date)
}

func getMorningDate(date:Date) -> Date{
    let calendar = NSCalendar.init(identifier: .chinese)
    let components = calendar?.components([.year,.month,.day], from: date)
    return (calendar?.date(from: components!))!
}

public func appDisplayName() -> String {
    let infoDictionary = Bundle.main.infoDictionary
    let displayName: String = infoDictionary!["CFBundleDisplayName"] as! String
    return displayName
}

var getCookie: String {
    let cookieObject = Cookie.unarchiver()
    let name: String = cookieObject?.name ?? ""
    let value: String = cookieObject?.value ?? ""
    let cookie: String = name + "=" + value
    return cookie
}

public func date2TimeStamp(time: String,dateFormat: String) -> Double{
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    let date = formatter.date(from: time)
    if date == nil {
        return 0
    }
    return date!.timeIntervalSince1970 * 1000
}

func dataPath() -> String {
    let data = UserModel.unarchiver()
    let string = data?.userId?.toString
    if let string = string {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path: String = documentPath + "/\(string)/"
        return path
    }
    
    return ""
}
