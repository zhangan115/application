//
//  UIButton+Extension.swift
//  Evpro
//
//  Created by piggybear on 2017/10/24.
//  Copyright © 2017年 piggybear. All rights reserved.
//

import Foundation
import UIKit

enum ButtonImageEdgeInsetsStyle {
    case top        //图片在上
    case bottom     //图片在下
    case left       //图片在左
    case right      //图片在右
}

extension UIButton {
    
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
        self.sd_setImage(with: url!, for: .normal, placeholderImage: image, options: .handleCookies)
    }
    
    func loadNetWorkToBackgroundImage(_ string: String, placeholder: String = "picture_default") {
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
        self.sd_setBackgroundImage(with: url!, for: .normal, placeholderImage: image, options: .handleCookies)
    }
    
    /// 设置图片跟字的显示样式
    ///
    ///   - Parameters:
    ///   - imagePosition: 样式类型
    ///   - titleSpace: 字与图片的间距
    func layout(imagePosition style: ButtonImageEdgeInsetsStyle, titleSpace space: CGFloat) {
        let imageWith: CGFloat! = self.imageView?.frame.size.width
        let imageHeight: CGFloat! = self.imageView?.frame.size.height
        var labelWidth: CGFloat = 0, labelHeight: CGFloat = 0
        labelWidth = (self.titleLabel?.intrinsicContentSize.width)!
        labelHeight = (self.titleLabel?.intrinsicContentSize.height)!
        
        var imageEdgeInsets: UIEdgeInsets = .zero
        var labelEdgeInsets: UIEdgeInsets = .zero
        switch style {
        case .top:
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight - space/2.0, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWith, bottom: -imageHeight - space/2.0, right: 0)
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space/2.0, bottom: 0, right: space/2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: space/2.0, bottom: 0, right: -space/2.0)
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight-space/2.0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight-space/2.0, left: -imageWith, bottom: 0, right: 0)
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+space/2.0, bottom: 0, right: -labelWidth-space/2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWith-space/2.0, bottom: 0, right: imageWith+space/2.0)
        }
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
    
}
