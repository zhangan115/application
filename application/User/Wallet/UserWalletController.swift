//
//  UserWalletController.swift
//  application
//
//  Created by sitech on 2020/6/18.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
class UserWalletController: PGBaseViewController {
    
    @IBOutlet weak var userMoney:UILabel!
    @IBOutlet weak var userTextBottom:UILabel!
    @IBOutlet weak var userVerify:UIView!
    @IBOutlet weak var userVerifyBg:UIView!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenNaviBarLine()
        self.title = "钱包"
        self.view.backgroundColor = ColorConstants.tableViewBackground
        setupRightButton()
        let user = UserModel.unarchiver()!
        if user.certificationType! > 0 {
            userVerify.isHidden = true
        }
        userProviderNoPlugin.rxRequest(.accountGet(userId: UserModel.unarchiver()!.userId))
            .toModel(type: Account.self)
            .subscribe(onSuccess: { [weak self](model) in
                self?.userMoney.text = "￥"  + model.accountAmount
                if let value = model.accountAmount.toFloat(){
                    self?.userTextBottom.isHidden = value == 0
                }
            }) { (error) in
                
        }.disposed(by: disposeBag)
    }
    
    @IBAction func toUserIndetify(_ sender: UIButton){
        let controller = UserIdentityController()
        self.pushVC(controller)
    }
    
    func setupRightButton() {
        let button = UIButton(type: .custom)
        button.setTitle("账单", for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 15)
        button.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(rightHandler), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc func rightHandler() {
        let controller = UserBillController()
        self.pushVC(controller)
    }
}
