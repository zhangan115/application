//
//  String+Html.swift
//  iom365
//
//  Created by piggybear on 2018/3/13.
//  Copyright © 2018年 piggybear. All rights reserved.
//

import Foundation
import SDWebImage
import UIKit

extension String {
//    func toRange(_ range: NSRange) -> Range<String.Index>? {
//        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
//        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
//        guard let from = String.Index(from16, within: self) else { return nil }
//        guard let to = String.Index(to16, within: self) else { return nil }
//        return from ..< to
//    }
    
    /**
     根据 正则表达式 截取字符串
     
     - regex: 正则表达式
     
     - returns: 字符串数组
     */
    public func matchesForRegex(regex: String) -> [String]? {
        do {
            let regularExpression = try NSRegularExpression(pattern: regex, options: [])
            let range = NSMakeRange(0, self.count)
            let results = regularExpression.matches(in: self, options: [], range: range)
            let string = self as NSString
            return results.map { string.substring(with: $0.range)}
        } catch {
            return nil
        }
    }
    
    /// 从html字符串中截取img标签
    ///
    /// - Returns: <img src=\"...." title=\"..."/>
    func imgFromHtml() -> [String]? {
        let regex = "<(img|IMG)(.*?)(/>|></img>|>)"
        return self.matchesForRegex(regex: regex)
    }
    
    /// 从html字符串中截取img url
    func imgUrlFromHtml() -> [String] {
        let list = imgFromHtml()
        var urlList: [String] = [String]()
        var array: [String] = []
        if let list = list {
            for item in list {
                if item.split("src=\"").count != 0 {
                    array = item.split("src=\"")
                }else if item.split("src=").count != 0 {
                    array = item.split("src=")
                }
                if array.count >= 2 {
                    let str = array.last
                    let urlString = str?.split("\"").first ?? ""
                    urlList.append(urlString)
                }
            }
        }
        return urlList
    }
    
    func convertUrl() -> String {
        var urlString = ""
        let string = self
        if self.hasPrefix("http") {
            urlString = string
        }else {
            urlString = Config.baseURL.absoluteString + string
        }
        return urlString
    }
    
//    func convertImgUrlInHtml() -> String? {
//        let imgUrlList = imgUrlFromHtml()
//        var htmlString = self
//        for item in imgUrlList {
//            let newString = item.convertUrl().urlEncoded()
//            let imgHtml: String = htmlString.split(item).first ?? ""
//            let range = toRange(NSMakeRange(imgHtml.length, item.length))
//            if let range = range {
//                htmlString = htmlString.replacingCharacters(in: range, with: newString)
//            }
//        }
//        print("\nhtmlString = ", htmlString)
//        return htmlString
//    }
}
