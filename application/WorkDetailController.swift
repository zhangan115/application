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
import PGDatePicker
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

class WorkDetailController: PGBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var workModel:WorkModel!
    var disposeBag = DisposeBag()
    var fileList : [String]  = []
    var fileUrlList : [String]  = []
    var stopState:Int = StopState.Normal.rawValue
    let realm = try! Realm()
    var canCommint = false
    var currentNote:String? = nil
    var dataRealm:TaskFinishRealm? = nil
    var picUrlList:[String]  = []
    
    lazy var tableView : UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        self.view.addSubview(view)
        return view
    }()
    
    lazy var workInComeView : WorkInComeView = {
        let view = WorkInComeView()
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenNaviBarLine()
        self.title = "工单详情"
        self.view.backgroundColor = ColorConstants.tableViewBackground
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
        self.workInComeView.snp.updateConstraints { (make) in
            make.right.bottom.left.equalToSuperview()
            make.height.equalTo(0)
        }
        self.tableView.snp.updateConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(self.workInComeView.snp.top)
        }
        self.request()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: kMessageNotifyKey), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func refresh(){
        self.request()
    }
    
    override func rightBarAction() {
        let controller = WorkMoreController()
        controller.workModel = self.workModel
        self.pushVC(controller)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        let noAction = UIAlertAction(title: "修改时间", style: .cancel, handler: {(_)->Void in
            self.showTimePick(0)
        })
        let sureAction = UIAlertAction(title: "确定", style: .default, handler: {(_)->Void in
            self.robWork(time: time)
        })
        alertController.addAction(noAction)
        alertController.addAction(sureAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showTimePick(_ tag :Int) {
        let startDatePickerManager = PGDatePickManager()
        let datePicker = startDatePickerManager.datePicker!
        startDatePickerManager.isShadeBackground = true
        datePicker.tag = tag
        datePicker.delegate = self
        datePicker.datePickerMode = .date
        datePicker.isHiddenMiddleText = false
        datePicker.datePickerType = .segment
        self.present(startDatePickerManager, animated: false, completion: nil)
    }
    
    func robWork(time:Int){
        taskProvider.rxRequest(.takeTask(taskId:self.workModel.taskId, planArriveTime: time))
            .subscribe(onSuccess: {[weak self] (model) in
                if self == nil{
                    return
                }
                self?.view.toast("抢单成功")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMessageNotifyKey), object: nil)
            }) {[weak self] _ in
                self?.tableView.noRefreshReloadData()
        }.disposed(by: self.disposeBag)
    }
    
    func request() {
        taskProviderNoPlugin.rxRequest(.getWorkDetail(taskId:self.workModel.taskId))
            .toModel(type: WorkModel.self)
            .subscribe(onSuccess: {[weak self] (model) in
                if self == nil{
                    return
                }
                self?.fileList.removeAll()
                self?.fileUrlList.removeAll()
                if let attachmen = model.afterFinishFile {
                    if attachmen.nodeAttachmentList != nil {
                        for item in attachmen.nodeAttachmentList {
                            self?.fileList.append(item.fileName)
                            self?.fileUrlList.append(item.fileUrl)
                        }
                    }
                }
                self?.workModel = model
                if model.taskState >= WorkState.WORK_BEGIN.rawValue &&
                    model.taskState < WorkState.WORK_FINISH.rawValue &&
                    !model.isTerminated{
                    self?.rightMoreButton()
                }
                if model.isTerminated {
                    if model.actualFee != nil && model.actualFee.count > 0 {
                        self?.stopState = StopState.Stop.rawValue
                    }else{
                        self?.stopState = StopState.Progress.rawValue
                    }
                }
                self?.checkSubState()
                self?.saveRoutData()
                self?.getSaveData()
                self?.tableView.noRefreshReloadData()
                self?.updateInComeView()
            }) {[weak self] _ in
                self?.tableView.noRefreshReloadData()
        }.disposed(by: disposeBag)
    }
    
    func saveRoutData(){
        if self.workModel.taskState == WorkState.WORK_PROGRESS.rawValue && !self.workModel.isTerminated {
            if let list = self.workModel.afterFinishFile?.nodeDataList {
                let taskId : Int = self.workModel.taskId
                let objects = self.realm.objects(TaskRoutRealm.self).filter("taskId == \(taskId)")
                if objects.isEmpty {
                    var saveList : [TaskRoutRealm] = []
                    for item in list {
                        let bean = TaskRoutRealm()
                        bean.taskId.value = taskId
                        bean.itemName = item.itemName
                        if item.itemValue != nil && item.itemValue!.count > 0 {
                            bean.itemValue = item.itemValue
                            saveList.append(bean)
                        }
                    }
                    try! realm.write {
                        realm.add(saveList)
                    }
                }
            }
        }
    }
    
    func getSaveData(){
        let taskId : Int = self.workModel.taskId
        let object = realm.object(ofType: TaskFinishRealm.self, forPrimaryKey: taskId)
        if object == nil {
            dataRealm = TaskFinishRealm()
            dataRealm!.taskId.value = taskId
            try! realm.write {
                realm.add(dataRealm!)
            }
        }else{
            dataRealm = object
            if self.fileList.isEmpty{
                self.fileList = self.dataRealm!.fileNameList?.split(",") ?? []
            }
            if self.fileUrlList.isEmpty {
                self.fileUrlList = self.dataRealm!.fileUrList?.split(",") ?? []
            }
            if self.dataRealm!.note != nil && self.dataRealm!.note!.count > 0 {
                self.currentNote = self.dataRealm!.note
            }
            if let url = self.dataRealm!.photoList?.split(",") {
                self.picUrlList = url
            }
        }
    }
    
    func updateInComeView(){
        if self.workModel.taskState == WorkState.WORK_FINISH.rawValue || self.stopState == StopState.Stop.rawValue {
            workInComeView.isHidden = false
            workInComeView.label.text = "工单收入"
            workInComeView.label1.text = "￥" + self.workModel.actualFee
            self.workInComeView.snp.updateConstraints { (make) in
                make.right.left.equalToSuperview()
                make.height.equalTo(44)
                make.bottom.equalToSuperview().offset(-TabbarSafeBottomMargin)
            }
            self.tableView.snp.updateConstraints { (make) in
                make.left.right.top.equalToSuperview()
                make.bottom.equalTo(self.workInComeView.snp.top).offset(-5)
            }
        }
    }
    
    var finishRout = false
    
    override func viewWillAppear(_ animated: Bool) {
        checkSubState()
    }
    
    private func checkSubState(){
        if self.workModel.taskType == WorkType.WORK_TYPE_ROUT.rawValue {
            if !self.canCommint {
                let taskId : Int = workModel.taskId
                let objects = self.realm.objects(TaskRoutRealm.self).filter("taskId == \(taskId)")
                if workModel.afterFinishFile != nil {
                    if workModel.afterFinishFile?.nodeDataList != nil && !workModel.afterFinishFile!.nodeDataList.isEmpty {
                        let count = workModel.afterFinishFile!.nodeDataList.count
                        if objects.count == count {
                            if self.finishRout != true {
                                self.finishRout = true
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }else{
            self.finishRout = true
        }
        if self.workModel.taskState == WorkState.WORK_PROGRESS.rawValue {
            self.getSaveData()
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveCacheData()
    }
    
    func saveCacheData(){
        if self.workModel.taskState == WorkState.WORK_PROGRESS.rawValue{
            var cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 2)) as? WorkProgressAfterCell
            if cell == nil {
                cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 3)) as? WorkProgressAfterCell
            }
            if cell != nil {
                self.currentNote = cell?.noteTextView.text
            }
        }
        if self.dataRealm != nil {
            try! realm.write {
                self.dataRealm!.photoList = self.picUrlList.joined(separator: ",")
                self.dataRealm!.fileNameList = self.fileList.joined(separator: ",")
                self.dataRealm!.fileUrList = self.fileUrlList.joined(separator: ",")
                self.dataRealm!.note = self.currentNote
            }
        }
    }
    
    func subData(){
        var canSub = true
        var params : [String:Any] = [:]
        params["taskId"] = self.workModel.taskId
        var stringList : [[String:Any]] = []
        for item in self.workModel.afterFinishFile!.nodePicList {
            if item.picUrlList == nil || item.picUrlList.isEmpty || item.picUrlList[0].count < 2{
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
        var cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 2)) as? WorkProgressAfterCell
        if cell != nil {
            params["note"] = cell!.noteTextView.text
        }else{
            cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 3)) as? WorkProgressAfterCell
            if cell != nil {
                params["note"] = cell!.noteTextView.text
            }
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
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMessageNotifyKey), object: nil)
            }) {[weak self] (_) in
                self?.view.toast("提交失败")
        }.disposed(by: self.disposeBag)
    }
}

extension WorkDetailController{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return getNumberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfRowInSection(section)
    }
    
}
