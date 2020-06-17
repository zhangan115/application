//
//  PGMacros.swift
//  edetection
//
//  Created by piggybear on 30/04/2017.
//  Copyright © 2017 piggybear. All rights reserved.
//

import Foundation
import UIKit

func PGColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
}

func Log<T>(_ message: T){
    #if DEBUG
        print(message)
    #endif
}

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

let isIphoneX = (screenHeight == 812 || screenHeight == 896)
// 适配刘海屏状态栏高度
let CF_StatusBarHeight = (isIphoneX ? 44 : 20)
// 适配iPhone X 导航栏高度
let CF_NavHeight = (isIphoneX ? 88 : 64)
// 适配iPhone X Tabbar距离底部的距离
let TabbarSafeBottomMargin = (isIphoneX ? 34 : 0)
// 适配iPhone X Tabbar高度
let CF_TabbarHeight = (isIphoneX ? (49+34) : 49)
