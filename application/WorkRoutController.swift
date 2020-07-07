//
//  WorkRoutController.swift
//  application
//
//  Created by sitech on 2020/7/7.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
private var routTitleCell = "RoutTitleCell"
private var routItemCell = "RoutItemCell"
private var workButtonCell1 = "WorkButtonCell"

class WorkRoutController: BaseTableViewController {
    
    var dateList:[DataItem] = []
    var workModel:WorkModel!
    var disposeBag = DisposeBag()
    var selectStrList:[String?] = []
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
        self.tableView.register(UINib(nibName: workButtonCell1, bundle: nil), forCellReuseIdentifier: workButtonCell1)
        request()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == self.dateList.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: workButtonCell1) as! WorkButtonCell
            cell.button.setTitle("下一步", for: .normal)
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
                    for _ in list {
                        self?.selectStrList.append(nil)
                    }
                }
                self?.tableView.noRefreshReloadData()
            }) { [weak self](_) in
                self?.view.toast("请求失败")
        }.disposed(by: self.disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == dateList.count {
            for item in self.selectStrList {
                if item == nil {
                    return
                }
            }
        }else if indexPath.row == 1 {
            self.selectStrList[indexPath.section] = "正常"
            tableView.noRefreshReloadData()
        }else if indexPath.row == 2 {
            self.selectStrList[indexPath.section] = "异常"
             tableView.noRefreshReloadData()
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
