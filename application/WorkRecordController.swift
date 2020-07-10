//
//  WorkRecordController.swift
//  application
//
//  Created by sitech on 2020/7/10.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
private var workRecordCell = "WorkRecordCell"

class WorkRecordController: BaseTableViewController {
    
    var workModel:WorkModel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.isLoadMore = false
        self.isRefresh = false
        super.viewDidLoad()
        self.title = "审核记录"
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = ColorConstants.tableViewBackground
        self.tableView.sectionHeaderHeight = 0.01
        self.tableView.sectionFooterHeight = 0.01
        self.tableView.register(UINib(nibName: workRecordCell, bundle: nil), forCellReuseIdentifier: workRecordCell)
        request()
    }
    
    override func request() {
        taskProvider.rxRequest(.getTaskVerifyLog(taskId: self.workModel.taskId))
            .toListModel(type: TaskVerifyModel.self)
            .subscribe(onSuccess: {[weak self](list) in
                self?.requestSuccessMonitor(list: list)
            }) { [weak self] _ in
                self?.requestSuccessMonitor(list: [])
        }.disposed(by: self.disposeBag)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.responseDataList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: workRecordCell) as! WorkRecordCell
        let model : TaskVerifyModel = self.responseDataList[indexPath.row] as! TaskVerifyModel
        if indexPath.row == 0 {
            cell.centerView.backgroundColor = UIColor(hexString: "#FF221C")
            cell.topView.alpha = 0
            cell.bottomView.alpha = 1
        }else if indexPath.row == self.responseDataList.count - 1 {
            cell.centerView.backgroundColor = UIColor(hexString: "#CCCCCC")
            cell.topView.alpha = 1
            cell.bottomView.alpha = 0
        }else{
            cell.centerView.backgroundColor = UIColor(hexString: "#CCCCCC")
            cell.topView.alpha = 1
            cell.bottomView.alpha = 1
        }
        cell.setModel(model: model)
        return cell
    }
    
}
