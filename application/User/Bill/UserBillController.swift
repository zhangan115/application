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
        hiddenNaviBarLine()
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
        self.baseIastId = 1
    }
    
    var params:[String:Any] = [:]
    var requestTime : Int = 0
    var currentPage = 1
    let disposeBag = DisposeBag()
    
    override func refreshHandler() {
        self.currentPage = 1
        super.refreshHandler()
    }
    
    override func loadMoreHandler() {
        super.refreshHandler()
        self.currentPage = self.currentPage + 1
    }
    
    override func request() {
        if self.currentPage == 1 {
            requestTime = Date().timeIntervalSince1970.toInt * 1000
        }
        params["endTime"] = requestTime
        userProviderNoPlugin.rxRequest(.accountLogList(params: params))
            .toModel(type: AccountLogList.self).subscribe(onSuccess: {[weak self](model) in
                self?.requestSuccess(model: model)
            }) { [weak self] _ in
                self?.requestError()
        }.disposed(by: disposeBag)
    }
    
    private var headerList:[UserBillHeader] = []
    
    private func dealData(billList : [BillList]){
        for item in billList {
            let time = dateString(millisecond: TimeInterval(item.billTime), dateFormat: "yyyy年MM月")
            var billHeader : UserBillHeader? = nil
            for header in headerList {
                if  header.headerTime == time {
                    billHeader = header
                    break
                }
            }
            if billHeader == nil {
                billHeader = UserBillHeader()
                headerList.append(billHeader!)
                billHeader!.headerTime = time
            }
            if  let value = item.billAmount.toFloat(){
                if (value < 0){
                    billHeader!.billOut = billHeader!.billOut + value
                }else{
                    billHeader!.billIn = billHeader!.billIn + value
                }
            }
            billHeader!.list.append(item)
        }
    }
    
    private func requestSuccess(model:AccountLogList?){
        if let model = model {
            if self.currentPage == 1 {
                self.tableView.mj_header?.endRefreshing()
                self.headerList.removeAll()
                self.dealData(billList: model.list)
                self.tableView.safeReloadData()
            }else{
                self.tableView.mj_footer?.endRefreshing()
                self.dealData(billList: model.list)
                self.tableView.safeReloadData()
            }
        }else{
            if self.currentPage == 1 {
                self.tableView.mj_header?.endRefreshing()
                self.headerList.removeAll()
                self.tableView.mj_header?.endRefreshing()
            }else{
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
        }
        self.tableView.safeReloadData()
    }
    
    private func requestError(){
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCell) as! UserBillViewCell
        let model = self.headerList[indexPath.section]
        let data = model.list[indexPath.row]
        cell.label1.text = data.billName
        if (data.billAmount.toFloat()!<0){
            cell.label2.text = "-"+data.billAmount
            cell.label2.textColor = UIColor(hexString: "#454545")
        }else{
            cell.label2.text = "+"+data.billAmount
            cell.label2.textColor = UIColor(hexString: "#FFCC00")
        }
        cell.label3.text = dateString(millisecond: TimeInterval.init(data.billTime)
            ,dateFormat: "MM月dd日 HH:mm")
        cell.label4.text =  "余额:"+data.billOverage
        return cell
    }
    
}

extension UserBillController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return headerList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headerList[section].list.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let identifier = "header"
        var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? UserBillHeaderView
        let data = headerList[section]
        if view == nil {
            view = UserBillHeaderView(reuseIdentifier: identifier)
            let backgroundView = UIView()
            backgroundView.backgroundColor = ColorConstants.tableViewBackground
            view?.backgroundView = backgroundView
        }
        let str =  String(format: "收入 ￥ %0.2f  提现 ￥%0.2f", data.billIn,data.billOut)
        view?.timeButton.setTitle(data.headerTime, for: .normal)
        view?.moneyLabel.text = str
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
