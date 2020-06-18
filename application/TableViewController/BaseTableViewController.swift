//
//  PGBaseTableViewController.swift
//  edetection
//
//  Created by piggybear on 16/05/2017.
//  Copyright © 2017 piggybear. All rights reserved.
//

import UIKit
import MJRefresh

class BaseTableViewController: HomeTableController {
    
    var responseDataList: [Any] = []
    var baseIastId: Int!
    //是否有分页
    var isRefresh = true
    var isLoadMore = true
    var pagingCount : Int = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isRefresh {
            setTableViewHeader()
        }
        if isLoadMore {
            setTableViewFooter()
        }
    }
    
    func setTableViewHeader() {
        let refreshHeader = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshHandler))
        tableView.mj_header = refreshHeader
        refreshHeader.beginRefreshing()
    }
    
    func setTableViewFooter() {
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreHandler))
        tableView.mj_footer = footer
        tableView.mj_footer?.isHidden = true
    }
    
    @objc func refreshHandler() {
        if tableView.mj_header!.isRefreshing {
            if isLoadMore {
                tableView.mj_footer?.resetNoMoreData()
            }
            responseDataList.removeAll()
            baseIastId = nil
        }
        request()
    }
    
    @objc func loadMoreHandler(){
        guard isLoadMore else {
            return
        }
        request()
    }
    
    func request() {
        
    }
    
    func requestSuccessMonitor(list: [Any]?) {
        if isRefresh {
            tableView.mj_header?.endRefreshing()
        }
        if isLoadMore {
            if list != nil {
                if list!.isEmpty{
                    tableView.mj_footer?.endRefreshingWithNoMoreData()
                }else{
                    tableView.mj_footer?.endRefreshing()
                }
            }
        }
        if list != nil {
            self.responseDataList.append(contentsOf: list!)
        }
        if isLoadMore {
            if list != nil {
                if list!.count < pagingCount {
                    tableView.mj_footer?.isHidden = true
                }else {
                    tableView.mj_footer?.isHidden = false
                }
            }
        }
        self.tableView.safeReloadData()
    }
}

