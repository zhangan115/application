//
//  UIView+Extension.swift
//  Evpro
//
//  Created by piggybear on 2017/11/2.
//  Copyright © 2017年 piggybear. All rights reserved.
//

import UIKit

enum UIViewBorderType {
    case all //四边都有边界线
    case top //只有上面有
    case bottom
    case left
    case right
}

extension UIView {    
    /// 设置边缘线
    ///
    /// - Parameters:
    ///   - type: 类型
    ///   - width: 宽度
    ///   - color: 线条颜色
    func setBorders(_ types: [UIViewBorderType], width: CGFloat, color: UIColor) {
        for item in types {
            switch item {
            case .all:
                self.layer.borderColor = color.cgColor
                self.layer.borderWidth = width
            case .top:
                let frame = CGRect(x: 0, y: 0, w: self.bounds.size.width, h: width)
                var view: UIView!
                let tag = 1001
                if let subView = self.viewWithTag(tag) {
                    view = subView
                }else {
                    view = UIView()
                }
                view.tag = tag
                view.frame = frame
                view.backgroundColor = color
                self.addSubview(view)
            case .bottom:
                let frame = CGRect(x: 0, y: self.bounds.size.height - width, w: self.bounds.size.width, h: width)
                var view: UIView!
                let tag = 1002
                if let subView = self.viewWithTag(tag) {
                    view = subView
                }else {
                    view = UIView()
                }
                view.tag = tag
                view.frame = frame
                view.backgroundColor = color
                self.addSubview(view)
            case .left:
                let frame = CGRect(x: 0, y: 0, w: width, h: self.bounds.size.height)
                var view: UIView!
                let tag = 1003
                if let subView = self.viewWithTag(tag) {
                    view = subView
                }else {
                    view = UIView()
                }
                view.tag = tag
                view.frame = frame
                view.backgroundColor = color
                self.addSubview(view)
            case .right:
                let frame = CGRect(x: self.bounds.size.width-width, y: 0, w: width, h: self.bounds.size.height)
                var view: UIView!
                let tag = 1004
                if let subView = self.viewWithTag(tag) {
                    view = subView
                }else {
                    view = UIView()
                }
                view.tag = tag
                view.frame = frame
                view.backgroundColor = color
                self.addSubview(view)
            }
        }
    }
    
    
    /// 设置边缘线
    ///
    /// - Parameters:
    ///   - type: 类型
    ///   - width: 宽度
    ///   - color: 线条颜色
    func setBorder(_ type: UIViewBorderType, width: CGFloat, color: UIColor) {
        self.layer.backgroundColor = UIColor.clear.cgColor
        var frame = self.frame
        switch type {
        case .all:
            self.layer.borderColor = color.cgColor
            self.layer.borderWidth = width
            return
        case .top:
            frame = CGRect(x: 0, y: 0, w: self.bounds.size.width, h: width)
        case .bottom:
            frame = CGRect(x: 0, y: self.bounds.size.height - width, w: self.bounds.size.width, h: width)
        case .left:
            frame = CGRect(x: 0, y: 0, w: width, h: self.bounds.size.height)
        case .right:
            frame = CGRect(x: self.bounds.size.width-width, y: 0, w: width, h: self.bounds.size.height)
        }
        let layer = CALayer()
        layer.frame = frame
        layer.backgroundColor = color.cgColor
        self.layer.addSublayer(layer)
    }
    
    /// 设置圆角
    ///
    /// - Parameters:
    ///   - rectCorner: 圆角类型
    ///   - radii: 圆角半径
    func setRoundingCorner(_ rectCorner: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: radii, height: radii))
        var maskLayer: CAShapeLayer!
        if self.layer.mask != nil {
            maskLayer = self.layer.mask as? CAShapeLayer
        }else {
            maskLayer = CAShapeLayer()
            self.layer.mask = maskLayer
        }
        maskLayer.path = maskPath.cgPath
        maskLayer.frame = self.bounds
    }
    
    func setHiddenCorners() {
        let maskLayer = CAShapeLayer()
        let maskPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 0)
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}
