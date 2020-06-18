//
//  UserBillController.swift
//  application
//
//  Created by sitech on 2020/6/18.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import MJRefresh
import RxSwift

private let itemCell = "UserBillViewCell"

class UserBillController: BaseTableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "账单"
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = ColorConstants.tableViewBackground
        self.tableView.sectionHeaderHeight = 0.01
        self.tableView.sectionFooterHeight = 0.01
        self.tableView.register(UINib(nibName: itemCell, bundle: nil), forCellReuseIdentifier: itemCell)
        let userModel = UserModel.unarchiver()!
        params["userId"] = userModel.userId
        params["page"] = self.pagingCount
    }
    
    var params:[String:Any] = [:]
    var requestTime : Int = 0
    let disposeBag = DisposeBag()
    
    override func refreshHandler() {
        super.refreshHandler()
        self.baseIastId = 1
    }
    
    override func loadMoreHandler() {
        super.refreshHandler()
        self.baseIastId = self.baseIastId + 1
    }
    
    override func request() {
        if self.baseIastId == 1 {
            requestTime = Date().timeIntervalSince1970.toInt * 1000
        }
        params["endTime"] = requestTime
        params["page"] = self.pagingCount
        userProviderNoPlugin.rxRequest(.accountLogList(params: params))
            .toModel(type: AccountLogList.self).subscribe(onSuccess: {[weak self](model) in
                 self?.requestSuccess(model: model)
            }) { [weak self] _ in
                self?.requestError()
        }.disposed(by: disposeBag)
    }
    
    private func requestSuccess(model:AccountLogList?){
        if let model = model {
            
        }else{
            
        }
    }
    
    private func requestError(){
        self.requestSuccessMonitor(list: nil)
    }
    
}


extension UserBillController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return responseDataList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let identifier = "header"
        var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
        if view == nil {
            view = UserBillHeaderView(reuseIdentifier: identifier)
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
