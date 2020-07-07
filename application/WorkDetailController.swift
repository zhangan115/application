//
//  WorkDetailController.swift
//  application
//
//  Created by sitech on 2020/6/23.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
var workCostCell = "WorkCostCell"
var workInfoCell = "WorkInfoCell"
var customerInfoCell = "CustomerInfoCell"
var workRemarksCell = "WorkRemarksCell"
var workButtonCell = "WorkButtonCell"
var workEnclosureCell = "WorkEnclosureCell"
var workTimeCell = "WorkTimeCell"
var workInspectCell = "WorkInspectCell"
var workFinishTimeCell = "WorkFinishTimeCell"
var workEndCell = "WorkEndCell"
var workTitleCell = "WorkTitleCell"
var headerWorkEnclosureView = "HeaderWorkEnclosureView"
var workProgressItemCell = "WorkProgressItemCell"

class WorkDetailController: BaseTableViewController {
    
    var workModel:WorkModel!
    var disposeBag = DisposeBag()
    var fileList : [String]  = []
    
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
        self.tableView.register(UINib(nibName: workCostCell, bundle: nil), forCellReuseIdentifier: workCostCell)
        self.tableView.register(UINib(nibName: workInfoCell, bundle: nil), forCellReuseIdentifier: workInfoCell)
        self.tableView.register(UINib(nibName: customerInfoCell, bundle: nil), forCellReuseIdentifier: customerInfoCell)
        self.tableView.register(UINib(nibName: workRemarksCell, bundle: nil), forCellReuseIdentifier: workRemarksCell)
        self.tableView.register(UINib(nibName: workButtonCell, bundle: nil), forCellReuseIdentifier: workButtonCell)
        self.tableView.register(UINib(nibName: workEnclosureCell, bundle: nil), forCellReuseIdentifier: workEnclosureCell)
        self.tableView.register(UINib(nibName: workTimeCell, bundle: nil), forCellReuseIdentifier: workTimeCell)
        self.tableView.register(UINib(nibName: workInspectCell, bundle: nil), forCellReuseIdentifier: workInspectCell)
        self.tableView.register(UINib(nibName: workFinishTimeCell, bundle: nil), forCellReuseIdentifier: workFinishTimeCell)
        self.tableView.register(UINib(nibName: workTitleCell, bundle: nil), forCellReuseIdentifier: workTitleCell)
        self.tableView.register(UINib(nibName: workProgressItemCell, bundle: nil), forCellReuseIdentifier: workProgressItemCell)
        self.request()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //抢单
        if self.workModel.taskState == WorkState.WORK_ROB.rawValue {
            return getRobCell(indexPath: indexPath)
        }
        if self.workModel.taskState == WorkState.WORK_BEGIN.rawValue {
            return getBeginCell(indexPath: indexPath)
        }
        if self.workModel.taskState == WorkState.WORK_PROGRESS.rawValue{
            return getProgressCell(indexPath: indexPath)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        return cell
    }
    
    func showTimeDailog(time:Int){
        let text = "预计作业时间：" + dateString(millisecond: TimeInterval(time), dateFormat: "yyyy-MM-dd")
        let alertController = UIAlertController(title: text, message:"请在工单规定时间内完成作业", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "修改时间", style: .cancel, handler: nil)
        let sureAction = UIAlertAction(title: "确定", style: .default, handler: {(_)->Void in
            taskProvider.rxRequest(.takeTask(taskId:self.workModel.taskId, planArriveTime: time))
                .subscribe(onSuccess: {[weak self] (model) in
                    if self == nil{
                        return
                    }
                    self?.view.toast("抢单成功")
                    self?.request()
                }) {[weak self] _ in
                    self?.tableView.noRefreshReloadData()
            }.disposed(by: self.disposeBag)
        })
        alertController.addAction(noAction)
        alertController.addAction(sureAction)
        self.present(alertController, animated: true, completion: nil)
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
