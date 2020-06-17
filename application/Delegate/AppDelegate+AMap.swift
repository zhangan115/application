//
//  AppDelegate+AMap.swift
//  iom365
//
//  Created by piggybear on 2018/1/17.
//  Copyright © 2018年 piggybear. All rights reserved.
//

import Foundation
import AMapFoundationKit

extension AppDelegate {
    
    func initAMap() {
        AMapServices.shared().enableHTTPS = true
        AMapServices.shared().apiKey = "f1aa97cb4d9dd5a908c78c834afb53f9"
    }
}
