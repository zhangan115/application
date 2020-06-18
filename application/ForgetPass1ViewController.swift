//
//  ForgetPass1ViewController.swift
//  application
//
//  Created by sitech on 2020/6/12.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import Toaster
import SwiftyJSON
import RxSwift

class ForgetPass1ViewController: PGBaseViewController {
    
    var forgetTitleStr = "忘记密码"
    var isSetPass = false
    var phoneNum = ""
    
    @IBOutlet weak var nameTextFiled:UITextField!
    @IBOutlet weak var passTextFiled:UITextField!
    @IBOutlet weak var toLoginButton:UIButton!
    @IBOutlet weak var getCodeButton:UIButton!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var noteLabel:UILabel!
    var userName:String?
    var userPass:String?
    
    var callback:((String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = forgetTitleStr
        self.view.backgroundColor = UIColor.white
        self.toLoginButton.layer.masksToBounds = true
        self.toLoginButton.layer.cornerRadius = 4
        self.toLoginButton.isEnabled = false
        self.nameTextFiled.addTarget(self, action: #selector(nameTextChange), for: .allEvents)
        self.passTextFiled.addTarget(self, action: #selector(passTextChange), for: .allEvents)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewEditChanged(sender:)), name: UITextField.textDidChangeNotification, object: nil)
        if isSetPass {
            self.nameTextFiled.isEnabled = false
            self.noteLabel.text = "手机号为当前账号，不可更改"
            if self.phoneNum.count > 0 {
                self.nameTextFiled.text = self.phoneNum
                self.userName = self.phoneNum
            }
        }
        stateChange()
    }
    
    @objc func textViewEditChanged(sender:NSNotification) {
        if nameTextFiled.isEditing {
            let textVStr = nameTextFiled.text! as NSString
            if (textVStr.length >= 11) {
                let str = textVStr.substring(to: 11)
                nameTextFiled.text = str
            }
        }else{
            let maxLength = 6
            let textVStr = passTextFiled.text! as NSString
            if (textVStr.length >= maxLength) {
                let str = textVStr.substring(to: maxLength)
                passTextFiled.text = str
            }
        }
    }
    
    var currentPhoneCode = ""
    
    
    @IBAction func toGetCode(_ sender: UIButton){
        if userName == nil || userName!.length == 0 {
            Toast(text: "请输入手机号").show()
            return
        }
        if isPhoneNumber(phoneNumber: userName!) {
            currentPhoneCode = ""
            userProvider.requestResult(.getCode(userMobile: userName!), success: { [weak self](code) in
                self?.currentPhoneCode = code["data"].stringValue
                print(self?.currentPhoneCode as Any)
                Toast(text: "发送成功").show()
                self?.countDown_1()
            })
        }else{
            Toast(text: "请输入合法手机号码").show()
        }
    }
    
    @IBAction func toNext(_ sender: UIButton){
        if userName == nil || userName!.count == 0 {
            Toast(text: "请输入手机号").show()
            return
        }
        if !isPhoneNumber(phoneNumber: userName!) {
            Toast(text: "请输入合法手机号码").show()
            return
        }
        if userPass == nil || userPass!.count == 0 {
            Toast(text: "请输入验证码").show()
            return
        }
        if userPass!.count != 6{
            Toast(text: "请输入合法验证码").show()
            return
        }
        if userPass! == currentPhoneCode {
            let viewController = ForgetPass2ViewController()
            viewController.phoneCode = currentPhoneCode
            viewController.phone = self.userName!
            viewController.isPresent = true
            viewController.callback = {(phone)in
                self.callback?(phone)
                self.pop()
            }
            self.presentVC(viewController)
        }else{
            Toast(text: "验证码错误").show()
        }
    }
    
    @IBAction func close(_ sender: UIButton){
        self.pop()
    }
    
    var timeCount = 60
    
    private let disposeBag = DisposeBag()
    
    func countDown_1() -> Void {
        self.getCodeButton.isEnabled = false
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            if self.timeCount != 0 {
                self.timeCount -= 1
                let text = String.localizedStringWithFormat("%ds",self.timeCount)
                self.getCodeButton.setTitle(text, for: .normal)
            }else if self.timeCount == 0 {
                timer.invalidate()
                self.getCodeButton.isEnabled = true
                self.getCodeButton.setTitle("获取验证码", for: .normal)
            }
        })
    }
    
    @objc func nameTextChange(){
        self.userName = self.nameTextFiled.text
        textChange()
    }
    
    @objc func passTextChange(){
        self.userPass = self.passTextFiled.text
        textChange()
    }
    
    private func textChange(){
        self.toLoginButton.isEnabled = self.userName?.count ?? -1 > 0 && self.userPass?.count ?? -1 > 0
    }
    
    func stateChange(){
        passTextFiled.isSecureTextEntry = false
        passTextFiled.keyboardType = UIKeyboardType.numberPad
        passTextFiled.textContentType = .none
    }
}
