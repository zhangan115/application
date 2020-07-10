//
//  WorkMoreController.swift
//  application
//
//  Created by sitech on 2020/7/10.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
private var workMoreItemCell = "WorkMoreItemCell"
class WorkMoreController: BaseTableViewController {
    
    var workModel:WorkModel!
    var titleList:[String] = ["处理方法","人工客服","工单终止"]
    var iconList:[String] = ["more_icon_way","more_icon_service","more_icon_abrogation"]
    
    override func viewDidLoad() {
        self.isLoadMore = false
        self.isRefresh = false
        super.viewDidLoad()
        self.title = "更多操作"
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = ColorConstants.tableViewBackground
        self.tableView.sectionHeaderHeight = 0.01
        self.tableView.sectionFooterHeight = 0.01
        self.tableView.register(UINib(nibName: workMoreItemCell, bundle: nil), forCellReuseIdentifier: workMoreItemCell)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
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
        return 12
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: workMoreItemCell) as! WorkMoreItemCell
        cell.icon.image = UIImage(named: iconList[indexPath.section])
        cell.label.text = titleList[indexPath.section]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let controller = WorkMethodController()
            self.pushVC(controller)
        }else if indexPath.section == 1{
            let alertController = UIAlertController(title: kServicePhone, message:"是否拨打电话?", preferredStyle: .alert)
            let noAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let sureAction = UIAlertAction(title: "拨打", style: .default, handler: {(_)->Void in
                callPhoneTelpro(phone: kServicePhone)
            })
            alertController.addAction(noAction)
            alertController.addAction(sureAction)
            self.currentViewController().present(alertController, animated: true, completion: nil)
        }else{
            let controller = WorkEndController()
            controller.workModel = self.workModel
            self.pushVC(controller)
        }
    }
}
