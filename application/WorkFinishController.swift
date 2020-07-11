//
//  WorkFinishController.swift
//  application
//
//  Created by Anson on 2020/7/6.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
import PGActionSheet
import RealmSwift
class WorkFinishController: PGBaseViewController {
    
    var workModel:WorkModel!
    var disposeBag = DisposeBag()
    var callback:(()->())?
    var viewList:[TakePhotoView] = []
    var fileList : [String]  = []
    var fileUrlList : [String]  = []
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
        self.view.addSubview(view)
        return view
    }()
    
    lazy var fileLabel : UILabel = {
        let view = UILabel()
        view.text = "附件"
        view.textColor = UIColor(hexString: "#454545")
        view.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(view)
        return view
    }()
    
    lazy var fileView : UIView = {
        let view = UIView()
        self.view.addSubview(view)
        return view
    }()
    
    lazy var addFileButton : UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(addFile), for: .touchUpInside)
        view.setImage(UIImage(named: "upload_icon_annex"), for: .normal)
        self.view.addSubview(view)
        return view
    }()
    
    lazy var noteLabel : UILabel = {
        let view = UILabel()
        view.text = "备注"
        view.textColor = UIColor(hexString: "#454545")
        view.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(view)
        return view
    }()
    
    lazy var textInput : UITextView = {
        let view = UITextView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        view.backgroundColor = UIColor.white
        view.textColor = UIColor(hexString: "#333333")
        view.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "完成后资料上传"
        self.view.backgroundColor = ColorConstants.tableViewBackground
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
        if let before =  self.workModel.afterFinishFile {
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
        }
    }
    
    let realm = try! Realm()
    
    @objc func startAction(){
        var canSub = true
        var params : [String:Any] = [:]
        params["taskId"] = self.workModel.taskId
        var stringList : [[String:Any]] = []
        for item in self.viewList {
            if item.picNote!.picUrlList == nil || item.picNote!.picUrlList.isEmpty {
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
            self.view.showAutoHUD("请完成资料上传")
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
                self?.view.toast("提交成功")
                self?.navigationController?.popViewController(animated: false)
                self?.callback?()
            }) {[weak self] (_) in
                self?.view.toast("提交失败")
        }.disposed(by: self.disposeBag)
    }
    
    @objc func addFile(){
        avatarImageViewTapHandler(PGActionSheet(buttonList: ["拍照", "从相册选择"]),addFileButton)
    }
    
    func requestModel(){
        taskProviderNoPlugin.rxRequest(.getWorkDetail(taskId: self.workModel.taskId))
            .toModel(type: WorkModel.self)
            .subscribe(onSuccess: { [weak self](model) in
                self?.workModel = model
                self?.initView()
            }) { (_) in
                print("error")
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
    
    func updateFileView(){
        self.fileView.removeSubviews()
        for (index,file) in self.fileList.enumerated(){
            let view = WorkFileVIew()
            view.fileUrl = self.fileUrlList[index]
            view.fileName = file
            view.setData(name: file)
            view.frame = CGRect(x: 0, y: CGFloat(0 + 34 * index), w: screenWidth, h: 34)
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

extension WorkFinishController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentViewController().dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        currentViewController().dismiss(animated: true, completion: nil)
        var image: UIImage! = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        image = image.fixOrientation()
        self.view.showHUD(message: "上传中...")
        let data = image.jpegData(compressionQuality: 0.3)
        if let data = data {
            taskProvider.requestResult(.uploadImage(taskId: workModel.taskId, data: data), success: {(responseJson) in
                self.view.showHUD("上传成功", completion: {
                    self.view.hiddenHUD()
                })
                let url = responseJson["data"].arrayValue[0].stringValue
                let saveName = url.split("/").last ?? ""
                self.fileList.append(saveName)
                self.fileUrlList.append(url)
                self.updateFileView()
            },failure: {(error)in
                self.view.hiddenHUD()
            })
        }
    }
}
