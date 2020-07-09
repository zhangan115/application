//
//  WorkProgressItemCell.swift
//  application
//
//  Created by sitech on 2020/7/7.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
import PGActionSheet
import RealmSwift
class WorkProgressItemCell: UITableViewCell {
    
    @IBOutlet var bgView1 : UIView! // 背景
    @IBOutlet var bgView2 : UIView! // 背景
    @IBOutlet var finishLabel : UILabel!
    @IBOutlet var roubView : UIView!
    @IBOutlet var subButton : UIButton!
    @IBOutlet var addFileButton : UIButton!
    @IBOutlet var finishView : UIView!
    @IBOutlet var fileView : UIView!
    @IBOutlet var noteTextView : UITextView!
    @IBOutlet var progressLable:UILabel!
    @IBOutlet weak var finishHeight1:NSLayoutConstraint!
    @IBOutlet weak var finishlayoutHeight1: NSLayoutConstraint!
    @IBOutlet weak var roubHeight: NSLayoutConstraint!
    @IBOutlet weak var fileHeigt: NSLayoutConstraint!
    @IBOutlet var checkUIView : UIView!
    
    var workModel:WorkModel!
    var disposeBag = DisposeBag()
    
    var viewList:[TakePhotoView] = []
    var callback:((WorkModel)->())?
    var updateCallBack:(()->())?
    var addFileCallBack:((String)->())?
    var delectFileCallBack:((Int)->())?
    var subCallBack:(()->())?
    var fileList:[String] = []
    var fileUrlList : [String]  = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.white
        bgView1.layer.masksToBounds = true
        bgView1.layer.cornerRadius = 4
        bgView2.layer.masksToBounds = true
        bgView2.layer.cornerRadius = 4
        subButton.layer.masksToBounds = true
        subButton.layer.cornerRadius = 4
        let tap = UITapGestureRecognizer(target: self, action: #selector(showRoub))
        roubView.addGestureRecognizer(tap)
    }
    
    @objc func showRoub(){
        let controller = WorkRoutController()
        controller.workModel = self.workModel
        controller.callback = {
            self.updateCallBack?()
        }
        currentViewController().pushVC(controller)
    }
    
    let realm = try! Realm()
    
    func setModel(workModel:WorkModel){
        finishHeight1.constant = 396
        self.workModel = workModel
        if workModel.taskType == WorkType.WORK_TYPE_ROUT.rawValue && workModel.taskState == WorkState.WORK_PROGRESS.rawValue {
            roubHeight.constant = 44
            roubView.isHidden = false
        }else if workModel.taskType == WorkType.WORK_TYPE_ROUT.rawValue && workModel.taskState == WorkState.WORK_FINISH.rawValue{
            roubHeight.constant = 44
            roubView.isHidden = false
        }else{
            roubHeight.constant = 0
            roubView.isHidden = true
        }
        if workModel.taskState == WorkState.WORK_PROGRESS.rawValue {
            addFileButton.isHidden = false
            subButton.isHidden = false
        }else{
            addFileButton.isHidden = true
            subButton.isHidden = true
            addFileButton.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
        }
        checkUIView.isHidden = workModel.taskState != WorkState.WORK_CHECK.rawValue
        self.bgView1.removeSubviews()
        if let before = workModel.beforeStartFile {
            if before.nodePicList != nil && !before.nodePicList.isEmpty{
                self.viewList.removeAll()
                for (index,item) in before.nodePicList.enumerated() {
                    let view = TakePhotoView()
                    view.setData(picNote: item)
                    view.titleLable.text = item.picName
                    view.tag = index
                    view.canTakePhoto = false
                    self.viewList.append(view)
                }
                if !viewList.isEmpty {
                    self.bgView1.addSubviews(self.viewList)
                    for (index,view) in viewList.enumerated() {
                        view.frame = CGRect(x: 0, y: CGFloat(0 + index * 90), w: screenWidth, h: 90)
                    }
                }
            }
        }
        self.finishView.removeSubviews()
        if let finish = workModel.afterFinishFile {
            if finish.nodePicList != nil && !finish.nodePicList.isEmpty{
                finishlayoutHeight1.constant =  CGFloat(finish.nodePicList.count * 90 + 12)
                if finish.nodePicList.count * 90 + 12 > 192 {
                    finishHeight1.constant = finishHeight1.constant +  CGFloat(finish.nodePicList.count * 90 + 12 - 192)
                }
                self.viewList.removeAll()
                for (index,item) in finish.nodePicList.enumerated() {
                    let view = TakePhotoView()
                    view.setData(picNote: item)
                    view.titleLable.text = item.picName
                    view.canTakePhoto = workModel.taskState == WorkState.WORK_PROGRESS.rawValue
                    view.tag = index
                    view.picNote = item
                    self.viewList.append(view)
                }
                if !viewList.isEmpty {
                    self.finishView.addSubviews(self.viewList)
                    for (index,view) in viewList.enumerated() {
                        view.frame = CGRect(x: 0, y: CGFloat(0 + index * 90), w: screenWidth, h: 90)
                    }
                }
                if workModel.afterFinishFile != nil && !workModel.afterFinishFile!.nodeDataList.isEmpty {
                    let taskId : Int = workModel.taskId
                    let objects = self.realm.objects(TaskRoutRealm.self).filter("taskId == \(taskId)")
                    let count = workModel.afterFinishFile!.nodeDataList.count
                    progressLable.text = "完成" + ((objects.count / count) * 100 ).toString + "% >"
                }
            }
        }
        self.fileView.removeSubviews()
        reloadFileView(height: finishHeight1.constant)
        if workModel.taskState > WorkState.WORK_PROGRESS.rawValue {
            noteTextView.backgroundColor = ColorConstants.tableViewBackground
            noteTextView.isEditable = false
            if workModel.afterFinishFile != nil {
                noteTextView.text = workModel.afterFinishFile!.nodeNote
            }
        }
    }
    
    private func reloadFileView(height:CGFloat){
        self.fileView.removeSubviews()
        if !self.fileList.isEmpty {
            fileHeigt.constant = CGFloat(self.fileList.count * 34)
            finishHeight1.constant = height + CGFloat(self.fileList.count * 34)
            var viewList : [WorkFileVIew] = []
            for (index,item) in self.fileList.enumerated() {
                let view = WorkFileVIew()
                view.tag = index
                view.delectButton.isHidden = self.workModel.taskState != WorkState.WORK_PROGRESS.rawValue
                view.callback = {(view)in
                    let position = view.tag
                    self.fileList.remove(at: position)
                    self.reloadFileView(height: height)
                    self.delectFileCallBack?(position)
                }
                view.setData(name: item)
                viewList.append(view)
            }
            for (index,view) in viewList.enumerated() {
                view.frame = CGRect(x: 0, y: CGFloat(0 + index * 34), w: screenWidth - 36, h: 34)
            }
            self.fileView.addSubviews(viewList)
        }else{
            fileHeigt.constant = CGFloat(self.fileList.count * 34)
            finishHeight1.constant = height + CGFloat(self.fileList.count * 34)
        }
    }
    
    @IBAction func addFile(_ sender:UIButton){
        avatarImageViewTapHandler(PGActionSheet(buttonList: ["拍照", "从相册选择"]),sender)
    }
    
    @IBAction func sub(_ sender:UIButton){
        var params : [String:Any] = [:]
        params["taskId"] = self.workModel.taskId
        var stringList : [[String:Any]] = []
        for item in self.viewList {
            var param = [String:Any]()
            param["picName"] = item.picNote!.picName
            param["picCount"] = item.picNote!.picCount
            param["picUrlList"] = item.picNote!.picUrlList
            stringList.append(param)
        }
        params["finishPic"] = stringList.toJson()
        if self.noteTextView.text.count != 0{
            params["note"] = self.noteTextView.text
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
                //提交成功
                self?.toast("提交成功")
                self?.subCallBack?()
            }) {[weak self] (_) in
                self?.toast("提交失败")
        }.disposed(by: self.disposeBag)
    }
    
    func avatarImageViewTapHandler(_ actionSheet:PGActionSheet,_ button:UIButton) {
        actionSheet.actionSheetTranslucent = false
        self.currentViewController().present(actionSheet, animated: false, completion: nil)
        actionSheet.handler = {index in
            if index == 0 {
                PermissionManager.permission(type: .camera, completion: {
                    self.imagePicker(sourceType: .camera)
                })
            }else if index == 1 {
                PermissionManager.permission(type: .photoLibrary, completion: {
                    self.imagePicker(sourceType: .photoLibrary)
                })
            }else if index == 2 {
                let imagePicker = PGImagePicker(currentImageView: button.imageView!)
                self.currentViewController().present(imagePicker, animated: false, completion: nil)
            }else {
                button.setImage(UIImage(named: "upload_icon_photo"), for: .normal)
            }
        }
    }
    
    func imagePicker(sourceType: UIImagePickerController.SourceType) {
        let pickerVC = UIImagePickerController()
        pickerVC.view.backgroundColor = UIColor.white
        pickerVC.delegate = self
        pickerVC.allowsEditing = false
        pickerVC.sourceType = sourceType
        currentViewController().present(pickerVC, animated: true, completion: nil)
    }
    
}

extension WorkProgressItemCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentViewController().dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        currentViewController().dismiss(animated: true, completion: nil)
        var image: UIImage! = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        image = image.fixOrientation()
        self.showHUD(message: "上传中...")
        let data = image.jpegData(compressionQuality: 0.3)
        if let data = data {
            taskProvider.requestResult(.uploadImage(taskId: workModel.taskId, data: data), success: {(responseJson) in
                self.showHUD("上传成功", completion: {
                    self.hiddenHUD()
                })
                let url = responseJson["data"].arrayValue[0].stringValue
                self.addFileCallBack?(url)
            },failure: {(error)in
                self.hiddenHUD()
            })
        }
    }
}
