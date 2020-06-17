//
//  ForgetPass2ViewController.swift
//  application
//
//  Created by sitech on 2020/6/12.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import Toaster
import SwiftyJSON

class ForgetPass2ViewController: UIViewController {
    
    @IBOutlet weak var nameTextFiled:UITextField!
    @IBOutlet weak var passTextFiled:UITextField!
    @IBOutlet weak var toLoginButton:UIButton!
    
    var phoneCode = ""
    var phone = ""
    var callback:((String)->())?
    
    var userName:String?
    var userPass:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.toLoginButton.layer.masksToBounds = true
        self.toLoginButton.layer.cornerRadius = 4
        self.toLoginButton.isEnabled = false
        self.nameTextFiled.addTarget(self, action: #selector(nameTextChange), for: .allEvents)
        self.passTextFiled.addTarget(self, action: #selector(passTextChange), for: .allEvents)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewEditChanged(sender:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
     var maxLength = 20
    
    @objc func textViewEditChanged(sender:NSNotification) {
         if nameTextFiled.isEditing {
             let textVStr = nameTextFiled.text! as NSString
             if (textVStr.length >= maxLength) {
                 let str = textVStr.substring(to: maxLength)
                 nameTextFiled.text = str
             }
         }else{
             let textVStr = passTextFiled.text! as NSString
             if (textVStr.length >= maxLength) {
                 let str = textVStr.substring(to: maxLength)
                 passTextFiled.text = str
             }
         }
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
    
    @IBAction func sure(_ sender: UIButton){
        if userName == nil || userPass == nil {
            Toast(text: "请输入密码").show()
            return
        }
        if userName! != userPass! {
            Toast(text: "输入的2次密码不一致").show()
            return
        }
        if !isPassWord(passWord: userName!) {
            Toast(text: "请输入合法的密码").show()
            return
        }
        userProvider.requestResult(.userChangePass(userMobile: phone, password: userName!, vCode: phoneCode)
            , success: {[weak self](data) in
                self?.changePassSuccess()
        })
    }
    
    private func changePassSuccess(){
        showPKHUD(message: "密码修改成功", completion: {(bool)in
            self.callback?(self.phone)
            self.dismissVC(completion: nil)
        })
    }
    
    @IBAction func close(_ sender: UIButton){
        self.dismissVC(completion: nil)
    }
    
}
