//
//  AlarmProvide.swift
//  SmartRoom
//
//  Created by sitech on 2019/6/10.
//  Copyright © 2019 sito. All rights reserved.
//

import Foundation
import Moya

let userProvider = MoyaProvider<UserTarget>(manager: PGAlamofireManager.sharedManager
    , plugins: [PGProvider.networkPlugin()])

let userProviderNoPlugin = MoyaProvider<UserTarget>(manager: PGAlamofireManager.sharedManager)

enum UserTarget {
    case userLoginByPass(username:String,password:String)
    case userLoginByCode(mobile:String,code:String)
    case getCode(userMobile:String)
    case getUserDetail(userId:Int)
    case editUser(params:[String: Any])
    case verifyUser(params:[String: Any])
    case getUserVerifyList(userId:Int,verifyType:Int?)
    case postUserPhoto(data: Data)
    case postUserVerifyPhoto(data: Data)
    case getIdentifyInfo(picUrl:String)
    case logout
    case accountGet(userId:Int)
    case accountLogList(userId:Int,count:Int)
    case postCid(cid:String)
    case appVersion(userId:Int,version:Int,longitude:Double,latitude:Double)
    case userChangePass(userMobile:String,password:String,vCode:String)
}

extension UserTarget:TargetType {
    var baseURL: URL { return Config.baseURL }
    var path: String {
        switch self {
        case .userLoginByPass:
            return "/login"
        case .userLoginByCode:
            return "/login_by_code"
        case .getCode:
            return "/user/send/vcode"
        case .getUserDetail:
            return "/user/get"
        case .editUser:
            return "user/edit"
        case .verifyUser:
            return "/user/real/electrician/verify"
        case .getUserVerifyList:
            return "user/verify/list"
        case .postUserPhoto:
            return "/user/portrait/upload"
        case .postUserVerifyPhoto:
            return "/user/upload"
        case .getIdentifyInfo:
            return "/user/idCard/identify"
        case .logout:
            return "/logout"
        case .accountGet:
            return "/account/get"
        case .accountLogList:
            return "/account/log/list"
        case .postCid:
            return "/user/bind_cid"
        case .appVersion:
            return "/update/appVersion"
        case .userChangePass:
            return "/user/edit/password"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .userLoginByPass(let username, let password):
            return ["username": username, "password": password]
        case .userLoginByCode(let mobile, let code):
            return ["mobile": mobile, "code": code]
        case .getCode(let userMobile):
            return ["userMobile": userMobile]
        case .getUserDetail(let userId):
            return ["userId": userId]
        case .editUser(let params):
            return params
        case .verifyUser(let params):
            return params
        case .getUserVerifyList(let userId, let verifyType):
            var param :[String: Any] = [:]
            param["userId"] = userId
            if let verifyType = verifyType{
                param["verifyType"] = verifyType
            }
            return param
        case .getIdentifyInfo(let picUrl):
            return ["picUrl": picUrl]
        case .accountGet(let userId):
            return ["userId": userId]
        case .accountLogList(let userId,let count):
            return ["userId": userId, "count": count]
        case .postCid(let cid):
            return ["cid": cid]
        case .appVersion(let userId,let version,let longitude,let latitude):
            var param :[String: Any] = [:]
            param["longitude"] = longitude
            param["latitude"] = latitude
            param["userId"] = userId
            param["version"]=version
            return param
        case .userChangePass(let userMobile, let password,let vCode):
            return ["userMobile": userMobile, "password": password, "vCode": vCode]
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
        case .logout:
            return .requestPlain
        case .userLoginByPass,.userLoginByCode:
            return .requestParameters(parameters: parameters!, encoding: URLEncoding.default)
        case let .postUserPhoto(data),let .postUserVerifyPhoto(data):
            let formatter = DateFormatter()
            formatter.dateFormat = "ddMMyyyyHHmmss"
            let dateString: String = formatter.string(from: Date())
            let photoName: String = dateString + ".jpg"
            let multipartFormData = [MultipartFormData(provider: .data(data), name: "file", fileName: photoName, mimeType: "image/jpg")]
            return .uploadMultipart(multipartFormData)
        default:
            return .requestParameters(parameters: parameters!, encoding: parameterEncoding)
        }
    }
}
