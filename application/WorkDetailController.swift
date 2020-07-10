//
//  WorkDetailController.swift
//  application
//
//  Created by sitech on 2020/6/23.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

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
var workCostDetailCell = "WorkCostDetailCell"
var workProgressAfterCell = "WorkProgressAfterCell"
var workProgressButtomCell = "WorkProgressButtomCell"
class WorkDetailController: BaseTableViewController {
    
    var workModel:WorkModel!
    var disposeBag = DisposeBag()
    var fileList : [String]  = []
    var fileUrlList : [String]  = []
    var stopState:Int = StopState.Normal.rawValue
    let realm = try! Realm()
    
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
        self.tableView.register(UINib(nibName: workCostDetailCell, bundle: nil), forCellReuseIdentifier: workCostDetailCell)
        self.tableView.register(UINib(nibName: workEndCell, bundle: nil), forCellReuseIdentifier: workEndCell)
        self.tableView.register(UINib(nibName: workProgressAfterCell, bundle: nil), forCellReuseIdentifier: workProgressAfterCell)
        self.tableView.register(UINib(nibName: workProgressButtomCell, bundle: nil), forCellReuseIdentifier: workProgressButtomCell)
        self.request()
        rightMoreButton()
    }
    
    override func rightBarAction() {
        let controller = WorkMoreController()
        controller.workModel = self.workModel
        self.pushVC(controller)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.workModel.taskState == WorkState.WORK_ROB.rawValue {
            return getRobCell(indexPath: indexPath)
        }
        if self.workModel.taskState == WorkState.WORK_BEGIN.rawValue {
            return getBeginCell(indexPath: indexPath)
        }
        if self.workModel.taskState == WorkState.WORK_PROGRESS.rawValue{
            return getProgressCell(indexPath: indexPath)
        }
        if self.workModel.taskState == WorkState.WORK_CHECK.rawValue{
            return getCheckCell(indexPath: indexPath)
        }
        if self.workModel.taskState == WorkState.WORK_FINISH.rawValue{
            return getFinishCell(indexPath: indexPath)
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
                if let attachmen = model.afterFinishFile {
                    if attachmen.nodeAttachmentList != nil {
                        for item in attachmen.nodeAttachmentList {
                            self?.fileList.append(item.fileName)
                            self?.fileUrlList.append(item.fileUrl)
                        }
                    }
                }
                self?.workModel = model
                if model.isTerminated {
                    if model.actualFee != nil{
                        self?.stopState = StopState.Stop.rawValue
                    }else{
                        self?.stopState = StopState.Progress.rawValue
                    }
                }
                self?.tableView.noRefreshReloadData()
            }) {[weak self] _ in
                self?.tableView.noRefreshReloadData()
        }.disposed(by: disposeBag)
    }
    
    func subData(){
        var canSub = true
        var params : [String:Any] = [:]
        params["taskId"] = self.workModel.taskId
        var stringList : [[String:Any]] = []
        for item in self.workModel.afterFinishFile!.nodePicList {
            if item.picUrlList == nil || item.picUrlList.isEmpty {
                canSub = false
                break
            }
            var param = [String:Any]()
            param["picName"] = item.picName
            param["picCount"] = item.picCount
            param["picUrlList"] = item.picUrlList
            stringList.append(param)
        }
        if !canSub {
            self.view.showAutoHUD("请完成资料上传")
            return
        }
        params["finishPic"] = stringList.toJson()
        let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 2)) as? WorkProgressAfterCell
        if cell != nil {
            params["note"] = cell?.noteTextView.text
        }
        var fileStringList : [[String:Any]] = []
        if !self.fileList.isEmpty {
            for (index,item) in self.fileList.enumerated() {
                var param = [String:Any]()
                param["fileName"] = item
                param["fileUrl"] = fileUrlList[index]
                fileStringList.append(param)
            }
            params["attachment"] = fileStringList.toJson()
        }
        if self.workModel.taskType == WorkType.WORK_TYPE_ROUT.rawValue {
            var stringList : [[String:Any]] = []
            let taskId : Int = self.workModel.taskId
            let list = realm.objects(TaskRoutRealm.self).filter("taskId == \(taskId)")
            if !list.isEmpty {
                for item in list {
                    var param = [String:Any]()
                    param["itemName"] = item.itemName
                    param["itemValue"] = item.itemValue
                    stringList.append(param)
                }
            }
            params["data"] = stringList.toJson()
        }
        taskProvider.rxRequest(.taskSubmit(params: params))
            .subscribe(onSuccess: { [weak self](json) in
                self?.view.toast("提交成功")
                self?.request()
            }) {[weak self] (_) in
                self?.view.toast("提交失败")
        }.disposed(by: self.disposeBag)
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
