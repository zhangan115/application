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
    case getTerminatedTaskList
    case getWorkDetail(taskId:Int)
    case getMyCheckTaskList(params:[String: Any])
    case getMyTaskList(params:[String: Any])
    case takeTask(taskId:Int,planArriveTime:Int)
    case uploadImage(data: Data)
    case taskUpdateTime(taskId:Int,planArriveTime:Int)
    case taskStart(taskId:Int,params:String)
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
        case .getWorkDetail:
            return "task/detail"
        case .getMyCheckTaskList:
            return "task/my_submit_list"
        case .getMyTaskList:
            return "task/my_list"
        case .takeTask:
            return "task/take"
        case .uploadImage:
            return "task/upload"
        case .taskUpdateTime:
            return "task/update_arrive_time"
        case .taskStart:
            return "task/start"
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
        case let .getWorkDetail(taskId):
            var param :[String: Any] = [:]
            param["taskId"] = taskId
            return param
        case .getMyCheckTaskList(let params):
            return params
        case .getMyTaskList(let params):
            return params
        case let .takeTask(taskId, planArriveTime):
            var param :[String: Any] = [:]
            param["taskId"] = taskId
            param["planArriveTime"] = planArriveTime
            return param
        case let .taskUpdateTime(taskId, planArriveTime):
            var param :[String: Any] = [:]
            param["taskId"] = taskId
            param["planArriveTime"] = planArriveTime
            return param
        case let .taskStart(taskId,params):
            var param :[String: Any] = [:]
            param["taskId"] = taskId
            param["startPic"] = params
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
        case .getNearbyTask,.getWorkDetail,.getMyCheckTaskList
        ,.getMyTaskList,.takeTask,.taskUpdateTime
        ,.taskStart,.taskAddAttachment,.camerList:
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

