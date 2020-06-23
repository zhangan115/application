//
//  EndWorkController.swift
//  application
//
//  Created by sitech on 2020/6/22.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
private let itemCell = "WorkEndItemViewCell"
class EndWorkController: BaseTableViewController {
    
    var currentLocation : CLLocation? = nil
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.isRefresh = true
        self.isLoadMore = false
        super.viewDidLoad()
        self.title = "已终止工单"
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = ColorConstants.tableViewBackground
        self.tableView.sectionHeaderHeight = 0.01
        self.tableView.sectionFooterHeight = 0.01
        self.tableView.register(WorkEndItemViewCell.self, forCellReuseIdentifier: itemCell)
        request()
    }
    
    override func request() {
        taskProviderNoPlugin.rxRequest(.getTerminatedTaskList)
            .toListModel(type: WorkModel.self)
            .subscribe(onSuccess: {[weak self](list) in
                self?.requestSuccessMonitor(list: list)
            }) {[weak self](error) in
                self?.responseDataList.removeAll()
                self?.requestSuccessMonitor(list: [])
        }.disposed(by: self.disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCell) as! WorkEndItemViewCell
        cell.backgroundColor = ColorConstants.tableViewBackground
        let model = self.responseDataList[indexPath.section] as! WorkModel
        cell.setModel(model: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.responseDataList[indexPath.section] as! WorkModel
        let controller = WorkDetailController()
        controller.workModel = model
        self.pushVC(controller)
    }
    
}

extension EndWorkController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return responseDataList.count
    }
    
    override   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let identifier = "header"
        var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
        if view == nil {
            view = UITableViewHeaderFooterView(reuseIdentifier: identifier)
            let backgroundView = UIView()
            backgroundView.backgroundColor = ColorConstants.tableViewBackground
            view?.backgroundView = backgroundView
        }
        return view
    }
    
    override  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
    override  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 184
    }
}
