//
//  PGEnumeration.swift
//  Evpro
//
//  Created by piggybear on 2017/11/2.
//  Copyright © 2017年 piggybear. All rights reserved.
//

import Foundation
import UIKit

enum TaskType: Int {
    
    case repair = 1 //抢修
    case experiment //试验
    case electric   //带电
    case inspection //巡检
    case other      //其他
    
    func map() -> String {
        switch self {
        case .repair:
            return "抢修工单"
        case .experiment:
            return "试验工单"
        case .electric:
            return "带电工单"
        case .inspection:
            return "巡检工单"
        case .other:
            return "其他工单"
        }
    }
    
    var text: String {
        switch self {
        case .repair:
            return "抢修"
        case .experiment:
            return "试验"
        case .electric:
            return "带电"
        case .inspection:
            return "巡检"
        case .other:
            return "其他"
        }
    }
    
    var imageNamed: String {
        switch self {
        case .repair:
            return "list_img_tag_red"
        case .experiment:
            return "list_img_tag_yellow"
        case .electric:
            return "list_img_tag_purple"
        case .inspection:
            return "list_img_tag_blue"
        case .other:
            return "list_img_tag_other"
        }
    }
    
}

enum WorkType:Int {
    case  WORK_TYPE_BASE = 1//基础
    case  WORK_TYPE_ROUT = 2//巡检
    case  WORK_TYPE_RUSH = 3//技术
}

enum WorkState : Int {
    case  TASK_NODE_CONFIRMING = 1
    case  WORK_ROB = 2//抢单
    case  WORK_BEGIN = 3//待开始
    case  WORK_PROGRESS = 4//进行中
    case  WORK_CHECK = 5//待验收
    case  WORK_FINISH = 6//完成
}

enum WorkStopState:Int {
    case  WORK_STOP_NORMAL = 0 //没有终止
    case  WORK_STOP_PROGRESS = 1//申请终止 未结算
    case  WORK_STOP_FINISH = 2 //申请终止 已经结算
}

enum WorkGrade :Int{
    /**
     * 电工特种作业操作证等级
     */
    case SPECIAL_OPERATION_GRADE_LOW = 1 //电工特种作业操作证（低级）
    case SPECIAL_OPERATION_GRADE_HIGH = 2 //电工特种作业操作证（高级）
    /**
     * 电工职业资格等级证等级
     */
    case VOCATIONAL_QUALIFICATION_GRADE_FIRST = 3 //电工职业资格等级证（五级）
    case VOCATIONAL_QUALIFICATION_GRADE_SECOND = 4 //电工职业资格等级证（四级）
    case VOCATIONAL_QUALIFICATION_GRADE_THIRD = 5 //电工职业资格等级证（三级）
    case VOCATIONAL_QUALIFICATION_GRADE_FOURTH = 6 //电工职业资格等级证（二级）
    case VOCATIONAL_QUALIFICATION_GRADE_FIFTH = 7 //电工职业资格等级证（一级）
}

enum TaskState: Int {
    case unReceive = 1  //待领取
    case unSubmit       //待提交计划
    case unCheck        //待审核计划
    case todo           //待开始
    case doing          //进行中
    case finish         //步骤已完成
    case unVerify       //已完成
    case verified       //已验收
    
    func toText() -> String {
        let list = ["待领取", "计划中", "待审核计划", "待开始", "进行中", "已完成", "已完成", "已验收"]
        let index = self.rawValue - 1
        if index >= 0 && index < list.count {
            return list[index]
        }
        return ""
    }
}

/// 告警等级
enum AlarmLevel: Int {
    case one = 1
    case two
    case three
    
    func map() -> UIImage {
        switch self {
        case .one:
            return UIImage(named: "maintenance_soe_i")!
        case .two:
            return UIImage(named: "maintenance_soe_ii")!
        case .three:
            return UIImage(named: "maintenance_soe_iii")!
        }
    }
    
    func toTextColor() -> UIColor? {
        switch self {
        case .one:
            return UIColor(hexString: "#FF5E5E")
        case .two:
            return UIColor(hexString: "#EBC52A")
        case .three:
            return UIColor(hexString: "#2EC4D6")
        }
    }
    
    func toString() -> String {
        switch self {
        case .one:
            return "I级"
        case .two:
            return "II级"
        case .three:
            return "III级"
        }
    }
}

///处理状态
enum ProcessState: Int {
    case unProcess  //未处理
    case processed  //已处理
    case cleanAlarm //已消警
    
    func map() -> String {
        switch self {
        case .unProcess:
            return "未处理"
        case .processed:
            return "已处理"
        case .cleanAlarm:
            return "已消警"
        }
    }
}

///确认状态
enum ConfirmState: Int {
    case unConfirm  //未确认
    case comfirmed  //已确认
    
    func map() -> String {
        switch self {
        case .unConfirm:
            return "未确认"
        case .comfirmed:
            return "已确认"
        }
    }
}

///消息类型
enum MessageType: Int {
    case workOrder = 1
    case alarm
}

enum StopState:Int {
    case Normal = 0
    case Progress = 1
    case Stop = 2
}


///工单状态
enum TicketState: Int {
    case unStart = -1   //未开始
    case processing     //进行中
    case completed      //已完成
    
    func toString() -> String {
        switch self {
        case .unStart:
            return "未开始"
        case .processing:
            return "进行中"
        case .completed:
            return "已完成"
        }
    }
    
    func toTextColor() -> UIColor? {
        switch self {
        case .unStart:
            return UIColor(hexString: "#FF5E5E")
        case .processing:
            return UIColor(hexString: "#dcc52d")
        case .completed:
            return UIColor(hexString: "#5eff8b")
        }
    }
}

//工单步骤状态
enum AlarmType: Int {
    //故障类型
    case ALARM_TYPE_INFORM = 1//告知
    case ALARM_TYPE_CHANGE = 2//变位
    case ALARM_TYPE_CROSS = 3//越线
    case ALARM_TYPE_UNUSUAL = 4//异常
    case ALARM_TYPE_FAULT = 5//故障
}

enum AlarmState :Int{
    //告警状态
    case ALARM_STATE_NO_HANDLE = 0//未处理
    case ALARM_STATE_HANDING = 1//处理中
    case ALARM_STATE_HANDLED = 2//已消警告
}

