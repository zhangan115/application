//
//  UIImageView+Extension.swift
//  Evpro
//
//  Created by piggybear on 2017/12/4.
//  Copyright © 2017年 piggybear. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func loadNetWorkImage(_ string: String, placeholder: String = "picture_default") {
        var urlString = ""
        if string.hasPrefix("http") {
            urlString = string
        }else {
            urlString = Config.baseURL.absoluteString + string
        }
        let image = UIImage(named: placeholder)
        let url = URL(string: urlString.urlEncoded())
        if url == nil {
            return
        }
        self.sd_setImage(with: url!, placeholderImage: image, options: .handleCookies)
    }
}
