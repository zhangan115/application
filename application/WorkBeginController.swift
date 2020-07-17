//
//  WorkBeginController.swift
//  application
//
//  Created by Anson on 2020/7/6.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
class WorkBeginController: PGBaseViewController {
    
    var workModel:WorkModel!
    var disposeBag = DisposeBag()
    var callback:(()->())?
    var viewList:[TakePhotoView] = []
    
    lazy var noteLabel : UILabel = {
        let view = UILabel()
        view.textColor = UIColor(hexString: "#FF7013")
        view.font = UIFont.systemFont(ofSize: 13)
        view.numberOfLines = 0
        view.text = "*注：为保障审核成功率，请按照规定上传照片；照片提交后，不可更改，请谨慎选择"
        self.view.addSubview(view)
        return view
    }()
    
    lazy var startButton:UIButton = {
        let view = UIButton()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        view.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        view.setTitleColor(UIColor(hexString: "#F6F6F6"), for: .disabled)
        view.setBackgroundColor(UIColor(hexString: "#FFCC00")!, forState: .normal)
        view.setBackgroundColor(UIColor(hexString: "#CCCCCC")!, forState: .disabled)
        view.addTarget(self, action: #selector(startAction), for: .touchUpInside)
        view.isEnabled = false
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorConstants.tableViewBackground
        self.title = "开始前资料上传"
        if self.workModel.taskType == WorkType.WORK_TYPE_ROUT.rawValue {
            startButton.setTitle("开始巡检", for: .normal)
        }else{
            startButton.setTitle("开始作业", for: .normal)
        }
        startButton.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(44)
        }
        self.request()
    }
    
    private func request(){
        taskProviderNoPlugin.rxRequest(.getWorkDetail(taskId: self.workModel.taskId))
            .toModel(type: WorkModel.self)
            .subscribe(onSuccess: { [weak self](model) in
                self?.workModel = model
                self?.initView()
            }) { [weak self](_) in
                self?.view.toast("请求失败")
        }.disposed(by: self.disposeBag)
    }
    
    private func initView(){
        if let before =  self.workModel.beforeStartFile {
            viewList.removeAll()
            for (index,item) in before.nodePicList.enumerated() {
                let view = TakePhotoView()
                view.titleLable.text = item.picName
                view.callback = {
                    for item in self.viewList {
                        if item.picNote?.picUrlList.isEmpty ?? true{
                            self.startButton.isEnabled = false
                            break
                        }
                        self.startButton.isEnabled = true
                    }
                }
                view.tag = index
                view.picNote = item
                self.viewList.append(view)
            }
            if !viewList.isEmpty {
                self.view.addSubviews(self.viewList)
                for (index,view) in viewList.enumerated() {
                    view.frame = CGRect(x: 0, y: CGFloat(0 + index * 90), w: screenWidth, h: 90)
                }
                noteLabel.snp.updateConstraints { (make) in
                    make.left.equalToSuperview().offset(12)
                    make.right.equalToSuperview().offset(-12)
                    make.top.equalTo(self.viewList[viewList.count-1].snp.bottom).offset(12)
                }
            }
        }
    }
    
    @objc func startAction(){
        var stringList : [[String:Any]] = []
        for item in self.viewList {
            var param = [String:Any]()
            param["picName"] = item.picNote!.picName
            param["picCount"] = item.picNote!.picCount
            param["picUrlList"] = item.picNote!.picUrlList
            stringList.append(param)
        }
        taskProvider.rxRequest(.taskStart(taskId: self.workModel.taskId, params: stringList.toJson()))
            .subscribe(onSuccess: { [weak self](json) in
                self?.requestModel()
            }) {[weak self] (_) in
                self?.view.toast("提交失败")
        }.disposed(by: self.disposeBag)
    }
    
    func requestModel(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMessageNotifyKey), object: nil)
        taskProviderNoPlugin.rxRequest(.getWorkDetail(taskId: self.workModel.taskId))
            .toModel(type: WorkModel.self)
            .subscribe(onSuccess: { [weak self](model) in
                self?.workModel = model
                if (model.taskType == WorkType.WORK_TYPE_ROUT.rawValue) {//去巡检
                    let controller = WorkRoutController()
                    controller.workModel = self?.workModel
                    controller.callback = {
                        self?.navigationController?.popViewController(animated: false)
                    }
                    self?.pushVC(controller)
                } else {//结束后上传资料
                    let controller = WorkFinish1Controller()
                    controller.workModel = self?.workModel
                    controller.callback = {
                        self?.navigationController?.popViewController(animated: false)
                    }
                    self?.pushVC(controller)
                }
            }) { (_) in
                print("error")
        }.disposed(by: self.disposeBag)
    }
    
}
