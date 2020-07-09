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
    var actualEndTime : Int?
    var canDo: Bool!
    var confirmUserId: Int!
    var actualFee:String!
    var createTime: Int!
    var customerContact: String!
    var customerPhone: String!
    var lastNote: String?
    var distance: Double!
    var equipmentCode: String!
    var equipmentType: String!
    var equipmentName: String!
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
    var planArriveTime:Int!
    var workflowId: Int!
    var hasEverSubmitted:Bool!
    var requiredSocLevel:Int?
    var requiredEpqcLevel:Int?
    var cost:String!
    var cutFeeDetail:String?
    var beforeStartFile:TaskUploadFile?
    var afterFinishFile:TaskUploadFile?
    var taskAttachmentList: [TaskAttachment]!
    
    required init(fromJson json: JSON!) {
        if json.isEmpty{
            return
        }
        self.actualStartTime = json["actualStartTime"].intValue
        self.actualEndTime = json["actualEndTime"].intValue
        self.planArriveTime = json["planArriveTime"].intValue
        self.canDo = json["canDo"].boolValue
        self.confirmUserId = json["confirmUserId"].intValue
        self.actualFee = json["actualFee"].stringValue
        self.createTime = json["createTime"].intValue
        self.customerContact = json["customerContact"].stringValue
        self.customerPhone = json["customerPhone"].stringValue
        self.distance = json["distance"].doubleValue
        self.equipmentCode = json["equipmentCode"].stringValue
        self.equipmentType = json["equipmentType"].stringValue
        self.equipmentName = json["equipmentName"].stringValue
        self.lastNote = json["lastNote"].stringValue
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
        self.cutFeeDetail = json["cutFeeDetail"].stringValue
        self.taskAttachmentList = [TaskAttachment]()
        let taskList = json["list"].arrayValue
        if !taskList.isEmpty {
            for array in taskList {
                let value = TaskAttachment(fromJson: array)
                self.taskAttachmentList.append(value)
            }
        }
        self.beforeStartFile = TaskUploadFile(fromJson: json["beforeStartFile"])
        self.afterFinishFile = TaskUploadFile(fromJson: json["afterFinishFile"])
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
class TaskUploadFile : Mappable{
    
    var fromNodeId:Int!
    var nodeData:String!
    var nodeExecutorId:Int!
    var nodeIndex:Int!
    var nodeName:String!
    var nodePic:String!
    var nodeNote:String!
    var nodeStartTime:Int!
    var nodeStatus:Int!
    var taskId:Int!
    var taskNodeId:Int!
    var nodePicList:[PicNote]!
    var nodeDataList:[DataItem]!
    var nodeAttachmentList:[TaskAttachment]!
    
    required init(fromJson json: JSON!) {
        if json.isEmpty{
            return
        }
        self.fromNodeId = json["fromNodeId"].intValue
        self.nodeData = json["nodeData"].stringValue
        self.nodeExecutorId = json["nodeExecutorId"].intValue
        self.nodeIndex = json["nodeIndex"].intValue
        self.nodeName = json["nodeName"].stringValue
        self.nodePic = json["nodePic"].stringValue
        self.nodeNote = json["nodeNote"].stringValue
        self.nodeStartTime = json["nodeStartTime"].intValue
        self.nodeExecutorId = json["nodeExecutorId"].intValue
        self.nodeStatus = json["nodeStatus"].intValue
        self.taskId = json["taskId"].intValue
        self.taskNodeId = json["taskNodeId"].intValue
        
        self.nodePicList = [PicNote]()
        let list1 = json["nodePicList"].arrayValue
        if !list1.isEmpty {
            for array in list1 {
                let value = PicNote(fromJson: array)
                self.nodePicList.append(value)
            }
        }
        
        self.nodeDataList = [DataItem]()
        let list2 = json["nodeDataList"].arrayValue
        if !list2.isEmpty {
            for array in list2 {
                let value = DataItem(fromJson: array)
                self.nodeDataList.append(value)
            }
        }
        self.nodeAttachmentList = [TaskAttachment]()
        let list3 = json["nodeAttachmentList"].arrayValue
        if !list3.isEmpty {
            for array in list3 {
                let value = TaskAttachment(fromJson: array)
                self.nodeAttachmentList.append(value)
            }
        }
    }
    
}

class PicNote : NSObject, NSCoding, Mappable{
    
    var picCount:Int!
    var picName:String!
    var picNote:String!
    var picUrlList:[String]!
    
    func encode(with aCoder: NSCoder) {
        if picCount != nil {
            aCoder.encode(picCount, forKey: "picCount")
        }
        if picName != nil {
            aCoder.encode(picName, forKey: "picName")
        }
        if picNote != nil {
            aCoder.encode(picNote, forKey: "picNote")
        }
        if picUrlList != nil {
            aCoder.encode(picUrlList, forKey: "picUrlList")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        picCount = aDecoder.decodeObject(forKey: "picCount") as? Int
        picName = aDecoder.decodeObject(forKey: "picName") as? String
        picNote = aDecoder.decodeObject(forKey: "picNote") as? String
        picUrlList = aDecoder.decodeObject(forKey: "picUrlList") as? [String]
    }
    
    required init(fromJson json: JSON!) {
        if json.isEmpty{
            return
        }
        self.picCount = json["picCount"].intValue
        self.picName = json["picName"].stringValue
        self.picNote = json["picNote"].stringValue
        
        self.picUrlList = [String]()
        let list1 = json["picUrlList"].arrayValue
        if !list1.isEmpty {
            for array in list1 {
                let value = array.stringValue
                self.picUrlList.append(value)
            }
        }
    }
    
}
class CurrentNode: Mappable {
    
    var fromNodeId:Int!
    var nodeIndex: Int!
    var nodeName: String!
    var nodeStatus: Int!
    var taskId: Int!
    var taskNodeId: Int!
    var nodePicList:[PicNote]!
    
    required init(fromJson json: JSON!) {
        if json.isEmpty{
            return
        }
        self.fromNodeId = json["fromNodeId"].intValue
        self.nodeIndex = json["nodeIndex"].intValue
        self.nodeName = json["nodeName"].stringValue
        self.nodeStatus = json["nodeStatus"].intValue
        self.taskId = json["taskId"].intValue
        self.taskNodeId = json["taskNodeId"].intValue
        self.nodePicList = [PicNote]()
        let list1 = json["nodePicList"].arrayValue
        if !list1.isEmpty {
            for array in list1 {
                let value = PicNote(fromJson: array)
                self.nodePicList.append(value)
            }
        }
    }
}

class DataItem : Mappable{
    
    required init(fromJson json: JSON!) {
        self.id = json["id"].intValue
        self.taskId = json["taskId"].intValue
        self.itemName = json["itemName"].stringValue
        self.itemValue = json["itemValue"].stringValue
    }
    
    var id: Int!
    var taskId: Int!
    var itemName:String!
    var itemValue:String?
    
}
