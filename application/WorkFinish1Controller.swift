//
//  WorkFinish1Controller.swift
//  application
//
//  Created by sitech on 2020/7/17.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
import PGActionSheet
import RealmSwift
private let finishItemCell = "FinishItemCell"

class WorkFinish1Controller: PageingListViewController,UITableViewDelegate,UITableViewDataSource {
    
    var disposeBag = DisposeBag()
    var workModel:WorkModel!
    var callback:(()->())?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: finishItemCell) as! FinishItemCell
        cell.setData(self.workModel)
        cell.callback = {[weak self]in
            self?.view.toast("提交成功")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMessageNotifyKey), object: nil)
            self?.navigationController?.popViewController(animated: false)
            self?.callback?()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1200
    }
    
    override func viewDidLoad() {
        self.isRefresh = false
        self.isLoadMore = false
        super.viewDidLoad()
        self.title = "完成后资料上传"
        self.view.backgroundColor = ColorConstants.tableViewBackground
        self.view.backgroundColor = ColorConstants.tableViewBackground
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = ColorConstants.tableViewBackground
        self.tableView.sectionHeaderHeight = 0.01
        self.tableView.sectionFooterHeight = 0.01
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: finishItemCell, bundle: nil), forCellReuseIdentifier: finishItemCell)
        request()
    }
    
    override func request(){
        taskProviderNoPlugin.rxRequest(.getWorkDetail(taskId: self.workModel.taskId))
            .toModel(type: WorkModel.self)
            .subscribe(onSuccess: { [weak self](model) in
                self?.workModel = model
                self?.tableView.reloadData()
            }) { [weak self](_) in
                self?.view.toast("请求失败")
        }.disposed(by: self.disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! FinishItemCell
        if cell.dataRealm != nil {
            try! cell.realm.write {
                cell.dataRealm!.photoList = cell.picUrlList.joined(separator: ",")
                cell.dataRealm!.fileNameList = cell.fileList.joined(separator: ",")
                cell.dataRealm!.fileUrList = cell.fileUrlList.joined(separator: ",")
                cell.dataRealm!.note = cell.textInput.text
            }
        }
    }
    
}
