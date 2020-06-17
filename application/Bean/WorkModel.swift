//
//  WorkModel.swift
//  application
//
//  Created by sitech on 2020/6/15.
//  Copyright © 2020 Sitop. All rights reserved.
//

import Foundation
import SwiftyJSON
class WorkModel: Mappable {
    
    var actualStartTime:Int?
    var canDo: Bool!
    var confirmUserId: Int!
    var actualFee:String!
    var createTime: Int!
    var customerContact: String!
    var customerPhone: String!
    var distance: Double!
    var equipmentCode: String!
    var equipmentType: String!
    var executorName:String!
    var executorTakeTime:Int!
    var executorUserId:Int!
    var isPaid:Bool!
    var isTerminated: Bool!
    var planEndTime: Int!
    var planStartTime: Int!
    var taskAttachment: String!
    var taskContent: String!
    var taskFee: String!
    var taskId: Int!
    var taskLocation: String!
    var taskLocationLatitude: Double!
    var taskLocationLongitude: Double!
    var taskName: String!
    var taskNote: String!
    var taskSource: String!
    var taskSourceId:Int!
    var taskState: Int!
    var taskType: Int!
    var terminateReason:String!
    var terminateState:Int!
    var terminateTime:Int!
    var terminateUserId:Int!
    var workflowId: Int!
    var hasEverSubmitted:Bool!
    var requiredSocLevel:Int?
    var requiredEpqcLevel:Int?
    var cost:String!
    var taskAttachmentList: [TaskAttachment]!
    
    required init(fromJson json: JSON!) {
        if json.isEmpty{
            return
        }
        self.actualStartTime = json["actualStartTime"].intValue
        self.canDo = json["canDo"].boolValue
        self.confirmUserId = json["confirmUserId"].intValue
        self.actualFee = json["actualFee"].stringValue
        self.createTime = json["createTime"].intValue
        self.customerContact = json["customerContact"].stringValue
        self.customerPhone = json["customerPhone"].stringValue
        self.distance = json["distance"].doubleValue
        self.equipmentCode = json["equipmentCode"].stringValue
        self.equipmentType = json["equipmentType"].stringValue
        self.executorName = json["executorName"].stringValue
        self.executorTakeTime = json["executorTakeTime"].intValue
        self.executorUserId = json["executorUserId"].intValue
        self.isPaid = json["isPaid"].boolValue
        self.isTerminated = json["isTerminated"].boolValue
        self.planEndTime = json["planEndTime"].intValue
        self.planStartTime = json["planStartTime"].intValue
        self.taskAttachment = json["taskAttachment"].stringValue
        self.taskContent = json["taskContent"].stringValue
        self.taskFee = json["taskFee"].stringValue
        self.taskId = json["taskId"].intValue
        self.taskLocation = json["taskLocation"].stringValue
        self.taskLocationLatitude = json["taskLocationLatitude"].doubleValue
        self.taskLocationLongitude = json["taskLocationLongitude"].doubleValue
        self.taskName = json["taskName"].stringValue
        self.taskNote = json["taskNote"].stringValue
        self.taskSource = json["taskSource"].stringValue
        self.taskSourceId = json["taskSourceId"].intValue
        self.taskState = json["taskState"].intValue
        self.taskType = json["taskType"].intValue
        self.terminateReason = json["terminateReason"].stringValue
        self.terminateState = json["terminateState"].intValue
        self.terminateTime = json["terminateTime"].intValue
        self.terminateUserId = json["terminateUserId"].intValue
        self.workflowId = json["workflowId"].intValue
        self.hasEverSubmitted = json["hasEverSubmitted"].boolValue
        self.requiredSocLevel = json["requiredSocLevel"].intValue
        self.requiredEpqcLevel = json["requiredEpqcLevel"].intValue
        self.cost = json["cost"].stringValue
        self.taskAttachmentList = [TaskAttachment]()
        let taskList = json["list"].arrayValue
        if !taskList.isEmpty {
            for array in taskList {
                let value = TaskAttachment(fromJson: array)
                self.taskAttachmentList.append(value)
            }
        }
    }
}

class TaskAttachment : Mappable {
    
    var fileName: String!
    var fileUrl: String!
    
    required init(fromJson json: JSON!) {
        if json.isEmpty{
            return
        }
        self.fileName = json["fileName"].stringValue
        self.fileUrl = json["fileUrl"].stringValue
    }
    
    
}
