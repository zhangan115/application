//
//  UserCenterController.swift
//  application
//
//  Created by sitech on 2020/6/17.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import PGActionSheet
class UserCenterController: PGBaseViewController {
    
    var userModel:UserModel!
    var callBack:(()->())?
    
    lazy var userView : UIView = {
        let view = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(showUserData))
        view.addGestureRecognizer(tap)
        self.view.addSubview(view)
        return view
    }()
    
    @objc func showUserData(){
        let controller  = UserDataController()
        self.pushVC(controller)
    }
    
    lazy var userIcon : UIButton = {
        let view = UIButton()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 30
        view.addTarget(self, action: #selector(showUserIcon), for: .touchUpInside)
        self.userView.addSubview(view)
        return view
    }()
    
    @objc func showUserIcon(){
        if userModel.portraitUrl.count == 0 {
            avatarImageViewTapHandler(PGActionSheet(buttonList: ["拍照", "从相册选择"]),userIcon)
        }else{
            avatarImageViewTapHandler(PGActionSheet(buttonList: ["拍照", "从相册选择", "查看照片"]),userIcon)
        }
    }
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#454545")
        label.font = UIFont.systemFont(ofSize: 16)
        self.userView.addSubview(label)
        return label
    }()
    
    lazy var userType: UIView = {
        let layerView = UIView()
        layerView.layer.masksToBounds = true
        layerView.layer.cornerRadius = 9
        self.userView.addSubview(layerView)
        return layerView
    }()
    
    lazy var userTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#999999")
        label.font = UIFont.systemFont(ofSize: 11)
        self.userType.addSubview(label)
        return label
    }()
    
    lazy var userArror :UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "work_detail_icon_next")
        self.userView.addSubview(view)
        return view
    }()
    
    lazy var item1:UserCenterItemView = {
        let view = UserCenterItemView()
        self.view.addSubview(view)
        return view
    }()
    
    lazy var item2:UserCenterItemView = {
        let view = UserCenterItemView()
        view.label.text = "资格认证"
        self.view.addSubview(view)
        return view
    }()
    
    lazy var userLabel2: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#333333")
        label.font = UIFont.systemFont(ofSize: 12)
        self.userView.addSubview(label)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人中心"
        isPresent = true
        self.view.backgroundColor = UIColor(hexString: "#F6F6F6")
        let bgView = UIView()
        let bgLayer1 = CAGradientLayer()
        bgLayer1.frame = CGRect(x: 10, y: 16, width: screenWidth-20, height: 94)
        bgLayer1.colors = [UIColor(hexString: "#FFE171")!.cgColor, UIColor(hexString: "#FFC15E")!.cgColor]
        bgLayer1.locations = [0, 1]
        bgLayer1.startPoint = CGPoint(x: 0, y: 0.5)
        bgLayer1.endPoint = CGPoint(x: 0.5, y: 0.5)
        bgLayer1.masksToBounds = true
        bgLayer1.cornerRadius = 4
        bgView.layer.addSublayer(bgLayer1)
        self.view.insertSubview(bgView, at: 0)
        userView.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(94)
        }
        userIcon.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }
        userNameLabel.snp.updateConstraints{(make)in
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(self.userIcon.snp.right).offset(12)
        }
        userType.snp.updateConstraints{(make)in
            make.left.equalTo(self.userIcon.snp.right).offset(12)
            make.top.equalTo(self.userNameLabel.snp.bottom).offset(10)
            make.width.equalTo(50)
            make.height.equalTo(18)
        }
        userTypeLabel.snp.updateConstraints{(make)in
            make.centerX.centerY.equalToSuperview()
        }
        userLabel2.snp.updateConstraints{(make)in
            make.left.equalTo(self.userIcon.snp.right).offset(12)
            make.top.equalTo(self.userType.snp.bottom).offset(10)
        }
        userArror.snp.updateConstraints{(make)in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-18)
        }
        item1.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(self.userView.snp.bottom).offset(16)
            make.height.equalTo(44)
        }
        item2.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(self.item1.snp.bottom).offset(12)
            make.height.equalTo(44)
        }
        userModel = UserModel.unarchiver()
        setData(userModel!)
        item1.setData(0)
        item2.setData(1)
    }
    
    func setData(_ model:UserModel){
        userIcon.loadNetWorkImage(model.portraitUrl ?? "", placeholder: "user_header_nor")
        if model.realName != nil && model.realName!.count > 0 {
            userNameLabel.text = model.realName
        }else if model.userMobile != nil && model.userMobile!.count > 0 {
            userLabel2.text = ""
            if isPhoneNumber(phoneNumber: model.userMobile!) {
                var str = model.userMobile!
                let startIndex = str.index(str.startIndex, offsetBy:3)
                let endIndex = str.index(str.startIndex, offsetBy:7)
                let range = startIndex...endIndex
                str.replaceSubrange(range, with:"*****")
                userNameLabel.text = str
            }else {
                userNameLabel.text = model.userMobile!
            }
        }else{
            userNameLabel.text = model.username
        }
        if model.certificationType!>0 {
            userTypeLabel.text = "已认证"
            userTypeLabel.textColor = UIColor.white
            userType.backgroundColor = UIColor(hexString: "#00A0FF")
            if model.certificationType!>1{
                var contentText = ""
                let text1 = getSpecialString(level: model.specialOperationGrade!)
                let text2 = getVocationalString(level: model.vocationalQualificationGrade!)
                if text1 != nil {
                    contentText = text1!
                }
                if text2 != nil {
                    if contentText.count > 0 {
                        contentText = contentText + "、"
                    }
                    contentText = contentText + text2!
                }
                userLabel2.text = contentText
            }
        }else{
            userLabel2.text = ""
            userTypeLabel.text = "未认证"
            userTypeLabel.textColor = UIColor(hexString: "#999999")
            userType.backgroundColor = UIColor(hexString: "#EFEFEF")
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

extension UserCenterController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            userProvider.requestResult(.postUserPhoto(data: data), success: {[weak self](responseJson) in
                let url = responseJson["data"].stringValue
                let userId = UserModel.unarchiver()!.userId!
                var params :[String:Any] = [:]
                params["userId"] = userId
                params["portraitUrl"] = url
                userProvider.requestResult(.editUser(params:params),success:{[weak self](json) in
                    self?.userModel.portraitUrl = url
                    if let model = self?.userModel {
                        self?.setData(model)
                        UserModel.archiverUser(model)
                        self?.callBack!()
                    }
                    self?.view.showHUD("修改成功", completion: {
                        self?.view.hiddenHUD()
                    })
                    },failure:{(error)in
                        self?.view.hiddenHUD()
                })
                },failure: {(error)in
                    self.view.hiddenHUD()
            })
        }
    }
}
