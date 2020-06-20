//
//  UserDataController.swift
//  application
//
//  Created by sitech on 2020/6/18.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
import PGActionSheet
import Toaster
private let userDataInputCell = "UserDataInputCell"
private let userDataChooseCell = "UserDataChooseCell"
private let userDataSureCell = "UserDataSureCell"
class UserDataController: HomeTableController {
    
    var titleList:[String] = ["姓名","手机号码","工作年限","常在区域","联系人","手机号码"]
    var contentList:[String] = ["","","","","",""]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人资料"
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = ColorConstants.tableViewBackground
        self.tableView.sectionHeaderHeight = 0.01
        self.tableView.sectionFooterHeight = 0.01
        self.tableView.register(UINib(nibName: userDataInputCell, bundle: nil), forCellReuseIdentifier: userDataInputCell)
        self.tableView.register(UINib(nibName: userDataChooseCell, bundle: nil), forCellReuseIdentifier: userDataChooseCell)
        self.tableView.register(UINib(nibName: userDataSureCell, bundle: nil), forCellReuseIdentifier: userDataSureCell)
        let userModel = UserModel.unarchiver()!
        if userModel.realName != nil && userModel.realName.count > 0 {
            contentList[0] = userModel.realName
        }
        if  userModel.userMobile != nil && userModel.userMobile.count > 0{
            contentList[1] = userModel.userMobile
        }
        if userModel.workYear != nil && userModel.workYear.count > 0 {
            contentList[2] = userModel.workYear
        }
        if userModel.userAddress != nil && userModel.userAddress.count > 0 {
            contentList[3] = userModel.userAddress
        }else{
            if let address = UserDefaults.standard.string(forKey: kUserLocation){
                contentList[3] = address
            }
        }
        if  userModel.linkMan != nil && userModel.linkMan.count > 0 {
            contentList[4] = userModel.linkMan
        }
        if userModel.linkManMobile != nil && userModel.linkManMobile.count > 0 {
            contentList[5] = userModel.linkManMobile
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 || indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: userDataChooseCell) as! UserDataChooseCell
            cell.titleLabel.text = self.titleList[indexPath.section]
            if self.contentList[indexPath.section].count == 0 {
                cell.contentLable.text = "请选择"
                cell.contentLable.textColor = UIColor(hexString: "#BBBBBB")
            }else{
                cell.contentLable.text = self.contentList[indexPath.section]
                cell.contentLable.textColor = UIColor(hexString: "#333333")
            }
            return cell
        }
        if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: userDataSureCell) as! UserDataSureCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: userDataInputCell) as! UserDataInputCell
        cell.titleLabel.text = self.titleList[indexPath.section]
        cell.contentLable.isEnabled = indexPath.section !=  1
        if self.contentList[indexPath.section].count == 0 {
            cell.contentLable.text = nil
            cell.contentLable.placeholder = "请输入"
        }else{
            cell.contentLable.text = self.contentList[indexPath.section]
        }
        return cell
    }
    
    let yearList = ["1年以下", "1-3年","3-5年","5-10年","10年以上"]
    let disposeBag = DisposeBag()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 6 {
            let user = UserModel.unarchiver()!
            let cell1 = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! UserDataInputCell
            contentList[0] = cell1.contentLable.text ?? ""
            let cell2 = tableView.cellForRow(at: IndexPath.init(row: 0, section: 4)) as! UserDataInputCell
            contentList[4] = cell2.contentLable.text ?? ""
            let cell3 = tableView.cellForRow(at: IndexPath.init(row: 0, section: 5)) as! UserDataInputCell
            contentList[5] = cell3.contentLable.text ?? ""
            var params :[String:Any] = [:]
            params["userId"] = UserModel.unarchiver()!.userId!
            if contentList[0].count != 0 {
                params["realName"] = contentList[0]
                user.realName = contentList[0]
            }
            if contentList[2].count != 0 {
                user.workYear = contentList[2]
                params["workYear"] = contentList[2]
            }
            if contentList[3].count != 0 {
                user.userAddress = contentList[3]
                params["userAddress"] = contentList[3]
            }
            if contentList[4].count != 0 {
                user.linkMan = contentList[4]
                params["linkMan"] = contentList[4]
            }
            if contentList[5].count != 0 {
                if !isPhoneNumber(phoneNumber: contentList[5]) {
                    Toast(text: "请输入合法的手机号码").show()
                    return
                }
                user.linkManMobile = contentList[5]
                params["linkManMobile"] = contentList[5]
            }
            userProvider.rxRequest(.editUser(params: params))
                .subscribe(onSuccess: { [weak self](json) in
                    UserModel.archiverUser(user)
                    self?.view.showHUD("保存成功", completion: {
                        self?.pop()
                    })
                }) { (_) in}.disposed(by: disposeBag)
        }
        if indexPath.section == 2{
            let actionSheet =  PGActionSheet(buttonList:yearList)
            actionSheet.actionSheetTranslucent = false
            self.currentViewController().present(actionSheet, animated: false, completion: nil)
            actionSheet.handler = {index in
                self.contentList[2] = self.yearList[index]
                self.tableView.reloadData()
            }
        }
        if indexPath.section == 3{
            
        }
    }
    
}

extension UserDataController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 4 {
            let identifier = "userDataHeader"
            var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
            if view == nil {
                view = UserDataHeaderView(reuseIdentifier: identifier)
                let backgroundView = UIView()
                backgroundView.backgroundColor = ColorConstants.tableViewBackground
                view?.backgroundView = backgroundView
            }
            return view
        }
        let identifier = "header"
        var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
        if view == nil {
            view = UITableViewHeaderFooterView(reuseIdentifier: identifier)
            let backgroundView = UIView()
            backgroundView.backgroundColor = ColorConstants.tableViewBackground
            view?.backgroundView = backgroundView
        }
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 16
        }
        if section == 6 {
            return 125
        }
        if section == 4 {
            return 44
        }
        return 12
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
