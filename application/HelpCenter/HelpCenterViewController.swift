//
//  HelpCenterViewController.swift
//  application
//
//  Created by sitech on 2020/6/16.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
private let itemCell = "HelpItemTableViewCell"

class HelpCenterViewController: HomeTableController {
    
    var titleList:[String] = []
    var urlList:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showBackButton = true
        isPresent = true
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = ColorConstants.tableViewBackground
        self.tableView.sectionHeaderHeight = 0.01
        self.tableView.sectionFooterHeight = 0.01
        self.tableView.register(UINib(nibName: itemCell, bundle: nil), forCellReuseIdentifier: itemCell)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCell) as! HelpItemTableViewCell
        if indexPath.section > titleList.count {
            return cell
        }
        cell.titleLable.text = titleList[indexPath.section]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > titleList.count {
            return
        }
        if indexPath.section > urlList.count {
            return
        }
        let webController = WebViewController()
        webController.titleStr = titleList[indexPath.section]
        webController.url = urlList[indexPath.section]
        self.pushVC(webController)
    }
    
}

extension HelpCenterViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
}
