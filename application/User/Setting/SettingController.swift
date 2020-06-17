//
//  SettingController.swift
//  application
//
//  Created by sitech on 2020/6/17.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift

private let itemCell = "HelpItemTableViewCell"
private let settingViewCell = "SettingViewCell"
private let settingExitCell = "SettingExitCell"
class SettingController: HomeTableController {
    
    var titleList:[String] = ["设置登录密码","清理缓存","关于我们","平台使用协议及隐私条款"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        isCanFinish = true
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = ColorConstants.tableViewBackground
        self.tableView.sectionHeaderHeight = 0.01
        self.tableView.sectionFooterHeight = 0.01
        self.tableView.register(UINib(nibName: itemCell, bundle: nil), forCellReuseIdentifier: itemCell)
        self.tableView.register(UINib(nibName: settingViewCell, bundle: nil), forCellReuseIdentifier: settingViewCell)
        self.tableView.register(UINib(nibName: settingExitCell, bundle: nil), forCellReuseIdentifier: settingExitCell)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: settingViewCell) as! SettingViewCell
            return cell
        }
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: settingExitCell) as! SettingExitCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCell) as! HelpItemTableViewCell
        if indexPath.section > titleList.count {
            return cell
        }
        if indexPath.section == 1 {
            cell.contentLable.isHidden = false
            cell.contentLable.text = "3M"
        }else{
            cell.contentLable.isHidden = true
        }
        cell.titleLable.text = titleList[indexPath.section]
        return cell
    }
    
    let disposed = DisposeBag()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            let webController = WebViewController()
            webController.titleStr = "平台使用协议及隐私条款"
            webController.url = Config.url_useAgreement
            self.pushVC(webController)
        }
        if indexPath.section == 4 {
            let alertController = UIAlertController(title: "是否退出当前账号?", message:"", preferredStyle: .actionSheet)
            let noAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let sureAction = UIAlertAction(title: "确定", style: .default, handler: {(_)->Void in
                userProvider.rxRequest(.logout).subscribe().disposed(by: self.disposed)
                UserDefaults.standard.set(false, forKey: kIsLogin)
                UIApplication.shared.keyWindow?.rootViewController = PGBaseNavigationController(rootViewController: UserLoginViewController())
            })
            alertController.addAction(noAction)
            alertController.addAction(sureAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension SettingController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
        if section == 3 {
            return 0
        }
        if section == 4 {
            return 180
        }
        return 12
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
