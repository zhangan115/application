//
//  FinishItemCell.swift
//  application
//
//  Created by sitech on 2020/7/17.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
import PGActionSheet
import RealmSwift

class FinishItemCell: UITableViewCell {
    
    @IBOutlet var uiViewView:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var workModel:WorkModel!
    var disposeBag = DisposeBag()
    var callback:(()->())?
    var viewList:[TakePhotoView] = []
    var fileList : [String]  = []
    var fileUrlList : [String]  = []
    var picUrlList:[String]  = []
    var fromController:Int = -1
    let realm = try! Realm()
    var dataRealm:TaskFinishRealm? = nil
    var dataRoutRealm:Results<TaskRoutRealm>? = nil
    
    lazy var startButton:UIButton = {
        let view = UIButton()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        view.setTitle("提交验收", for: .normal)
        view.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        view.setTitleColor(UIColor(hexString: "#F6F6F6"), for: .disabled)
        view.setBackgroundColor(UIColor(hexString: "#FFCC00")!, forState: .normal)
        view.setBackgroundColor(UIColor(hexString: "#CCCCCC")!, forState: .disabled)
        view.addTarget(self, action: #selector(startAction), for: .touchUpInside)
        view.isEnabled = false
        self.uiViewView.addSubview(view)
        return view
    }()
    
    lazy var fileLabel : UILabel = {
        let view = UILabel()
        view.text = "附件"
        view.textColor = UIColor(hexString: "#454545")
        view.font = UIFont.systemFont(ofSize: 15)
        self.uiViewView.addSubview(view)
        return view
    }()
    
    lazy var fileView : UIView = {
        let view = UIView()
        self.uiViewView.addSubview(view)
        return view
    }()
    
    lazy var addFileButton : UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(addFile), for: .touchUpInside)
        view.setImage(UIImage(named: "upload_icon_annex"), for: .normal)
        self.uiViewView.addSubview(view)
        return view
    }()
    
    lazy var noteLabel : UILabel = {
        let view = UILabel()
        view.text = "备注"
        view.textColor = UIColor(hexString: "#454545")
        view.font = UIFont.systemFont(ofSize: 15)
        self.uiViewView.addSubview(view)
        return view
    }()
    
    lazy var textInput : PlaceholderTextView = {
        let view = PlaceholderTextView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        view.backgroundColor = UIColor.white
        view.placeholder = "请输入备注信息"
        view.placeholderColor = UIColor(hexString: "#BBBBBB")!
        view.placeholderFont = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor(hexString: "#333333")
        view.font = UIFont.systemFont(ofSize: 14)
        self.uiViewView.addSubview(view)
        return view
    }()
    
    lazy var countText : UILabel = {
        let view = UILabel()
        view.textColor = UIColor(hexString: "#888888")
        view.text = 256.toString
        view.font = UIFont.systemFont(ofSize: 14)
        self.uiViewView.addSubview(view)
        return view
    }()
    
    func setData(_ model:WorkModel){
        self.workModel = model
        self.initView()
    }
    
    private func initView(){
        if let finish =  self.workModel.afterFinishFile {
            if finish.nodePicList == nil {
                return
            }
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
                self.fileList = self.dataRealm!.fileNameList?.split(",") ?? []
                self.fileUrlList = self.dataRealm!.fileUrList?.split(",") ?? []
                if self.dataRealm!.note != nil && self.dataRealm!.note!.count > 0 {
                    self.textInput.text = self.dataRealm!.note
                    self.countText.text = (MAX_STARWORDS_LENGTH - textInput.text.count).toString
                }
                if let url = self.dataRealm!.photoList?.split(",") {
                    self.picUrlList = url
                }
            }
            viewList.removeAll()
            var canSub = true
            for (index,item) in finish.nodePicList.enumerated() {
                let view = TakePhotoView()
                if !picUrlList.isEmpty && picUrlList.count == finish.nodePicList.count {
                    if item.picUrlList.isEmpty || item.picUrlList[0].count == 0{
                        item.picUrlList = [picUrlList[index]]
                    }
                }else{
                    picUrlList.append("-")
                }
                view.titleLable.text = item.picName
                view.setData(picNote: item)
                if item.picUrlList.isEmpty || item.picUrlList[0].count < 2{
                    if canSub == true {
                        canSub = false
                    }
                }
                view.callback = {
                    self.picUrlList.removeAll()
                    var canStart = true
                    for item in self.viewList {
                        var photoUrl = "-"
                        if item.picNote!.picUrlList != nil && !item.picNote!.picUrlList!.isEmpty && item.picNote!.picUrlList[0].count > 1 {
                            photoUrl = item.picNote?.picUrlList[0] ?? "-"
                        }else{
                            canStart = false
                        }
                        self.picUrlList.append(photoUrl)
                    }
                    self.startButton.isEnabled = canStart
                }
                view.tag = index
                view.picNote = item
                self.viewList.append(view)
            }
            self.startButton.isEnabled = canSub
            if !viewList.isEmpty {
                self.uiViewView.addSubviews(self.viewList)
                for (index,view) in viewList.enumerated() {
                    view.frame = CGRect(x: 0, y: CGFloat(0 + index * 90), w: screenWidth, h: 90)
                }
            }
            fileLabel.snp.updateConstraints { (make) in
                make.left.equalToSuperview().offset(12)
                make.top.equalTo(self.viewList.last!.snp.bottom).offset(20)
            }
            fileView.snp.updateConstraints { (make) in
                make.left.equalToSuperview().offset(12)
                make.right.equalToSuperview().offset(-12)
                make.height.equalTo(0)
                make.top.equalTo(self.fileLabel.snp.bottom).offset(12)
            }
            addFileButton.snp.updateConstraints { (make) in
                make.left.equalToSuperview().offset(12)
                make.width.height.equalTo(27)
                make.top.equalTo(self.fileView.snp.bottom).offset(0)
            }
            noteLabel.snp.updateConstraints { (make) in
                make.left.equalToSuperview().offset(12)
                make.top.equalTo(self.addFileButton.snp.bottom).offset(16)
            }
            textInput.snp.updateConstraints { (make) in
                make.left.equalToSuperview().offset(12)
                make.right.equalToSuperview().offset(-12)
                make.height.equalTo(100)
                make.top.equalTo(self.noteLabel.snp.bottom).offset(12)
            }
            countText.snp.updateConstraints { (make) in
                make.right.equalToSuperview().offset(-24)
                make.bottom.equalTo(self.textInput.snp.bottom).offset(-8)
            }
            startButton.snp.updateConstraints { (make) in
                make.left.equalToSuperview().offset(30)
                make.right.equalToSuperview().offset(-30)
                make.top.equalTo(self.textInput.snp.bottom).offset(50)
                make.height.equalTo(44)
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(textViewEditChanged(sender:)), name: UITextView.textDidChangeNotification, object: nil)
        updateFileView()
    }
    
    let MAX_STARWORDS_LENGTH = 256
    
    @objc func textViewEditChanged(sender:NSNotification) {
        let textVStr = textInput.text as NSString
        if (textVStr.length >= MAX_STARWORDS_LENGTH) {
            let str = textVStr.substring(to: MAX_STARWORDS_LENGTH)
            textInput.text = str
            self.workModel.lastNote =  textInput.text
        }
        countText.text = (MAX_STARWORDS_LENGTH - textInput.text.count).toString
    }
    
    @objc func startAction(){
        var canSub = true
        var params : [String:Any] = [:]
        params["taskId"] = self.workModel.taskId
        var stringList : [[String:Any]] = []
        for item in self.viewList {
            if item.picNote!.picUrlList == nil || item.picNote!.picUrlList.isEmpty || item.picNote!.picUrlList[0].count < 2 {
                canSub = false
                break
            }
            var param = [String:Any]()
            param["picName"] = item.picNote!.picName
            param["picCount"] = item.picNote!.picCount
            param["picUrlList"] = item.picNote!.picUrlList
            stringList.append(param)
        }
        if !canSub {
            self.showAutoHUD("请完成资料上传")
            return
        }
        params["finishPic"] = stringList.toJson()
        if self.textInput.text.count != 0{
            params["note"] = self.textInput.text
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
                self.dataRoutRealm = list
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
                self?.callback?()
            }) {[weak self] (_) in
                self?.toast("提交失败")
        }.disposed(by: self.disposeBag)
    }
    
    @objc func addFile(){
        if self.fileList.count > 9 {
            self.toast("最多添加9个附件")
            return
        }
        avatarImageViewTapHandler(PGActionSheet(buttonList: ["拍照", "从相册选择"]),addFileButton)
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
    
    func updateFileView(){
        self.fileView.removeSubviews()
        for (index,file) in self.fileList.enumerated(){
            let view = WorkFileVIew()
            view.fileUrl = self.fileUrlList[index]
            view.fileName = file
            view.setData(name: file)
            view.tag = index
            view.frame = CGRect(x: 0, y: CGFloat(0 + 34 * index), w: screenWidth - 12, h: 34)
            view.callback = {(view)in
                let position = view.tag
                self.fileList.remove(at: position)
                self.fileUrlList.remove(at: position)
                self.updateFileView()
            }
            self.fileView.addSubview(view)
        }
        fileView.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(CGFloat( 34 * self.fileList.count))
            make.top.equalTo(self.fileLabel.snp.bottom).offset(12)
        }
    }
}

extension FinishItemCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
                let saveName = url.split("/").last ?? ""
                self.fileList.append(saveName)
                self.fileUrlList.append(url)
                self.updateFileView()
            },failure: {(error)in
                self.hiddenHUD()
            })
        }
    }
}
