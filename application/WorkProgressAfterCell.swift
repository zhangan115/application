//
//  WorkProgressAfterCell.swift
//  application
//
//  Created by sitech on 2020/7/9.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import PGActionSheet
class WorkProgressAfterCell: UITableViewCell {
    
    @IBOutlet var bgView2 : UIView! // 背景
    @IBOutlet var addFileButton : UIButton!
    @IBOutlet var noteTextView : PlaceholderTextView!
    @IBOutlet var fileView : UIView!
    @IBOutlet var finishView : UIView!
    @IBOutlet weak var fileHeigt: NSLayoutConstraint!
    @IBOutlet weak var finishlayoutHeight1: NSLayoutConstraint!
    @IBOutlet var textCount:UILabel!
    
    var workModel:WorkModel!
    
    var updateCallBack:(()->())?
    var addFileCallBack:((String)->())?
    var delectFileCallBack:((Int)->())?
    
    var fileList:[String] = []
    var fileUrlList:[String]  = []
    var viewList:[TakePhotoView] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
        bgView2.layer.masksToBounds = true
        bgView2.layer.cornerRadius = 4
    }
    
    func setModel(workModel:WorkModel){
        self.workModel = workModel
        if workModel.taskState == WorkState.WORK_PROGRESS.rawValue && !workModel.isTerminated {
            addFileButton.isHidden = false
            textCount.isHidden = false
            noteTextView.placeholder = "请输入备注信息"
            noteTextView.placeholderColor = UIColor(hexString: "#BBBBBB")!
            noteTextView.placeholderFont = UIFont.systemFont(ofSize: 14)
        }else{
            addFileButton.isHidden = true
            addFileButton.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            textCount.isHidden = true
        }
        if let finish = workModel.afterFinishFile {
            if finish.nodePicList != nil && !finish.nodePicList.isEmpty{
                finishlayoutHeight1.constant =  CGFloat(finish.nodePicList.count * 90 + 12)
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
            }
        }
        self.fileView.removeSubviews()
        reloadFileView()
        if workModel.taskState > WorkState.WORK_PROGRESS.rawValue {
            noteTextView.backgroundColor = ColorConstants.tableViewBackground
            noteTextView.isEditable = false
            if workModel.afterFinishFile != nil {
                noteTextView.text = workModel.afterFinishFile!.nodeNote
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(textViewEditChanged(sender:)), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    let MAX_STARWORDS_LENGTH = 256
    
    @objc func textViewEditChanged(sender:NSNotification) {
        let textVStr = noteTextView.text as NSString
        if (textVStr.length >= MAX_STARWORDS_LENGTH) {
            let str = textVStr.substring(to: MAX_STARWORDS_LENGTH)
            noteTextView.text = str
        }
        textCount.text = (MAX_STARWORDS_LENGTH - noteTextView.text.count).toString
    }
    
    private func reloadFileView(){
        self.fileView.removeSubviews()
        if !self.fileList.isEmpty {
            fileHeigt.constant = CGFloat(self.fileList.count * 34)
            var viewList : [WorkFileVIew] = []
            for (index,item) in self.fileList.enumerated() {
                let view = WorkFileVIew()
                view.fileName = item
                view.fileUrl = self.fileUrlList[index]
                view.tag = index
                view.delectButton.isHidden = self.workModel.taskState != WorkState.WORK_PROGRESS.rawValue && !self.workModel.isTerminated || self.workModel.isTerminated
                view.callback = {(view)in
                    let position = view.tag
                    self.fileList.remove(at: position)
                    self.reloadFileView()
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
        }
    }
    
    @IBAction func addFile(_ sender:UIButton){
        avatarImageViewTapHandler(PGActionSheet(buttonList: ["拍照", "从相册选择"]),sender)
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

extension WorkProgressAfterCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
