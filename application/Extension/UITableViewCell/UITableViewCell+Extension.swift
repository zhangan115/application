//
//  UITableViewCell+Extension.swift
//  Evpro
//
//  Created by piggybear on 2017/11/13.
//  Copyright © 2017年 piggybear. All rights reserved.
//

import UIKit
import Foundation

extension UITableViewCell {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = ColorConstants.tableViewBackground
    }
    
    /// 隐藏分割线
    func setHiddenSeparatorView() {
        for item in self.subviews {
            if item.className == "_UITableViewCellSeparatorView" {
                item.isHidden = true
            }
        }
    }
    
    /// 设置分割线是否需要隐藏
    ///
    /// - Parameter isHidden: 是否需要隐藏
    func setSeparatorView(isHidden: Bool) {
        for item in self.subviews {
            if item.className == "_UITableViewCellSeparatorView" {
                item.isHidden = isHidden
            }
        }
    }
    
    func setFirstRowHiddenSeparatorView() {
        var list: [UIView] = []
        for item in self.subviews {
            if item.className == "_UITableViewCellSeparatorView" {
                item.isHidden = isHidden
                list.append(item)
            }
        }
        list.last?.isHidden = true
//        for (index, value) in list.enumerated() {
//            if index == 0 {
//                value.isHidden = false
//            }else {
//                value.isHidden = true
//            }
//        }
    }
    
    func setFirstSectionHiddenSeparatorView() {
        var list: [UIView] = []
        for item in self.subviews {
            if item.className == "_UITableViewCellSeparatorView" {
                item.isHidden = isHidden
                list.append(item)
            }
        }
        if list.count >= 3 {
            list.last?.isHidden = true
        }
    }
}
