//
//  UserIdentityController.swift
//  application
//
//  Created by sitech on 2020/6/17.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
import PGActionSheet
class UserIdentityController: PGBaseViewController {
    
    //认证过
    @IBOutlet weak var passUiView:UIView!
    @IBOutlet weak var passBgUiView:UIView!
    @IBOutlet weak var passNameLabel:UILabel!
    @IBOutlet weak var passCardLabel:UILabel!
    //没有认证过
    @IBOutlet weak var verifyView:UIView!
    @IBOutlet weak var button1:UIButton!
    @IBOutlet weak var button2:UIButton!
    @IBOutlet weak var button3:UIButton!
    @IBOutlet weak var buttonSure:UIButton!
    @IBOutlet weak var userInfo:UIView!
    @IBOutlet weak var userNameView:UIView!
    @IBOutlet weak var userCodeView:UIView!
    @IBOutlet weak var userNameText:UITextField!
    @IBOutlet weak var userCodeText:UITextField!
    private var currentState = 0
    private let disposeBag = DisposeBag()
    private var list :[UserVerifyModel] = []
    private var photoList :[String] = ["","",""]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "实名认证"
        self.view.backgroundColor = UIColor(hexString: "#F6F6F6")
        makeRadius()
        requestData()
        NotificationCenter.default.addObserver(self, selector: #selector(textViewEditChanged(sender:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    private func requestData(){
        if let user = UserModel.unarchiver() {
            userProvider.rxRequest(.getUserVerifyList(userId: user.userId!, verifyType: 1))
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
            //审核状态（1为待审核，2为审核通过，3为审核不通过）
            self.currentState = model.verifyPassState
            if model.verifyPassState == 1 {
                button1.loadNetWorkImage(model.idCardPositivePic, placeholder: "real_upload_img_1")
                button2.loadNetWorkImage(model.idCardBackPic, placeholder: "real_upload_img_2")
                button3.loadNetWorkImage(model.idCardUserPic, placeholder: "real_upload_img_3")
                if model.realName.count != 0 {
                    userNameText.text = model.realName
                }
                if model.idCard.count != 0 {
                    userCodeText.text = model.idCard
                }
                self.userInfo.isHidden = false
                self.buttonSure.isEnabled = false
                self.buttonSure.setTitle("审核中，请等待", for: .normal)
                self.buttonSure.setTitle("审核中，请等待", for: .disabled)
                self.userInfo.isHidden = true
            }else if model.verifyPassState == 2 {
                verifyView.isHidden = true
                passUiView.isHidden = false
                passNameLabel.text = model.realName
                var str = model.idCard!
                if str.count == 18 {
                    let startIndex = str.index(str.startIndex, offsetBy:1)
                    let endIndex = str.index(str.startIndex, offsetBy:16)
                    let range = startIndex...endIndex
                    str.replaceSubrange(range, with:"*******************")
                }
                passCardLabel.text = str
                let bgView = UIView()
                let bgLayer1 = CAGradientLayer()
                bgLayer1.frame = CGRect(x: 0, y: 0, width: screenWidth-24, height: 120)
                bgLayer1.colors = [UIColor(hexString: "#FFE171")!.cgColor, UIColor(hexString: "#FFC15E")!.cgColor]
                bgLayer1.locations = [0, 1]
                bgLayer1.startPoint = CGPoint(x: 0, y: 0.5)
                bgLayer1.endPoint = CGPoint(x: 0.5, y: 0.5)
                bgLayer1.masksToBounds = true
                bgLayer1.cornerRadius = 4
                bgView.layer.addSublayer(bgLayer1)
                self.passBgUiView.insertSubview(bgView, at: 0)
            }else{
                verifyView.isHidden = false
            }
        }else{
            verifyView.isHidden = false
        }
    }
    
    private func makeRadius(){
        button1.layer.masksToBounds = true
        button1.layer.cornerRadius = 4
        button2.layer.masksToBounds = true
        button2.layer.cornerRadius = 4
        button3.layer.masksToBounds = true
        button3.layer.cornerRadius = 4
        buttonSure.layer.masksToBounds = true
        buttonSure.layer.cornerRadius = 4
        userNameView.layer.masksToBounds = true
        userNameView.layer.cornerRadius = 4
        userCodeView.layer.masksToBounds = true
        userCodeView.layer.cornerRadius = 4
        buttonSure.setTitleColor(UIColor(hexString: "#F6F6F6"), for: .disabled)
        buttonSure.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        buttonSure.setBackgroundColor(UIColor(hexString: "#CCCCCC")!, forState: .disabled)
        buttonSure.setBackgroundColor(UIColor(hexString: "#FFCC00")!, forState: .normal)
        buttonSure.isEnabled = false
    }
    
    var currentPhotoPosition = 0
    
    @IBAction func action1(_ sender: UIButton){
        if self.currentState == 1 || self.currentState == 2 {
            let imagePicker = PGImagePicker(currentImageView: sender.imageView!)
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
            let imagePicker = PGImagePicker(currentImageView: sender.imageView!)
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
    
    @IBAction func action3(_ sender: UIButton){
        if self.currentState == 1 || self.currentState == 2 {
            let imagePicker = PGImagePicker(currentImageView: sender.imageView!)
            self.currentViewController().present(imagePicker, animated: false, completion: nil)
            return
        }
        currentPhotoPosition = 2
        if photoList[2].count == 0{
            avatarImageViewTapHandler(PGActionSheet(buttonList: ["拍照", "从相册选择"]),sender)
        }else{
            avatarImageViewTapHandler(PGActionSheet(buttonList: ["拍照", "从相册选择", "查看照片"]),sender)
        }
    }
    
    @IBAction func buttonSureClick(_ sender: UIButton){
        var params : [String: Any] = [:]
        params["userId"] = UserModel.unarchiver()!.userId
        params["verifyType"] = 1
        params["idCardPositivePic"] = self.photoList[0]
        params["idCardBackPic"] = self.photoList[1]
        params["idCardUserPic"] = self.photoList[2]
        params["idCard"] = self.userCodeText.text
        params["realName"] = self.userNameText.text
        params["isApp"] = 1
        if !checkIdentityCardNumber(self.userCodeText.text!) {
            showPKHUD(message: "请输入合法身份证号码")
            return
        }
        userProvider.requestResult(.verifyUser(params:params)) {[weak self](json) in
            self?.view.showHUD("提交成功!", completion: {
                self?.pop()
            })
        }
    }
    
    @objc func textViewEditChanged(sender:NSNotification) {
        buttonState()
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
                let imagePicker = PGImagePicker(currentImageView: button.imageView!)
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
    
    func reloadPhoto(){
        button1.loadNetWorkImage(self.photoList[0], placeholder: "real_upload_img_1")
        button2.loadNetWorkImage(self.photoList[1], placeholder: "real_upload_img_2")
        button3.loadNetWorkImage(self.photoList[2], placeholder: "real_upload_img_3")
        buttonState()
    }
    
    func buttonState(){
        for item in self.photoList {
            if item.count == 0 {
                buttonSure.isEnabled = false
                break
            }
        }
        if userNameText.text == nil || userNameText.text!.count == 0 {
            buttonSure.isEnabled = false
            return
        }
        if userCodeText.text == nil || userCodeText.text!.count == 0 {
            buttonSure.isEnabled = false
            return
        }
        buttonSure.isEnabled = true
    }
}

extension UserIdentityController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
                if self.currentPhotoPosition == 0 {
                    userProvider.requestResult( .getIdentifyInfo(picUrl: url)) { (json) in
                        let wordsResult = responseJson["data"].dictionary
                        let result  = wordsResult?["words_result"]
                        if let result = result {
                            let code = result["公民身份号码"].dictionary?["words"]?.stringValue
                            let name = result["姓名"].dictionary?["words"]?.stringValue
                            if let name = name {
                                print(name)
                            }
                            if let code = code {
                                print(code)
                            }
                        }
                    }
                    self.userInfo.isHidden = false
                }
            },failure: {(error)in
                self.view.hiddenHUD()
            })
        }
    }
}
