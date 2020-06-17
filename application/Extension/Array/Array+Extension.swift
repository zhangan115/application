
//
//  Array+Extension.swift
//  Evpro
//
//  Created by piggybear on 2017/11/16.
//  Copyright © 2017年 piggybear. All rights reserved.
//

import Foundation

extension Array {
    /// 去重
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
    
    func setAll(_ element: (Int, Element)->()) {
        for (index, value) in self.enumerated() {
            element(index, value)
        }
    }
    
    func toJson() -> String {
        if (!JSONSerialization.isValidJSONObject(self)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try! JSONSerialization.data(withJSONObject: self,
                                                         options: JSONSerialization.WritingOptions.prettyPrinted) as NSData?
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    
    mutating func merge(_ array: Array) {
        self += array
    }
}
