//
//  WorkDetailExt.swift
//  application
//
//  Created by Anson on 2020/7/5.
//  Copyright © 2020 Sitop. All rights reserved.
//

import Foundation
import PGDatePicker
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
            return 8
        }else if self.workModel.taskState == WorkState.WORK_PROGRESS.rawValue {
            if stopState > StopState.Normal.rawValue || self.workModel.hasEverSubmitted {
                return 9
            }
            return 8
        }else if self.workModel.taskState == WorkState.WORK_CHECK.rawValue {
            return 9
        }else if self.workModel.taskState == WorkState.WORK_FINISH.rawValue {
            return 9
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
            if stopState > StopState.Normal.rawValue {
                if section == 7 {
                    return self.workModel.taskAttachmentList.count
                }
            }
            if stopState == StopState.Normal.rawValue  && section == 6 {
                return self.workModel.taskAttachmentList.count
            }
            return 1
        }else if self.workModel.taskState == WorkState.WORK_PROGRESS.rawValue {
            if stopState > StopState.Normal.rawValue && section == 8{
                return self.workModel.taskAttachmentList.count
            }
            if stopState == StopState.Normal.rawValue && self.workModel.hasEverSubmitted && section == 8 {
                return self.workModel.taskAttachmentList.count
            }
            if stopState == StopState.Normal.rawValue && !self.workModel.hasEverSubmitted && section == 7 {
                return self.workModel.taskAttachmentList.count
            }
            if section == 2 {
                if !self.workModel.hasEverSubmitted && stopState == StopState.Normal.rawValue  {
                    return 3
                }
                return 1
            }
            if section == 3 {
                if self.workModel.hasEverSubmitted && stopState == StopState.Normal.rawValue {
                    return 3
                }
                return 1
            }
            return 1
        }else if self.workModel.taskState == WorkState.WORK_CHECK.rawValue {
            if section == 8 {
                return self.workModel.taskAttachmentList.count
            }
            if section == 3 {
                if self.workModel.taskType == WorkType.WORK_TYPE_ROUT.rawValue {
                    return 3
                }
                return 2
            }
            return 1
        }else if self.workModel.taskState == WorkState.WORK_FINISH.rawValue {
            if section == 8 {
                return self.workModel.taskAttachmentList.count
            }
            if section == 3 {
                if self.workModel.taskType == WorkType.WORK_TYPE_ROUT.rawValue {
                    return 3
                }else{
                    return 2
                }
            }
            return 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        if stopState > StopState.Normal.rawValue && self.workModel.taskState == WorkState.WORK_BEGIN.rawValue && section == 7 {
            return 58
        }
        if self.workModel.taskState == WorkState.WORK_ROB.rawValue && section == 4
            || self.stopState == StopState.Normal.rawValue && self.workModel.taskState == WorkState.WORK_BEGIN.rawValue && section == 6
            || self.workModel.taskState == WorkState.WORK_CHECK.rawValue && section == 8
            || self.workModel.taskState == WorkState.WORK_FINISH.rawValue && section == 8{
            return 58
        }
        if self.workModel.taskState == WorkState.WORK_PROGRESS.rawValue {
            if stopState > StopState.Normal.rawValue {
                if section == 8 {
                    return 58
                }else {
                    return 12
                }
            }
            if workModel.hasEverSubmitted && section == 8  {
                return 58
            }else if !workModel.hasEverSubmitted && section == 7{
                return 58
            }
        }
        return 12
    }
    
    /**
     tableView的头部信息
     */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.workModel.taskState == WorkState.WORK_ROB.rawValue && section == 4
            || self.stopState == StopState.Normal.rawValue && self.workModel.taskState == WorkState.WORK_BEGIN.rawValue && section == 6
            || self.stopState == StopState.Normal.rawValue && self.workModel.taskState == WorkState.WORK_PROGRESS.rawValue && !self.workModel.hasEverSubmitted && section == 7
            || self.stopState > StopState.Normal.rawValue && self.workModel.taskState == WorkState.WORK_PROGRESS.rawValue && section == 8
            || self.workModel.taskState == WorkState.WORK_CHECK.rawValue && section == 8
            || self.workModel.taskState == WorkState.WORK_FINISH.rawValue && section == 8
            || self.workModel.hasEverSubmitted && self.workModel.taskState == WorkState.WORK_PROGRESS.rawValue && section == 8
            || self.stopState > StopState.Normal.rawValue && self.workModel.taskState == WorkState.WORK_BEGIN.rawValue && section == 7 {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
        }else if self.workModel.taskState ==  WorkState.WORK_BEGIN.rawValue {
            if self.stopState > StopState.Normal.rawValue {
                if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 {
                    return 80
                }else if indexPath.section == 3 {
                    if self.stopState == StopState.Stop.rawValue {
                        return 104
                    }else {
                        return 80
                    }
                }else if indexPath.section == 5 {
                    return 104
                }else if indexPath.section == 7 {
                    return 40
                }else{
                    return UITableView.automaticDimension
                }
            }
            if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 {
                return 80
            }else if indexPath.section == 4 {
                return 104
            }else if indexPath.section == 6 {
                return 40
            }else if indexPath.section == 7 {
                return 64
            }else{
                return UITableView.automaticDimension
            }
        }else if self.workModel.taskState == WorkState.WORK_PROGRESS.rawValue {
            if self.stopState > StopState.Normal.rawValue {
                if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2  {
                    return 80
                }else if indexPath.section == 4 {
                    if self.stopState == StopState.Stop.rawValue {
                        return 104
                    }else {
                        return 80
                    }
                } else if indexPath.section == 6 {
                    return 104
                }else if indexPath.section == 8 {
                    return 40
                }else{
                    return UITableView.automaticDimension
                }
            }
            if self.workModel.hasEverSubmitted {
                if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 4 {
                    return 80
                }else if indexPath.section == 6 {
                    return 104
                }else if indexPath.section == 8 {
                    return 40
                }else{
                    return UITableView.automaticDimension
                }
            }
            if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 3 {
                return 80
            }else if indexPath.section == 5 {
                return 104
            }else if indexPath.section == 7 {
                return 40
            }else{
                return UITableView.automaticDimension
            }
        }else if self.workModel.taskState == WorkState.WORK_CHECK.rawValue {
            if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 {
                return 80
            }else if indexPath.section == 4 {
                if self.stopState == StopState.Stop.rawValue {
                    return 104
                }else {
                    return 80
                }
            }else if indexPath.section == 6 {
                return 104
            }else if indexPath.section == 8 {
                return 40
            }else{
                return UITableView.automaticDimension
            }
        }else if self.workModel.taskState == WorkState.WORK_FINISH.rawValue {
            if indexPath.section == 0 || indexPath.section == 1  {
                return 80
            }else if indexPath.section == 2 {
                return 106
            }else if indexPath.section == 4 || indexPath.section == 6 {
                return 104
            }else if indexPath.section == 8 {
                return 40
            }else{
                return UITableView.automaticDimension
            }
        }
        return 184
    }
    
    // 获取抢单信息
    func getRobCell(indexPath:IndexPath)->UITableViewCell{
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workCostCell) as! WorkCostCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workInfoCell) as! WorkInfoCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: customerInfoCell) as! CustomerInfoCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workRemarksCell) as! WorkRemarksCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workEnclosureCell) as! WorkEnclosureCell
            cell.setModel(model: self.workModel.taskAttachmentList[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: workButtonCell) as! WorkButtonCell
            cell.setModel(model: self.workModel)
            cell.callBack = {(time)in
                if time == nil {
                    let currentTime = Date().timeIntervalSince1970.toInt * 1000
                    let todayStrTime = dateString(millisecond: TimeInterval(currentTime), dateFormat: "yyyy-MM-dd 00:00:00")
                    let todayTime = date2TimeStamp(time: todayStrTime, dateFormat: "yyyy-MM-dd 00:00:00").toInt
                    print(todayTime)
                    self.robWork(time: todayTime)
                }else {
                    self.showTimeDailog(time: time!)
                }
            }
            return cell
        }
    }
    
    //待开始
    func getBeginCell(indexPath:IndexPath)->UITableViewCell{
        if stopState != StopState.Normal.rawValue {
            return getBeginStopCell(indexPath: indexPath)
        }
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workTitleCell) as! WorkTitleCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workTimeCell) as! WorkTimeCell
            cell.callBack = {(time)in
                taskProvider.rxRequest(.taskUpdateTime(taskId:self.workModel.taskId, planArriveTime: time))
                    .subscribe(onSuccess: {[weak self] (model) in
                        if self == nil{
                            return
                        }
                        self?.view.toast("更新时间成功")
                        self?.request()
                    }) {[weak self] _ in
                        self?.tableView.noRefreshReloadData()
                }.disposed(by: self.disposeBag)
            }
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workCostCell) as! WorkCostCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workInfoCell) as! WorkInfoCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: customerInfoCell) as! CustomerInfoCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workRemarksCell) as! WorkRemarksCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workEnclosureCell) as! WorkEnclosureCell
            cell.setModel(model: self.workModel.taskAttachmentList[indexPath.row])
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: workButtonCell) as! WorkButtonCell
            cell.setModel(model: self.workModel)
            cell.button.setTitle("到达现场上传作业前照片", for: .normal)
            cell.callBack = {(time)in
                let controller = WorkBeginController()
                controller.workModel = self.workModel
                self.pushVC(controller)
            }
            return cell
        }
    }
    
    //进行中
    func getProgressCell(indexPath:IndexPath)->UITableViewCell{
        if stopState != StopState.Normal.rawValue {
            return getProgressStopCell(indexPath: indexPath)
        }
        if self.workModel.hasEverSubmitted {
            return getProgressHasEverSubmittedCell(indexPath: indexPath)
        }
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workTitleCell) as! WorkTitleCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workTimeCell) as! WorkTimeCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: workProgressItemCell) as! WorkProgressItemCell
                cell.setModel(workModel: self.workModel)
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: workProgressAfterCell) as! WorkProgressAfterCell
                cell.fileList = self.fileList
                cell.fileUrlList = self.fileUrlList
                cell.addFileCallBack = {(url)in
                    let saveName = url.split("/").last ?? ""
                    self.fileList.append(saveName)
                    self.fileUrlList.append(url)
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
                cell.updateCallBack = {
                    self.request()
                }
                cell.delectFileCallBack = {(index)in
                    self.fileList.remove(at: index)
                    self.fileUrlList.remove(at: index)
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
                cell.setModel(workModel: self.workModel)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: workProgressButtomCell) as! WorkProgressButtomCell
                cell.setModel(workModel: self.workModel)
                cell.subCallBack = {
                    self.subData()
                }
                return cell
            }
        }else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workCostCell) as! WorkCostCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workInfoCell) as! WorkInfoCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: customerInfoCell) as! CustomerInfoCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workRemarksCell) as! WorkRemarksCell
            cell.setModel(model: self.workModel)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: workEnclosureCell) as! WorkEnclosureCell
            cell.setModel(model: self.workModel.taskAttachmentList[indexPath.row])
            return cell
        }
    }
    //检验中
    func getCheckCell(indexPath:IndexPath)->UITableViewCell{
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workTitleCell) as! WorkTitleCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 1 {
            if self.stopState > StopState.Normal.rawValue {
                let cell = tableView.dequeueReusableCell(withIdentifier: workEndCell) as! WorkEndCell
                cell.setModel(model: self.workModel)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: workInspectCell) as! WorkInspectCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workTimeCell) as! WorkTimeCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 3 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: workProgressItemCell) as! WorkProgressItemCell
                cell.setModel(workModel: self.workModel)
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: workProgressAfterCell) as! WorkProgressAfterCell
                cell.fileList = self.fileList
                cell.fileUrlList = self.fileUrlList
                cell.setModel(workModel: self.workModel)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: workProgressButtomCell) as! WorkProgressButtomCell
                cell.setModel(workModel: self.workModel)
                return cell
            }
        }else if indexPath.section == 4 {
            if stopState == StopState.Stop.rawValue {
                let cell = tableView.dequeueReusableCell(withIdentifier: workCostDetailCell) as! WorkCostDetailCell
                cell.setModel(model: self.workModel)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: workCostCell) as! WorkCostCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workInfoCell) as! WorkInfoCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: customerInfoCell) as! CustomerInfoCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workRemarksCell) as! WorkRemarksCell
            cell.setModel(model: self.workModel)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: workEnclosureCell) as! WorkEnclosureCell
            cell.setModel(model: self.workModel.taskAttachmentList[indexPath.row])
            return cell
        }
    }
    
    //已完成
    func getFinishCell(indexPath:IndexPath)->UITableViewCell{
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workTitleCell) as! WorkTitleCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workInspectCell) as! WorkInspectCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workFinishTimeCell) as! WorkFinishTimeCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 3 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: workProgressItemCell) as! WorkProgressItemCell
                cell.setModel(workModel: self.workModel)
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: workProgressAfterCell) as! WorkProgressAfterCell
                cell.fileList = self.fileList
                cell.fileUrlList = self.fileUrlList
                cell.setModel(workModel: self.workModel)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: workProgressButtomCell) as! WorkProgressButtomCell
                cell.setModel(workModel: self.workModel)
                return cell
            }
        }else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workCostDetailCell) as! WorkCostDetailCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workInfoCell) as! WorkInfoCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: customerInfoCell) as! CustomerInfoCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workRemarksCell) as! WorkRemarksCell
            cell.setModel(model: self.workModel)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: workEnclosureCell) as! WorkEnclosureCell
            cell.setModel(model: self.workModel.taskAttachmentList[indexPath.row])
            return cell
        }
    }
    
    func getProgressHasEverSubmittedCell(indexPath:IndexPath)->UITableViewCell{
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workTitleCell) as! WorkTitleCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workInspectCell) as! WorkInspectCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workTimeCell) as! WorkTimeCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 3 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: workProgressItemCell) as! WorkProgressItemCell
                cell.setModel(workModel: self.workModel)
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: workProgressAfterCell) as! WorkProgressAfterCell
                cell.fileList = self.fileList
                cell.fileUrlList = self.fileUrlList
                cell.addFileCallBack = {(url)in
                    let saveName = url.split("/").last ?? ""
                    self.fileList.append(saveName)
                    self.fileUrlList.append(url)
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
                cell.updateCallBack = {
                    self.request()
                }
                cell.delectFileCallBack = {(index)in
                    self.fileList.remove(at: index)
                    self.fileUrlList.remove(at: index)
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
                cell.setModel(workModel: self.workModel)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: workProgressButtomCell) as! WorkProgressButtomCell
                cell.setModel(workModel: self.workModel)
                cell.subCallBack = {
                    self.subData()
                }
                return cell
            }
        }else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workCostCell) as! WorkCostCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workInfoCell) as! WorkInfoCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: customerInfoCell) as! CustomerInfoCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workRemarksCell) as! WorkRemarksCell
            cell.setModel(model: self.workModel)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: workEnclosureCell) as! WorkEnclosureCell
            cell.setModel(model: self.workModel.taskAttachmentList[indexPath.row])
            return cell
        }
    }
    
    func getProgressStopCell(indexPath:IndexPath)->UITableViewCell{
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workTitleCell) as! WorkTitleCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workEndCell) as! WorkEndCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workTimeCell) as! WorkTimeCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 3 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: workProgressItemCell) as! WorkProgressItemCell
                cell.setModel(workModel: self.workModel)
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: workProgressAfterCell) as! WorkProgressAfterCell
                cell.fileList = self.fileList
                cell.fileUrlList = self.fileUrlList
                cell.setModel(workModel: self.workModel)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: workProgressButtomCell) as! WorkProgressButtomCell
                cell.setModel(workModel: self.workModel)
                return cell
            }
        }else if indexPath.section == 4 {
            if stopState == StopState.Stop.rawValue {
                let cell = tableView.dequeueReusableCell(withIdentifier: workCostDetailCell) as! WorkCostDetailCell
                cell.setModel(model: self.workModel)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: workCostCell) as! WorkCostCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workInfoCell) as! WorkInfoCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: customerInfoCell) as! CustomerInfoCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workRemarksCell) as! WorkRemarksCell
            cell.setModel(model: self.workModel)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: workEnclosureCell) as! WorkEnclosureCell
            cell.setModel(model: self.workModel.taskAttachmentList[indexPath.row])
            return cell
        }
    }
    
    public func getBeginStopCell(indexPath:IndexPath)->UITableViewCell{
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workTitleCell) as! WorkTitleCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workEndCell) as! WorkEndCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workTimeCell) as! WorkTimeCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 3 {
            if stopState == StopState.Stop.rawValue {
                let cell = tableView.dequeueReusableCell(withIdentifier: workCostDetailCell) as! WorkCostDetailCell
                cell.setModel(model: self.workModel)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: workCostCell) as! WorkCostCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workInfoCell) as! WorkInfoCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: customerInfoCell) as! CustomerInfoCell
            cell.setModel(model: self.workModel)
            return cell
        }else if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: workRemarksCell) as! WorkRemarksCell
            cell.setModel(model: self.workModel)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: workEnclosureCell) as! WorkEnclosureCell
            cell.setModel(model: self.workModel.taskAttachmentList[indexPath.row])
            return cell
        }
    }
}


extension WorkDetailController: PGDatePickerDelegate {
    
    func datePicker(_ datePicker: PGDatePicker!, didSelectDate dateComponents: DateComponents!) {
        if let date = Calendar.current.date(from: dateComponents) {
            if datePicker.tag == 0 {
                let dateString: String! = date.toString(format: "yyyy-MM-dd")
                let timeStr = date.toString(format: dateString + " 23:59:59")
                let time = date2TimeStamp(time: timeStr, dateFormat: "yyyy-MM-dd HH:mm:ss").toInt
                DispatchQueue.delay(time: 1.5, execute: {[weak self] in
                   self?.showTimeDailog(time: time)
                })
            }
        }
    }
}
