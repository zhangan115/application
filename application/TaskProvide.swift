//
//  TaskProvide.swift
//  SmartRoom
//
//  Created by sitech on 2019/6/4.
//  Copyright © 2019 sito. All rights reserved.
//

import Foundation
import Moya


let taskProvider = MoyaProvider<TaskTarget>(manager: PGAlamofireManager.sharedManager
    , plugins: [PGProvider.networkPlugin()])

let taskProviderNoPlugin = MoyaProvider<TaskTarget>(manager: PGAlamofireManager.sharedManager)

enum TaskTarget {
    case getNearbyTask(longitude:Double,latitude:Double)
    case  getTerminatedTaskList
    case substationTree
    case taskCreate(taskType:Int?,substationIds:String?,taskExecutorIds:String?,taskContent:String?,planStartTime:Int?,planEndTime:Int!,alarmId:String?)
    case taskLoad(taskId:Int)
    case submitPlan(taskId:Int,securityManager:String?,requireDriver:String?
        ,requireDevice:String?,requireVehicle:String?,requireMaterial:String?
        ,requireParts:String?,planContent:String?)
    case uploadImage(data: Data)
    case taskSubmit(taskId:Int,taskSummary:String,taskImages:String)
    case taskVerify(taskId:Int,verifyContent:String,isPassed:Int)//是否通过，1：通过，0：不通过
    case substationListUser
    case taskAddAttachment(params:[String:Any])
    case camerList(substationId:Int)
    case getCarList(substationId:Int)
    case getInstrument(substationId:Int)
    case getDirverList(substationId:Int)
    case getSpareList(substationId:Int)
}

extension TaskTarget:TargetType {
    var baseURL: URL { return Config.baseURL }
    var path: String {
        switch self {
        case .getNearbyTask:
            return "task/nearby_can_do"
        case .getTerminatedTaskList:
            return "task/terminated_list"
        case .substationTree:
            return "substation/tree"
        case .taskCreate:
            return "task/create"
        case .taskLoad:
            return "task/load"
        case .submitPlan:
            return "task/submit_plan"
        case .uploadImage:
            return "task/upload_file"
        case .taskSubmit:
            return "task/submit"
        case .taskVerify:
            return "task/verify"
        case .substationListUser:
            return "substation/list/user"
        case .taskAddAttachment:
            return "task/add_attachment"
        case .camerList:
            return "camera/get/list"
        case .getCarList:
            return "app/car/list"
        case .getInstrument:
            return "app/instrument/list"
        case .getDirverList:
            return "app/driver/list"
        case .getSpareList:
            return "app/spare/list"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCarList,.getInstrument,.getDirverList,.getSpareList:
            return .get
        default:
            return .post
        }
      
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .getNearbyTask(longitude,latitude):
            var param :[String: Any] = [:]
            param["longitude"] = longitude
            param["latitude"] = latitude
            return param
        case let .taskCreate(taskType, substationIds, taskExecutorIds, taskContent, planStartTime, planEndTime,alarmId):
            var param :[String: Any] = [:]
            if let taskType = taskType{
                param["taskType"] = taskType
            }
            if let substationIds = substationIds{
                param["substationIds"] = substationIds
            }
            if let taskExecutorIds = taskExecutorIds{
                param["taskExecutorIds"] = taskExecutorIds
            }
            if let taskContent = taskContent{
                param["taskContent"] = taskContent
            }
            if let planStartTime = planStartTime{
                param["planStartTime"] = planStartTime
            }
            if let planEndTime = planEndTime{
                param["planEndTime"] = planEndTime
            }
            if let alarmId = alarmId{
                param["alarmId"] = alarmId
            }
            return param
        case let .taskLoad(taskId):
            return ["taskId":taskId]
        case let .submitPlan(taskId, securityManager, requireDriver, requireDevice, requireVehicle, requireMaterial, requireParts, planContent):
            var param :[String: Any] = [:]
              param["taskId"] = taskId
            if let securityManager = securityManager {
                param["securityManager"] = securityManager
            }
            if let requireDriver = requireDriver{
                param["requireDriver"] = requireDriver
            }
            if let requireDevice = requireDevice{
                param["requireDevice"] = requireDevice
            }
            if let requireVehicle = requireVehicle{
                param["requireVehicle"] = requireVehicle
            }
            if let requireMaterial = requireMaterial{
                param["requireMaterial"] = requireMaterial
            }
            if let requireParts = requireParts{
                param["requireParts"] = requireParts
            }
            if let planContent = planContent{
                param["planContent"] = planContent
            }
            return param
        case let .taskSubmit(taskId,taskSummary,taskImages):
            var param :[String: Any] = [:]
            param["taskId"] = taskId
            param["taskSummary"] = taskSummary
            param["taskImages"] = taskImages
            return param
        case let .taskVerify(taskId,verifyContent,isPassed):
            var param :[String: Any] = [:]
            param["taskId"] = taskId
            param["verifyContent"] = verifyContent
            param["isPassed"] = isPassed
            return param
        case let .taskAddAttachment(params):
            return params
        case let .camerList(substationId):
            return ["substationId":substationId]
        case let .getCarList(substationId):
            return ["substationId":substationId]
        case let .getInstrument(substationId):
            return ["substationId":substationId]
        case let .getDirverList(substationId):
            return ["substationId":substationId]
        case let .getSpareList(substationId):
            return ["substationId":substationId]
        default :
            return nil
        }
    }
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    var sampleData: Data {
        return "sampleData".data(using: .utf8)!
    }
    
    var headers: [String: String]? {
        return ["Cookie": getCookie]
    }
    
    var task: Task {
        switch self {
        case .getNearbyTask,.taskCreate,.taskLoad,.submitPlan,.taskSubmit,.taskVerify,.taskAddAttachment,.camerList:
            return .requestParameters(parameters: parameters!, encoding: parameterEncoding)
        case let .uploadImage(data):
            let formatter = DateFormatter()
            formatter.dateFormat = "ddMMyyyyHHmmss"
            let dateString: String = formatter.string(from: Date())
            let photoName: String = dateString + ".jpg"
            let multipartFormData = [MultipartFormData(provider: .data(data), name: "file", fileName: photoName, mimeType: "image/jpg")]
            return .uploadMultipart(multipartFormData)
        case .getCarList,.getSpareList,.getDirverList,.getInstrument:
            return .requestParameters(parameters: parameters!, encoding: URLEncoding.default)
        default :
            return .requestPlain
        }
    }
}

