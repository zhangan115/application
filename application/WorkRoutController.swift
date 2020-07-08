//
//  WorkRoutController.swift
//  application
//
//  Created by sitech on 2020/7/7.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

private var routTitleCell = "RoutTitleCell"
private var routItemCell = "RoutItemCell"
private var routButtonCell = "RoutButtonCell"

class WorkRoutController: BaseTableViewController {
    
    var dateList:[DataItem] = []
    var workModel:WorkModel!
    var disposeBag = DisposeBag()
    var selectStrList:[String?] = []
    var canNext: Bool = false
    var callback:(()->())?
    override func viewDidLoad() {
        self.isRefresh = false
        self.isLoadMore = false
        super.viewDidLoad()
        self.title = "开始巡检"
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = ColorConstants.tableViewBackground
        self.tableView.sectionHeaderHeight = 0.01
        self.tableView.sectionFooterHeight = 0.01
        
        self.tableView.register(UINib(nibName: routTitleCell, bundle: nil), forCellReuseIdentifier: routTitleCell)
        self.tableView.register(UINib(nibName: routItemCell, bundle: nil), forCellReuseIdentifier: routItemCell)
        self.tableView.register(UINib(nibName: routButtonCell, bundle: nil), forCellReuseIdentifier: routButtonCell)
        request()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == self.dateList.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: routButtonCell) as! RoutButtonCell
            cell.button.isEnabled = self.canNext
            cell.callback = {
                let controller = WorkEndController()
                controller.workModel = self.workModel
                controller.callback = {
                    self.navigationController?.popViewController(animated: false)
                    self.callback?()
                }
                self.pushVC(controller)
            }
            return cell
        }else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: routTitleCell) as! RoutTitleCell
                cell.setModel(indexPath.section, model: dateList[indexPath.section])
                return cell
            }else  {
                let cell = tableView.dequeueReusableCell(withIdentifier: routItemCell) as! RoutItemCell
                if indexPath.row == 1 {
                    cell.label.text = "正常"
                }else{
                    cell.label.text = "异常"
                }
                cell.setModel(value: self.selectStrList[indexPath.section])
                return cell
            }
        }
    }
    
    override func request() {
        taskProviderNoPlugin.rxRequest(.getWorkDetail(taskId: self.workModel.taskId))
            .toModel(type: WorkModel.self)
            .subscribe(onSuccess: { [weak self](model) in
                self?.workModel = model
                if let list = model.afterFinishFile?.nodeDataList {
                    self?.dateList = list
                    self?.selectStrList.removeAll()
                    let taskId : Int = model.taskId
                    for item in list {
                        let name : String = item.itemName
                        let objects = self?.realm.objects(TaskRoutRealm.self).filter("taskId == \(taskId)").filter("itemName == %@",name)
                        if objects != nil && !objects!.isEmpty {
                            if let bean = objects!.first {
                                self?.selectStrList.append(bean.itemValue)
                            }else{
                                self?.selectStrList.append(nil)
                            }
                        }else{
                            self?.selectStrList.append(nil)
                        }
                    }
                    self?.canNext = true
                    for item in self?.selectStrList ?? [] {
                        if item == nil {
                            self?.canNext = false
                            break
                        }
                    }
                }
                self?.tableView.noRefreshReloadData()
            }) { [weak self](_) in
                self?.view.toast("请求失败")
        }.disposed(by: self.disposeBag)
    }
    
    let realm = try! Realm()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 && indexPath.section != self.dateList.count {
            let taskId : Int = self.workModel.taskId
            let name : String = self.dateList[indexPath.section].itemName
            let list = realm.objects(TaskRoutRealm.self).filter("taskId == \(taskId)").filter("itemName == %@",name)
            if list.isEmpty {
                let taskRout = TaskRoutRealm()
                taskRout.taskId.value = taskId
                taskRout.itemName = name
                taskRout.itemValue = "正常"
                try! realm.write {
                    realm.add(taskRout)
                }
            }else{
                if let bean = list.first {
                    try! realm.write {
                        bean.itemValue = "正常"
                    }
                }
            }
            self.selectStrList[indexPath.section] = "正常"
            canNext = true
            for item in self.selectStrList {
                if item == nil {
                    canNext = false
                    break
                }
            }
            tableView.reloadRows(at: [IndexPath(row: 1, section: indexPath.section)
                ,IndexPath(row: 2, section: indexPath.section)
                ,IndexPath(row: 0, section: dateList.count)], with: .none)
        }else if indexPath.row == 2 &&  indexPath.section != self.dateList.count {
            let taskId : Int = self.workModel.taskId
            let name : String = self.dateList[indexPath.section].itemName
            let list = realm.objects(TaskRoutRealm.self).filter("taskId == \(taskId)").filter("itemName == %@",name)
            if list.isEmpty {
                let taskRout = TaskRoutRealm()
                taskRout.taskId.value = taskId
                taskRout.itemName = name
                taskRout.itemValue = "异常"
                try! realm.write {
                    realm.add(taskRout)
                }
            }else{
                if let bean = list.first {
                    bean.itemValue = "异常"
                    try! realm.write {
                        bean.itemValue = "异常"
                    }
                }
            }
            self.selectStrList[indexPath.section] = "异常"
            canNext = true
            for item in self.selectStrList {
                if item == nil {
                    canNext = false
                    break
                }
            }
            tableView.reloadRows(at: [IndexPath(row: 1, section: indexPath.section)
                ,IndexPath(row: 2, section: indexPath.section)
                ,IndexPath(row: 0, section: dateList.count)], with: .none)
        }
    }
}

extension WorkRoutController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dateList.count + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == dateList.count {
            return 1
        }
        return 3
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
        if section == dateList.count {
            return 0
        }
        return 12
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == dateList.count {
            return 76
        }
        if indexPath.row == 1 || indexPath.row == 2 {
            return 44
        }
        return UITableView.automaticDimension
    }
}
