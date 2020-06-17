//
//  Cookie.swift
//  iom365
//
//  Created by piggybear on 2018/1/26.
//  Copyright © 2018年 piggybear. All rights reserved.
//

import Foundation

class Cookie: NSObject, NSCoding {
    
    /// cookie 的名称
    let name: String!
    
    /// cookie 的值
    let value: String!
    
    /// cookie 的域名
    let domain: String!
    
    /// 是否通过安全的 HTTPS 连接来传输 cookie
    let isSecure: Bool!
    
    /// cookie 的服务器路径
    let path: String!
    
    /// cookie 的有效期
    var expires: Date!
    
    /*!
     @abstract返回接收者是否只能被发送到HTTP服务器
     根据RFC 2965
     @discussion Cookies可能被服务器（或JavaScript）标记为HTTPOnly。
     标记为这样的Cookie只能通过HTTP请求中的HTTP头发送
     用于匹配各个Cookie的路径和域的URL。
     具体来说，这些cookie不应该被传递给任何JavaScript
     应用程序来防止跨站点脚本漏洞。
     @result如果这个cookie只能通过HTTP头发送，否则否。
     */
    var isHTTPOnly: Bool!
    
    class func archiverPath() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        return documentPath! + "/cookie"
    }
    
    class func archiver(_ cookie: Cookie) {
        NSKeyedArchiver.archiveRootObject(cookie, toFile: archiverPath())
    }
    
    class func unarchiver() ->Cookie? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: archiverPath()) as? Cookie
    }
    
    class func setCookie() {
        let cookieModel: Cookie! = Cookie.unarchiver()
        if cookieModel == nil {
            return
        }
        let cookie = HTTPCookie(properties: [.name: cookieModel.name,
                                .value: cookieModel.value,
                                .domain: cookieModel.domain,
                                .path: cookieModel.path])
        HTTPCookieStorage.shared.setCookie(cookie!)
    }
    
    init(name: String?, value: String?, domain: String?, isSecure: Bool?, path: String?) {
        self.name        = name
        self.value       = value
        self.domain      = domain
        self.isSecure    = isSecure
        self.path        = path
    }
    
    func encode(with aCoder: NSCoder) {
        if let name = name {
            aCoder.encode(name, forKey: "name")
        }
        if let value = value {
            aCoder.encode(value, forKey: "value")
        }
        if let domain = domain {
            aCoder.encode(domain, forKey: "domain")
        }
        if let isSecure = isSecure {
            aCoder.encode(isSecure, forKey: "isSecure")
        }
        if let path = path {
            aCoder.encode(path, forKey: "path")
        }
        if let expires = expires {
            aCoder.encode(expires, forKey: "expires")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        name        = aDecoder.decodeObject(forKey: "name") as? String
        value       = aDecoder.decodeObject(forKey: "value") as? String
        domain      = aDecoder.decodeObject(forKey: "domain") as? String
        path        = aDecoder.decodeObject(forKey: "path") as? String
        expires     = aDecoder.decodeObject(forKey: "expires") as? Date
        isSecure    = aDecoder.decodeBool(forKey: "isSecure")
    }
}
