//
//  WorkListController.swift
//  application
//
//  Created by sitech on 2020/6/22.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkListController: PageingListViewController {
    
    var currentIndex = 3
    var currentLocation : CLLocation? = nil
    
    lazy var workVerifyView : WorkVerifyView = {
        return WorkVerifyView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenNaviBarLine()
        showUserVerify()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = ColorConstants.tableViewBackground
        self.tableView.sectionHeaderHeight = 0.01
        self.tableView.sectionFooterHeight = 0.01
        self.tableView.safeReloadData()
    }
    
}

extension WorkListController {
    
}

extension WorkListController {
    
    func showUserVerify(){
        if let userModel = UserModel.unarchiver() {
            if userModel.certificationType! == 0 {
                self.view.addSubview(workVerifyView)
                workVerifyView.snp.updateConstraints { (make) in
                    make.left.right.equalToSuperview()
                    make.top.equalToSuperview().offset(170)
                    make.bottom.greaterThanOrEqualToSuperview().offset(50)
                }
            }
        }
    }
}
