//
//  UserElectricianController.swift
//  application
//
//  Created by sitech on 2020/6/17.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
import PGActionSheet
class UserElectricianController: PGBaseViewController {
    
    @IBOutlet weak var button1:UIButton!
    @IBOutlet weak var button2:UIButton!
    @IBOutlet weak var buttonSure:UIButton!
    @IBOutlet weak var labelNote:UILabel!
    @IBOutlet weak var layout1:UIView!
    @IBOutlet weak var layout2:UIView!
    
    @IBOutlet weak var width1:NSLayoutConstraint!
    @IBOutlet weak var width2: NSLayoutConstraint!
    @IBOutlet weak var left1: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    private var list :[UserVerifyModel] = []
    private var photoList :[String] = ["",""]
    private var currentState = 0
    var mWidth : CGFloat = 0
    var currentPhotoPosition = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "电工认证"
        self.view.backgroundColor = UIColor(hexString: "#F6F6F6")
        buttonSure.layer.masksToBounds = true
        buttonSure.layer.cornerRadius = 4
        buttonSure.setTitle("审核中，请等待", for: .normal)
        buttonSure.setTitle("审核中，请等待", for: .disabled)
        buttonSure.setTitleColor(UIColor(hexString: "#F6F6F6"), for: .disabled)
        buttonSure.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        buttonSure.setBackgroundColor(UIColor(hexString: "#CCCCCC")!, forState: .disabled)
        buttonSure.setBackgroundColor(UIColor(hexString: "#FFCC00")!, forState: .normal)
        buttonSure.isEnabled = false
        mWidth = (screenWidth - 34) / 2
        width1.constant = mWidth
        width2.constant = mWidth
        left1.constant  = mWidth + 10
        button1.setImage(UIImage(named: "qualifications_img1"), for: .normal)
        button2.setImage(UIImage(named: "qualifications_img2"), for: .normal)
        requestData()
    }
    
    private func requestData(){
        if let user = UserModel.unarchiver() {
            userProvider.rxRequest(.getUserVerifyList(userId: user.userId!, verifyType: 2))
                .toListModel(type:UserVerifyModel.self)
                .subscribe(onSuccess: {[weak self](list) in
                    self?.list = list
                    self?.dataToShow(model: list.last)
                }) {[weak self](erro) in
                    self?.dataToShow(model: nil)
            }.disposed(by: disposeBag)
        }
    }
    
    private func dataToShow(model:UserVerifyModel?){
        if let model = model {
            self.currentState = model.verifyPassState
            //审核状态（1为待审核，2为审核通过，3为审核不通过）
            if model.verifyPassState == 1 {
                photoList[0] = model.specialOperationPic
                if photoList[0].count == 0 {
                    left1.constant  = 0
                    layout1.isHidden = true
                }
                photoList[1] = model.vocationalQualificationPic
                if photoList[1].count == 0 {
                    layout2.isHidden = true
                }
                button1.loadNetWorkImage(model.specialOperationPic, placeholder: "qualifications_img1")
                button2.loadNetWorkImage(model.vocationalQualificationPic, placeholder: "qualifications_img2")
                buttonSure.setTitle("审核中，请等待", for: .normal)
                buttonSure.setTitle("审核中，请等待", for: .disabled)
                buttonSure.isEnabled = false
            }else if model.verifyPassState == 2 {
                photoList[0] = model.specialOperationPic
                if photoList[0].count == 0 {
                    left1.constant  = 0
                    layout1.isHidden = true
                }
                photoList[1] = model.vocationalQualificationPic
                if photoList[1].count == 0 {
                    layout2.isHidden = true
                }
                button1.loadNetWorkImage(model.specialOperationPic, placeholder: "qualifications_img1")
                button2.loadNetWorkImage(model.vocationalQualificationPic, placeholder: "qualifications_img2")
                labelNote.text = "如需更改操作证，或上传职业资格等级证，点击下方更新信息，进行上传！"
                buttonSure.setTitle("更新信息", for: .normal)
                buttonSure.isEnabled = true
            }else if model.verifyPassState == 3{
                for item in self.list.reversed() {
                    if item.verifyPassState == 2 {
                        dataToShow(model: item)
                        break
                    }
                }
            }
        }
    }
    
    @IBAction func sureClick(_ sender: UIButton){
        if currentState == 2 {
            layout1.isHidden = false
            layout2.isHidden = false
            left1.constant  = mWidth + 10
            buttonSure.setTitle("提交审核", for: .normal)
            labelNote.text = "请按照示意图上传本人电工证信息，避免模糊、反光、遮挡、光线过暗、信息不全"
            currentState = 0
        }else{
            var params : [String: Any] = [:]
            params["userId"] = UserModel.unarchiver()!.userId
            params["verifyType"] = 2
            params["isApp"] = 1
            if self.photoList[0].count != 0 {
                params["specialOperationPic"] = self.photoList[0]
            }
            if self.photoList[1].count != 0 {
                params["vocationalQualificationPic"] = self.photoList[1]
            }
            userProvider.requestResult(.verifyUser(params:params)) {[weak self](json) in
                self?.view.showHUD("提交成功!", completion: {
                    self?.pop()
                })
            }
        }
    }
    
    private func buttonState(){
        if photoList[0].count == 0 && photoList[1].count == 0 {
            buttonSure.isEnabled = false
        }
    }
    
    func reloadPhoto(){
        button1.loadNetWorkImage(self.photoList[0], placeholder: "qualifications_img1")
        button2.loadNetWorkImage(self.photoList[1], placeholder: "qualifications_img2")
        buttonState()
    }
    
    @IBAction func action1(_ sender: UIButton){
        if self.currentState == 1 || self.currentState == 2 {
            let imagePicker = PGImagePicker(currentImageView: button1.imageView!)
            self.currentViewController().present(imagePicker, animated: false, completion: nil)
            return
        }
        currentPhotoPosition = 0
        if photoList[0].count == 0{
            avatarImageViewTapHandler(PGActionSheet(buttonList: ["拍照", "从相册选择"]),sender)
        }else{
            avatarImageViewTapHandler(PGActionSheet(buttonList: ["拍照", "从相册选择", "查看照片"]),sender)
        }
    }
    
    @IBAction func action2(_ sender: UIButton){
        if self.currentState == 1 || self.currentState == 2 {
            let imagePicker = PGImagePicker(currentImageView:button2.imageView!)
            self.currentViewController().present(imagePicker, animated: false, completion: nil)
            return
        }
        currentPhotoPosition = 1
        if photoList[1].count == 0{
            avatarImageViewTapHandler(PGActionSheet(buttonList: ["拍照", "从相册选择"]),sender)
        }else{
            avatarImageViewTapHandler(PGActionSheet(buttonList: ["拍照", "从相册选择", "查看照片"]),sender)
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
            }else {
                let imagePicker = PGImagePicker(currentImageView: UIImageView(image: button.image(for: .normal)))
                self.currentViewController().present(imagePicker, animated: false, completion: nil)
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

extension UserElectricianController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            userProvider.requestResult(.postUserVerifyPhoto(data: data), success: {(responseJson) in
                self.view.showHUD("上传成功", completion: {
                    self.view.hiddenHUD()
                })
                let url = responseJson["data"].stringValue
                self.photoList[self.currentPhotoPosition] = url
                self.reloadPhoto()
                self.buttonSure.setTitle("提交审核", for: .normal)
                self.buttonSure.isEnabled = true
            },failure: {(error)in
                self.view.hiddenHUD()
            })
        }
    }
}
