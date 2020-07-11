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
    case uploadImage(taskId:Int?,data: Data)
    case taskUpdateTime(taskId:Int,planArriveTime:Int)
    case taskStart(taskId:Int,params:String)
    case substationListUser
    case taskSubmit(params:[String:Any])
    case terminateTask(taskId:Int,terminateReason:String)
    case getTaskVerifyLog(taskId:Int)
    case getInstrument(substationId:Int)
    case getDirverList(substationId:Int)
    case getSpareList(substationId:Int)
    case checkFile(fileUrl:String)
    
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
        case .taskSubmit:
            return "task/submit"
        case .terminateTask:
            return "task/request_terminate"
        case .getTaskVerifyLog:
            return "task/verify_log"
        case .getInstrument:
            return "app/instrument/list"
        case .getDirverList:
            return "app/driver/list"
        case .getSpareList:
            return "app/spare/list"
        case let .checkFile(fileUrl):
            return fileUrl
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getInstrument,.getDirverList,.getSpareList:
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
        case let .taskSubmit(params):
            return params
        case let .terminateTask(taskId,terminateReason):
            return ["taskId":taskId,"terminateReason":terminateReason]
        case let .getTaskVerifyLog(taskId):
            return ["taskId":taskId]
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
        ,.taskStart,.taskSubmit,.terminateTask,.getTaskVerifyLog:
            return .requestParameters(parameters: parameters!, encoding: parameterEncoding)
        case let .uploadImage(taskId,data):
            let formatter = DateFormatter()
            formatter.dateFormat = "ddMMyyyyHHmmss"
            let dateString: String = formatter.string(from: Date())
            let photoName: String = dateString + ".jpg"
            var multipartFormData = [MultipartFormData(provider: .data(data), name: "file", fileName: photoName, mimeType: "image/jpg")]
            if let taskId = taskId {
                let strData = taskId.toString.data(using: .utf8)
                let formData1 = MultipartFormData(provider: .data(strData!), name: "taskId")
                multipartFormData.append(formData1)
            }
            return .uploadMultipart(multipartFormData)
        case .getSpareList,.getDirverList,.getInstrument:
            return .requestParameters(parameters: parameters!, encoding: URLEncoding.default)
            case let .checkFile(fileUrl):
                       let saveName = fileUrl.split("/").last ?? ""
                       let localLocation: URL = DefaultDownloadDir.appendingPathComponent(saveName)
                       let downloadDestination:DownloadDestination = { _, _ in
                           return (localLocation, .removePreviousFile) }
                       return .downloadDestination(downloadDestination)
        default :
            return .requestPlain
        }
    }
}

//定义下载的DownloadDestination（不改变文件名，同名文件不会覆盖）
private let DefaultDownloadDestination: DownloadDestination = { temporaryURL, response in
    return (DefaultDownloadDir.appendingPathComponent(response.suggestedFilename!), [.removePreviousFile])
}

//默认下载保存地址（用户文档目录）
let DefaultDownloadDir: URL = {
    let directoryURLs = FileManager.default.urls(for: .documentDirectory,
                                                 in: .userDomainMask)
    return directoryURLs.first ?? URL(fileURLWithPath: NSTemporaryDirectory())
}()
