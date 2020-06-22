//
//  UITableView+Extension.swift
//  Evpro
//
//  Created by piggybear on 2017/10/24.
//  Copyright © 2017年 piggybear. All rights reserved.
//

import Foundation
import UIKit

private var kUITableViewCornerKey: String = ""
extension UITableView {
    
    func showLoading(){
        let netView = NetView(frame: self.bounds)
        self.backgroundView = netView
        netView.showProgress()
    }
    
    func safeReloadData() {
        reloadData()
        if self.backgroundView != nil {
            if let netView = self.backgroundView as? NetView {
                netView.hideView()
            }
        }
        if self.isEmpty() {
            let netView = NetView(frame: self.bounds)
            netView.showEmpty("暂无数据，下拉重新加载")
            self.backgroundView = netView
        }else {
            self.backgroundView = nil
        }
    }
    
    func noRefreshReloadData() {
        reloadData()
        if self.backgroundView != nil {
            if let netView = self.backgroundView as? NetView {
                netView.hideView()
            }
        }
        if self.isEmpty() {
            let netView = NetView(frame: self.bounds)
            netView.showEmpty("暂无数据")
            self.backgroundView = netView
        }else {
            self.backgroundView = nil
        }
    }
    
    func reloadDataWithStr(_ str:String){
        reloadData()
        if self.backgroundView != nil {
            if let netView = self.backgroundView as? NetView {
                netView.hideView()
            }
        }
        if self.isEmpty() {
            let netView = NetView(frame: self.bounds)
            netView.showEmpty(str)
            self.backgroundView = netView
        }else {
            self.backgroundView = nil
        }
    }
    
    func isEmpty() -> Bool {
        let sections = self.numberOfSections
        var isEmpty = true
        for item in 0..<sections {
            let rows = self.numberOfRows(inSection: item)
            if rows != 0 {
                isEmpty = false
                break
            }
        }
        return isEmpty
    }
    
    func sectionsNoReloadData() {
        reloadData()
        if self.backgroundView != nil {
            if let netView = self.backgroundView as? NetView {
                netView.hideView()
            }
        }
        if self.numberOfSections == 0 {
            let netView = NetView(frame: self.bounds)
            netView.showEmpty()
            self.backgroundView = netView
        }else {
            self.backgroundView = nil
        }
    }
}

class EmptyView: UIView {
    var button: UIButton!
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        setupButton(title: title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width: CGFloat = 170
        let height: CGFloat = 120
        button.frame = CGRect(x: (self.bounds.size.width - width) / 2, y: (self.bounds.size.height - height) / 2, width: width, height: height)
        button.layout(imagePosition: .top, titleSpace: 32)
    }
    
    func setupButton(title: String) {
        button = UIButton(type: .custom)
        button.setImage(UIImage(named: "public_img_null"), for: .normal)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(hexString: "#929eb5"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(button)
    }
}

