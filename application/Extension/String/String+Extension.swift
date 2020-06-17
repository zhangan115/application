//
//  String+Extension.swift
//  Evpro
//
//  Created by piggybear on 2017/11/17.
//  Copyright © 2017年 piggybear. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    //验证手机号码是否正确
    func isVaildPhoneNumber() -> Bool {
        if self.count == 0 {
            return false
        }
        let mobile = "^(13[0-9]|15[0-9]|18[0-9]|17[0-9]|147)\\d{8}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        if regexMobile.evaluate(with: self) == true {
            return true
        }else
        {
            return false
        }
    }
    
    // MARK: 汉字 -> 拼音
    func chineseToPinyin() -> String {
        
        let stringRef = NSMutableString(string: self) as CFMutableString
        // 转换为带音标的拼音
        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false)
        // 去掉音标
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false)
        let pinyin = stringRef as String
        
        return pinyin
    }
    
    // MARK: 判断是否含有中文
    func isIncludeChineseIn() -> Bool {
        for (_, value) in self.enumerated() {
            
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        
        return false
    }
    
    // MARK: 获取第一个字符
    func first() -> String {
        let index = self.index(self.startIndex, offsetBy: 1)
        return self.substring(to: index)
    }
    
    func numberOfLines(font: UIFont, width: CGFloat) ->CGFloat {
        let string: NSString = self as NSString
        // 获取单行时候的内容的size
        let singleSize = string.size(withAttributes: [NSAttributedString.Key.font: font])
        // 获取多行时候,文字的size
        let textSize = string.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)),
                                           options: .usesLineFragmentOrigin,
                                           attributes: [NSAttributedString.Key.font: font],
                                           context: nil)
        // 返回计算的行数
        return ceil( textSize.height / singleSize.height)
    }
    

}
