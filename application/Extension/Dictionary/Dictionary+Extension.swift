//
//  Dictionary+Extension.swift
//  iom365
//
//  Created by piggybear on 2018/2/26.
//  Copyright © 2018年 piggybear. All rights reserved.
//

import Foundation

extension Dictionary {
    func toJson() -> String {
        if (!JSONSerialization.isValidJSONObject(self)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
}
