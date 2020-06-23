//
//  WorkRobController.swift
//  application
//
//  Created by sitech on 2020/6/23.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
private let itemCell = "WorkRobItemCell"
class WorkRobController: BaseTableViewController {
    
    var headerPosition : Int? = nil
    var currentLocation : CLLocation? = nil
    var list1 : [WorkModel] = []
    var list2 : [WorkModel] = []
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.isRefresh = true
        super.viewDidLoad()
        self.title = "抢单列表"
        hiddenNaviBarLine()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = ColorConstants.tableViewBackground
        self.tableView.sectionHeaderHeight = 0.01
        self.tableView.sectionFooterHeight = 0.01
        self.tableView.register(WorkRobItemCell.self, forCellReuseIdentifier: itemCell)
    }
    
    override func request() {
        taskProviderNoPlugin.rxRequest(.getNearbyTask(longitude: self.currentLocation!.coordinate.longitude, latitude: self.currentLocation!.coordinate.latitude))
            .toListModel(type: WorkModel.self)
            .subscribe(onSuccess: {[weak self] (list) in
                if self == nil{
                    return
                }
                var allList : [WorkModel] = []
                for item in list {
                    if item.canDo {
                        self!.list1.append(item)
                    }else{
                        self!.list2.append(item)
                    }
                }
                allList.append(contentsOf:self!.list1)
                allList.append(contentsOf:self!.list2)
                if !self!.list1.isEmpty {
                    self!.headerPosition = self!.list1.count
                }
                self?.requestSuccessMonitor(list: allList)
            }) {[weak self] _ in
                self?.requestSuccessMonitor(list: [])
        }.disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCell) as! WorkRobItemCell
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


extension WorkRobController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return responseDataList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if  (!self.list1.isEmpty || !self.list2.isEmpty ) && section == 0 {
            let identifier = "header"
            var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? WorkListHeaderView
            if view == nil {
                view = WorkListHeaderView(reuseIdentifier: identifier)
                let backgroundView = UIView()
                backgroundView.backgroundColor = ColorConstants.tableViewBackground
                view?.backgroundView = backgroundView
            }
            if self.list1.isEmpty {
                view?.setText("不可抢工单")
            }else {
                view?.setText("可抢工单")
            }
            return view
        }
        if self.headerPosition != nil && section == self.headerPosition! {
            let identifier = "header"
            var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? WorkListHeaderView
            if view == nil {
                view = WorkListHeaderView(reuseIdentifier: identifier)
                let backgroundView = UIView()
                backgroundView.backgroundColor = ColorConstants.tableViewBackground
                view?.backgroundView = backgroundView
            }
            view?.setText("不可抢工单")
            return view
        }
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
        if (!self.list1.isEmpty || !self.list2.isEmpty) && section == 0{
            return 46
        }else if !self.list1.isEmpty && !self.list2.isEmpty && section == self.headerPosition!{
            return 46
        }else{
            return 12
        }
    }
    
    override  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
}
