//
//  BeanViewController.swift
//  iom365
//
//  Created by piggybear on 2018/6/27.
//  Copyright © 2018年 piggybear. All rights reserved.
//

import UIKit
import MJRefresh
// 列表 分页 基础类
class PageingListViewController: BaseHomeController {
    
    var isPresent = false
    var responseDataList: [Any] = []
    var baseIastId: Int!
    //是否有分页
    var isPaging: Bool = false
    var pagingCount : Int = 20
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
        self.view.addSubview(tableView)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButtonLogic()
    }
    
    func setTableViewHeader() {
        let refreshHeader = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshHandler))
        tableView.mj_header = refreshHeader
    }
    
    func setTableViewFooter() {
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(refreshHandler))
        tableView.mj_footer = footer
        tableView.mj_footer?.isHidden = true
    }
    
    @objc func refreshHandler() {
        guard isPaging else {
            request()
            return
        }
        if tableView.mj_header!.isRefreshing {
            tableView.mj_footer?.resetNoMoreData()
            responseDataList.removeAll()
            baseIastId = nil
        }
        request()
    }
    
    func request() {
        
    }
    
    func requestSuccessMonitor(list: [Any]) {
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
        if list.count == 0 {
            tableView.mj_footer?.endRefreshingWithNoMoreData()
        }
        self.responseDataList.append(contentsOf: list)
        if list.count < pagingCount {
            tableView.mj_footer?.isHidden = true
        }else {
            tableView.mj_footer?.isHidden = false
        }
        if self.tableView.mj_header != nil {
            self.tableView.safeReloadData()
        }else{
            self.tableView.noRefreshReloadData()
        }
    }
    
    func backButtonLogic() {
        let button = UIButton(x: 0, y: 0, w: 40, h: 40, target: self, action: #selector(pop))
        button.setImage(setBackImage(), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc func pop() {
        if isPresent {
            self.dismiss(animated: true, completion: nil)
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func hiddenNaviBarLine() {
        for item in (self.navBar?.subviews)! {
            if item.className == "_UIBarBackground" {
                item.subviews.first?.isHidden = true
            }
        }
    }
    
    func setBackImage() -> UIImage? {
        return UIImage(named: "label_icon_back")
    }
}
