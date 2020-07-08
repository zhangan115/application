//
//  WorkListController.swift
//  application
//
//  Created by sitech on 2020/6/22.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
private let itemCell = "WorkListViewCell"
class WorkListController: BaseTableViewController {
    
    var currentIndex = 3
    var headerPosition : Int? = nil
    var currentLocation : CLLocation? = nil
    var list1 : [WorkModel] = []
    var list2 : [WorkModel] = []
    var disposeBag = DisposeBag()
    
    lazy var workVerifyView : WorkVerifyView = {
        return WorkVerifyView()
    }()
    
    override func viewDidLoad() {
        self.isRefresh = true
        super.viewDidLoad()
        hiddenNaviBarLine()
        showUserVerify()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = ColorConstants.tableViewBackground
        self.tableView.sectionHeaderHeight = 0.01
        self.tableView.sectionFooterHeight = 0.01
        self.tableView.register(WorkListViewCell.self, forCellReuseIdentifier: itemCell)
    }
    
    override func request() {
        if let userModel = UserModel.unarchiver() {
            if userModel.certificationType! > 0 {
                if self.currentIndex == WorkState.WORK_FINISH.rawValue || self.currentIndex == WorkState.WORK_CHECK.rawValue {
                    var params :[String:Any] = [:]
                    params["showTerminated"] = 0
                    params["taskState"] = self.currentIndex
                    params["longitude"] = self.currentLocation!.coordinate.longitude
                    params["latitude"] = self.currentLocation!.coordinate.latitude
                    taskProviderNoPlugin.rxRequest(.getMyCheckTaskList(params: params))
                        .map { (json) in
                            var data = json
                            data["data"] = json["data"]["list"]
                            return data
                    }.toListModel(type: WorkModel.self)
                        .subscribe(onSuccess: {[weak self](list) in
                            self?.responseDataList.removeAll()
                            self?.requestSuccessMonitor(list: list)
                        }) { [weak self] _ in
                            self?.responseDataList.removeAll()
                            self?.requestSuccessMonitor(list: [])
                    }.disposed(by: self.disposeBag)
                }else {
                    var params :[String:Any] = [:]
                    params["showTerminated"] = 0
                    params["taskState"] = self.currentIndex
                    params["longitude"] = self.currentLocation!.coordinate.longitude
                    params["latitude"] = self.currentLocation!.coordinate.latitude
                    params["sortType"] = self.currentIndex - 2
                    taskProviderNoPlugin.rxRequest(.getMyTaskList(params: params))
                        .map { (json) in
                            var data = json
                            data["data"] = json["data"]["list"]
                            return data
                    }.toListModel(type: WorkModel.self)
                        .subscribe(onSuccess: {[weak self](list) in
                            if self == nil {
                                return
                            }
                            if self!.currentIndex == WorkState.WORK_PROGRESS.rawValue {
                                self!.list1.removeAll()
                                self!.list2.removeAll()
                                var allList : [WorkModel] = []
                                for item in list {
                                    if item.hasEverSubmitted {
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
                                self?.responseDataList.removeAll()
                                self?.requestSuccessMonitor(list: allList)
                            }else {
                                self?.responseDataList.removeAll()
                                self?.requestSuccessMonitor(list: list)
                            }
                        }) { [weak self] _ in
                            self?.responseDataList.removeAll()
                            self?.requestSuccessMonitor(list: [])
                    }.disposed(by: self.disposeBag)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCell) as! WorkListViewCell
        cell.backgroundColor = ColorConstants.tableViewBackground
        let model = self.responseDataList[indexPath.section] as! WorkModel
        cell.setModel(model: model,requestType:self.currentIndex)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.responseDataList[indexPath.section] as! WorkModel
        let controller = WorkDetailController()
        controller.workModel = model
        self.pushVC(controller)
    }
}

extension WorkListController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return responseDataList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.currentIndex == WorkState.WORK_PROGRESS.rawValue {
            if  (!self.list1.isEmpty || !self.list2.isEmpty) && section == 0 {
                let identifier = "header_1"
                var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? WorkListHeaderView
                if view == nil {
                    view = WorkListHeaderView(reuseIdentifier: identifier)
                    let backgroundView = UIView()
                    backgroundView.backgroundColor = ColorConstants.tableViewBackground
                    view?.backgroundView = backgroundView
                }
                if self.list1.isEmpty {
                    view?.setText("工单未完成")
                }else {
                    view?.setText("验收未通过")
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
                view?.setText("工单未完成")
                return view
            }
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
        if self.currentIndex == WorkState.WORK_PROGRESS.rawValue {
            if (!self.list1.isEmpty || !self.list2.isEmpty) && section == 0{
                return 46
            }else if !self.list1.isEmpty && !self.list2.isEmpty && section == self.headerPosition!{
                return 46
            }else{
                return 12
            }
        }
        return 12
    }
    
    override  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 184
    }
}

extension WorkListController {
    
    func showUserVerify(){
        if let userModel = UserModel.unarchiver() {
            if userModel.certificationType! == 0 {
                self.view.addSubview(workVerifyView)
                workVerifyView.snp.updateConstraints { (make) in
                    make.left.right.equalToSuperview()
                    make.top.equalToSuperview().offset(170)
                    make.bottom.greaterThanOrEqualToSuperview().offset(50)
                }
            }
        }
    }
}
