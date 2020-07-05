//
//  WorkDetailExt.swift
//  application
//
//  Created by Anson on 2020/7/5.
//  Copyright © 2020 Sitop. All rights reserved.
//

import Foundation

extension WorkDetailController {
    
    //    case  TASK_NODE_CONFIRMING = 1
    //    case  WORK_ROB = 2//抢单
    //    case  WORK_BEGIN = 3//待开始
    //    case  WORK_PROGRESS = 4//进行中
    //    case  WORK_CHECK = 5//待验收
    //    case  WORK_FINISH = 6//完成
    
    func getNumberOfSection()->Int{
        if self.workModel.taskState == WorkState.WORK_ROB.rawValue {
            return 6
        }else if self.workModel.taskState == WorkState.WORK_BEGIN.rawValue {
            return 6
        }else if self.workModel.taskState == WorkState.WORK_PROGRESS.rawValue {
            return 6
        }else if self.workModel.taskState == WorkState.WORK_CHECK.rawValue {
            return 6
        }else if self.workModel.taskState == WorkState.WORK_FINISH.rawValue {
            return 6
        }else{
            return 0
        }
    }
    
    func getNumberOfRowInSection(_ section:Int)->Int{
        if self.workModel.taskState == WorkState.WORK_ROB.rawValue {
            if section == 4 {
                return self.workModel.taskAttachmentList.count
            }
            return 1
        }else if self.workModel.taskState == WorkState.WORK_BEGIN.rawValue {
            return 6
        }else if self.workModel.taskState == WorkState.WORK_PROGRESS.rawValue {
            return 6
        }else if self.workModel.taskState == WorkState.WORK_CHECK.rawValue {
            return 6
        }else if self.workModel.taskState == WorkState.WORK_FINISH.rawValue {
            return 6
        }else{
            return 1
        }
    }
    
    override  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.workModel.taskState == WorkState.WORK_ROB.rawValue && section == 4 {
            return 44
        }
        return 12
    }
    
    override  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.workModel.taskState ==  WorkState.WORK_ROB.rawValue {
            if indexPath.section == 0 {
                return 80
            }else if indexPath.section == 2 {
                return 104
            }else if indexPath.section == 4 {
                return 40
            }else if indexPath.section == 5 {
                return 64
            }else{
                return UITableView.automaticDimension
            }
        }
        return 184
    }
    
    /**
     tableView的头部信息
     */
    override  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.workModel.taskState == WorkState.WORK_ROB.rawValue && section == 4 {
            let identifier = "taskAttachmentList_header"
            var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? HeaderWorkEnclosureView
            if view == nil {
                view = HeaderWorkEnclosureView(reuseIdentifier: identifier)
                let backgroundView = UIView()
                backgroundView.backgroundColor = UIColor.white
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
    
}
