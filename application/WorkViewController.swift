//
//  WorkViewController.swift
//  application
//
//  Created by sitech on 2020/6/17.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import SnapKit
class WorkViewController: PGBaseViewController {
    
    private var controllers :[UIViewController] = []
    private var pageTitleView: SGPageTitleView!
    private var pageContentView: SGPageContentView!
    var currentLocation : CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "工单列表"
        hiddenNaviBarLine()
        setupRightButton()
        setupPageView()
    }
    
    func setupPageView() {
        let configure = SGPageTitleViewConfigure()
        configure.indicatorScrollStyle = SGIndicatorScrollStyleHalf
        configure.titleFont = UIFont.systemFont(ofSize: 15)
        configure.titleColor = UIColor(hexString: "#333333")
        
        configure.titleSelectedColor = UIColor(hexString: "#333333")
        configure.indicatorColor = UIColor(hexString: "#FFCC00")
        var titleViewFrame = view.bounds
        titleViewFrame.size.height = 45
        
        let titleList = ["待开始", "进行中","待验收","已完成"]
        pageTitleView = SGPageTitleView(frame: titleViewFrame, delegate: self, titleNames: titleList, configure: configure)
        pageTitleView.isShowBottomSeparator = false
        pageTitleView.backgroundColor = UIColor.white
        view.addSubview(pageTitleView)
        
        let begin = WorkListController()
        begin.currentIndex = 3
        begin.currentLocation = self.currentLocation
        controllers.append(begin)
        let progress = WorkListController()
        progress.currentIndex = 4
        progress.currentLocation = self.currentLocation
        controllers.append(progress)
        let check = WorkListController()
        check.currentIndex = 5
        check.currentLocation = self.currentLocation
        controllers.append(check)
        let finish = WorkListController()
        finish.currentIndex = 6
        finish.currentLocation = self.currentLocation
        controllers.append(finish)
        let height = self.view.bounds.height - 45
        pageContentView = SGPageContentView(frame: CGRect(x: 0, y: 45, w: self.view.bounds.width, h: height - CGFloat(CF_NavHeight + TabbarSafeBottomMargin)), parentVC: self, childVCs: controllers)
        pageContentView.delegatePageContentView = self
        view.addSubview(pageContentView)
    }
    
    func setupRightButton() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "work_iocn_abrogation"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        button.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        button.addTarget(self, action: #selector(endWork), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc func endWork(){
        let controller = EndWorkController()
        controller.currentLocation = self.currentLocation
        self.pushVC(controller)
    }
    
}

extension WorkViewController: SGPageTitleViewDelegate {
    func pageTitleView(_ pageTitleView: SGPageTitleView!, selectedIndex: Int) {
        pageContentView.setPageCententViewCurrentIndex(selectedIndex)
    }
}

extension WorkViewController: SGPageContentViewDelegate {
    func pageContentView(_ pageContentView: SGPageContentView!, progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        pageTitleView.setPageTitleViewWithProgress(progress, originalIndex: originalIndex, targetIndex: targetIndex)
    }
}
