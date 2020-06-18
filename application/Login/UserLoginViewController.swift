//
//  UserLoginViewController.swift
//  application
//
//  Created by sitech on 2020/6/10.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import Toaster
import SwiftyJSON
import RxSwift
import IQKeyboardManagerSwift

class UserLoginViewController: BaseHomeController {
    
    @IBOutlet weak var nameTextFiled:UITextField!
    @IBOutlet weak var passTextFiled:UITextField!
    @IBOutlet weak var toLoginButton:UIButton!
    @IBOutlet weak var toChangeStateButton:UIButton!
    @IBOutlet weak var getCodeButton:UIButton!
    @IBOutlet weak var forgetPass:UIButton!
    @IBOutlet weak var getCodeView:UIView!
    @IBOutlet weak var codeImage:UIImageView!
    
    var userName:String?
    var userPass:String?
    var currentState:Bool = true // false 使用验证码登录 true 使用手机号密码登录
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.toLoginButton.layer.masksToBounds = true
        self.toLoginButton.layer.cornerRadius = 4
        self.toLoginButton.isEnabled = false
        self.nameTextFiled.addTarget(self, action: #selector(nameTextChange), for: .allEvents)
        self.passTextFiled.addTarget(self, action: #selector(passTextChange), for: .allEvents)
        stateChange()
        NotificationCenter.default.addObserver(self, selector: #selector(textViewEditChanged(sender:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    @objc func textViewEditChanged(sender:NSNotification) {
        if nameTextFiled.isEditing {
            let textVStr = nameTextFiled.text! as NSString
            if (textVStr.length >= 11) {
                let str = textVStr.substring(to: 11)
                nameTextFiled.text = str
            }
        }else{
            var maxLength = 6
            if currentState {
                maxLength = 20
            }
            let textVStr = passTextFiled.text! as NSString
            if (textVStr.length >= maxLength) {
                let str = textVStr.substring(to: maxLength)
                passTextFiled.text = str
            }
        }
    }
    
    @IBAction func toGetCode(_ sender: UIButton){
        if userName == nil || userName!.length == 0 {
            Toast(text: "请输入手机号").show()
            return
        }
        if isPhoneNumber(phoneNumber: userName!) {
            userProvider.requestResult(.getCode(userMobile: userName!), success: { [weak self](code) in
                Toast(text: "发送成功").show()
                self?.countDown_1()
            })
        }else{
            Toast(text: "请输入合法手机号码").show()
        }
    }
    
    var timeCount = 60
    
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
    
    @IBAction func toChangeState(_ sender: UIButton){
        stateChange()
    }
    
    @IBAction func forgetPass(_ sender: UIButton){
        let controller = ForgetPass1ViewController()
        controller.callback = { [weak self](phone) in
            self?.nameTextFiled.text = phone
            self?.userName = phone
        }
        self.pushVC(controller)
    }
    
    private let disposeBag = DisposeBag()
    
    @IBAction func toLogin(_ sender: UIButton){
        if userName == nil || userName!.count == 0 {
            Toast(text: "请输入手机号").show()
            return
        }
        if !isPhoneNumber(phoneNumber: userName!) {
            Toast(text: "请输入合法手机号码").show()
            return
        }
        if currentState {
            if userPass == nil || userPass!.count == 0 {
                Toast(text: "请输入密码").show()
                return
            }
            userProvider.rxRequest(.userLoginByPass(username: userName!, password: userPass!))
                .subscribe(onSuccess: {[weak self](json) in
                    self?.toMainView(json: json)
                }).disposed(by: disposeBag)
        }else{
            if userPass == nil || userPass!.count == 0 {
                Toast(text: "请输入验证码").show()
                return
            }
            if userPass!.count != 6{
                Toast(text: "请输入合法验证码").show()
                return
            }
            userProvider.rxRequest(.userLoginByCode(mobile: userName!, code: userPass!))
                .subscribe(onSuccess: {[weak self](json) in
                    self?.toMainView(json: json)
                }).disposed(by: disposeBag)
        }
    }
    
    private  func toMainView(json:JSON){
        let userModel = UserModel.init(fromJson: json["data"])
        UserModel.archiverUser(userModel)
        UserDefaults.standard.set(true, forKey: kIsLogin)
        let nav = PGBaseNavigationController.init(rootViewController: MainViewController())
        UIApplication.shared.keyWindow?.rootViewController = nav
    }
    
    func stateChange(){
        self.currentState = !self.currentState
        passTextFiled.text = nil
        if currentState {
            passTextFiled.isSecureTextEntry = true
            passTextFiled.keyboardType = UIKeyboardType.default
            passTextFiled.textContentType = .password
            toChangeStateButton.setTitle("使用验证码登录", for: .normal)
            passTextFiled.placeholder = "请输入密码"
            codeImage.image = UIImage(named: "login_icon_password")
        }else{
            passTextFiled.isSecureTextEntry = false
            passTextFiled.keyboardType = UIKeyboardType.numberPad
            passTextFiled.textContentType = .none
            toChangeStateButton.setTitle("使用密码登录", for: .normal)
            passTextFiled.placeholder = "请输入验证码"
            codeImage.image = UIImage(named: "login_icon_safe")
        }
        forgetPass.isHidden = !currentState
        getCodeView.isHidden = currentState
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
    
    @IBAction func showUserAragment(_ sender: UIButton){
        let webController = WebViewController()
        webController.titleStr = "平台使用协议及隐私条款"
        webController.url = Config.url_useAgreement
        self.pushVC(webController)
    }
    
}


// MARK: - 隐藏navigationBar
extension UserLoginViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if setupClass() {
            self.navigationController?.navigationBar.isHidden = true
        }else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if setupClass() {
            self.navigationController?.navigationBar.isHidden = true
        }else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupClass() ->Bool {
        let controller = self.currentViewController()
        if controller.isKind(of: WebViewController.self) ||
            controller.isKind(of: ForgetPass1ViewController.self) {
            return true
        }
        return false
    }
}
