//
//  WorkDetailController.swift
//  application
//
//  Created by sitech on 2020/6/23.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift

class WorkDetailController: BaseTableViewController {
    
    var workModel:WorkModel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.isLoadMore = false
        self.isRefresh = false
        super.viewDidLoad()
        hiddenNaviBarLine()
        self.title = "工单详情"
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = ColorConstants.tableViewBackground
        self.tableView.sectionHeaderHeight = 0.01
        self.tableView.sectionFooterHeight = 0.01
        self.request()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        return cell
    }
    
    
    override func request() {
        taskProviderNoPlugin.rxRequest(.getWorkDetail(taskId:self.workModel.taskId))
            .toModel(type: WorkModel.self)
            .subscribe(onSuccess: {[weak self] (model) in
                if self == nil{
                    return
                }
                self?.workModel = model
                self?.tableView.noRefreshReloadData()
            }) {[weak self] _ in
                self?.tableView.noRefreshReloadData()
        }.disposed(by: disposeBag)
    }
}

extension WorkDetailController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return getNumberOfSection()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfRowInSection(section)
    }
    
}
