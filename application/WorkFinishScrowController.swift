//
  WorkFinishScrowController.swift
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
class WorkFinishScrowController: BaseTableViewController {
    
    @IBOutlet var contentView:UIView!
    
    var workModel:WorkModel!
    var disposeBag = DisposeBag()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "完成后资料上传"
        self.view.backgroundColor = ColorConstants.tableViewBackground
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = ColorConstants.tableViewBackground
        self.tableView.sectionHeaderHeight = 0.01
       self.tableView.sectionFooterHeight = 0.01
       self.tableView.register(UINib(nibName: finishItemCell, bundle: nil), forCellReuseIdentifier: finishItemCell)
        self.request()
    }
    
    private func request(){
        taskProviderNoPlugin.rxRequest(.getWorkDetail(taskId: self.workModel.taskId))
            .toModel(type: WorkModel.self)
            .subscribe(onSuccess: { [weak self](model) in
                self?.workModel = model
                
            }) { [weak self](_) in
                self?.view.toast("请求失败")
        }.disposed(by: self.disposeBag)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
        
//        if self.dataRealm != nil {
//            try! realm.write {
//                self.dataRealm!.photoList = self.picUrlList.joined(separator: ",")
//                self.dataRealm!.fileNameList = self.fileList.joined(separator: ",")
//                self.dataRealm!.fileUrList = self.fileUrlList.joined(separator: ",")
//                self.dataRealm!.note = self.textInput.text
//            }
//        }
//    }
    
}
