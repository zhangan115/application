//
//  URL+Extension.swift
//  Evpro
//
//  Created by piggybear on 2017/11/17.
//  Copyright © 2017年 piggybear. All rights reserved.
//

import Foundation

extension URL {
    /// 将原始的url编码为合法的url
    init?(stringEncoded: String) {
        self.init(string: stringEncoded.urlEncoded())
    }
}
