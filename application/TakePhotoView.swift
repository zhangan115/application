//
//  TakePhotoView.swift
//  application
//
//  Created by Anson on 2020/7/6.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import PGActionSheet
class TakePhotoView: UIView {
    
    var picNote:PicNote?
    var callback:(()->())?
    var canTakePhoto = true
    
    lazy var titleLable:UILabel = {
        let view = UILabel()
        view.textColor = UIColor(hexString: "#454545")
        view.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(view)
        return view
    }()
    
    lazy var takePhotoButton :UIButton = {
        let view = UIButton()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        view.setImage(UIImage(named: "upload_icon_photo"), for: .normal)
        view.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        self.addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLable.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(12)
        }
        takePhotoButton.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(self.titleLable.snp.bottom).offset(8)
            make.width.height.equalTo(50)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(picNote:PicNote?){
        self.picNote = picNote
        if let note = picNote {
            if note.picUrlList != nil && !note.picUrlList.isEmpty && note.picUrlList[0].count > 1 {
                takePhotoButton.loadNetWorkImage(note.picUrlList[0], placeholder: "img_null")
            }else{
                takePhotoButton.setImage(UIImage(named: "upload_icon_photo"), for: .normal)
            }
        }
    }
    
    @objc func takePhoto(){
        if canTakePhoto {
            if let note = picNote {
                if  note.picUrlList != nil && !note.picUrlList.isEmpty && note.picUrlList[0].count > 1{
                    avatarImageViewTapHandler(PGActionSheet(buttonList: ["拍照", "从相册选择", "查看照片","删除照片"]),takePhotoButton)
                }else {
                    avatarImageViewTapHandler(PGActionSheet(buttonList: ["拍照", "从相册选择"]),takePhotoButton)
                }
            }
        }else{
            let imagePicker = PGImagePicker(currentImageView: takePhotoButton.imageView!)
            self.currentViewController().present(imagePicker, animated: false, completion: nil)
        }
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
                self.picNote?.picUrlList.removeAll()
                self.callback?()
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

extension TakePhotoView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            taskProvider.requestResult(.uploadImage(taskId: nil, data: data), success: {(responseJson) in
                self.showHUD("上传成功", completion: {
                    self.hiddenHUD()
                })
                let url = responseJson["data"].arrayValue[0].stringValue
                self.takePhotoButton.loadNetWorkImage(url)
                self.picNote?.picUrlList.removeAll()
                self.picNote?.picUrlList.append(url)
                self.callback?()
            },failure: {(error)in
                self.hiddenHUD()
            })
        }
    }
}
