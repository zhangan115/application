//
//  WorkProgressButtomCell.swift
//  application
//
//  Created by sitech on 2020/7/9.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
import PGActionSheet
import RealmSwift

class WorkProgressButtomCell: UITableViewCell {
    
    @IBOutlet var subButton : UIButton!
    @IBOutlet var checkStateView:UIView!
    @IBOutlet var routView:UIView!
    @IBOutlet var progressLable:UILabel!
    
    let realm = try! Realm()
    var workModel:WorkModel!
    
    var fileList:[String] = []
    var fileUrlList:[String] = []
    
    var noteText:String?
    var disposeBag = DisposeBag()
    var subCallBack:(()->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
        subButton.layer.masksToBounds = true
        subButton.layer.cornerRadius = 4
    }
    
    func setModel(workModel:WorkModel){
        self.workModel = workModel
        //进行中 没有被终止
        if workModel.taskState == WorkState.WORK_PROGRESS.rawValue && !workModel.isTerminated {
            subButton.isHidden = false
        }else{
            subButton.isHidden = true
        }
        if workModel.taskState == WorkState.WORK_CHECK.rawValue && !workModel.isTerminated {
            checkStateView.isHidden = false
        }else{
            checkStateView.isHidden = true
        }
        if workModel.taskType == WorkType.WORK_TYPE_ROUT.rawValue && workModel.taskState != WorkState.WORK_CHECK.rawValue {
            routView.isHidden = false
        }else{
            routView.isHidden = true
        }
        let taskId : Int = workModel.taskId
        let objects = self.realm.objects(TaskRoutRealm.self).filter("taskId == \(taskId)")
        if workModel.afterFinishFile != nil {
            if workModel.afterFinishFile?.nodeDataList != nil {
                let count = workModel.afterFinishFile!.nodeDataList.count
                progressLable.text = "完成" + ((objects.count / count) * 100 ).toString + "%"
            }
        }
    }
    
    @IBAction func sub(_ sender:UIButton){
        var params : [String:Any] = [:]
        params["taskId"] = self.workModel.taskId
        var stringList : [[String:Any]] = []
        for item in self.workModel.afterFinishFile!.nodePicList {
            var param = [String:Any]()
            param["picName"] = item.picName
            param["picCount"] = item.picCount
            param["picUrlList"] = item.picUrlList
            stringList.append(param)
        }
        params["finishPic"] = stringList.toJson()
        if self.noteText != nil{
            params["note"] = self.noteText
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
                self?.toast("提交成功")
                self?.subCallBack?()
            }) {[weak self] (_) in
                self?.toast("提交失败")
        }.disposed(by: self.disposeBag)
    }
}
