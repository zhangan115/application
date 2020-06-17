//
//  Platform.swift
//  iom365
//
//  Created by piggybear on 2018/1/29.
//  Copyright © 2018年 piggybear. All rights reserved.
//

import Foundation

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
