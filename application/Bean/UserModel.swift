//
//  UserModel.swift
//  SmartRoom
//
//  Created by sitech on 2019/6/4.
//  Copyright © 2019 sito. All rights reserved.
//

import Foundation
import SwiftyJSON
class UserModel: NSObject, NSCoding, Mappable {
    
    var enabled: Bool? = nil
    var userId: Int? = nil
    var username: String? = nil
    var certificationType: Int? = nil
    var isFreeze: Bool? = nil
    var linkMan: String? = nil
    var linkManMobile: String? = nil
    var portraitUrl: String? = nil
    var specialOperationGrade: Int? = nil
    var vocationalQualificationGrade: Int? = nil
    var realName: String? = nil
    var userAddress: String? = nil
    var userMobile: String? = nil
    var workYear: String? = nil
    var freezeTime: Int? = nil
    var hasPassword: Bool? = nil
    var freezeReason: String? = nil
    
    func encode(with aCoder: NSCoder) {
        if enabled != nil {
            aCoder.encode(enabled, forKey: "enabled")
        }
        if userId != nil {
            aCoder.encode(userId, forKey: "userId")
        }
        if username != nil {
            aCoder.encode(username, forKey: "username")
        }
        if certificationType != nil {
            aCoder.encode(certificationType, forKey: "certificationType")
        }
        if linkMan != nil {
            aCoder.encode(linkMan, forKey: "linkMan")
        }
        if linkManMobile != nil {
            aCoder.encode(linkManMobile, forKey: "linkManMobile")
        }
        if portraitUrl != nil {
            aCoder.encode(portraitUrl, forKey: "portraitUrl")
        }
        if specialOperationGrade != nil {
            aCoder.encode(specialOperationGrade, forKey: "specialOperationGrade")
        }
        if vocationalQualificationGrade != nil {
            aCoder.encode(vocationalQualificationGrade, forKey: "vocationalQualificationGrade")
        }
        if realName != nil {
            aCoder.encode(realName, forKey: "realName")
        }
        if userAddress != nil {
            aCoder.encode(userAddress, forKey: "userAddress")
        }
        
        if userMobile != nil {
            aCoder.encode(userMobile, forKey: "userMobile")
        }
        
        if workYear != nil {
            aCoder.encode(workYear, forKey: "workYear")
        }
        
        if freezeTime != nil {
            aCoder.encode(freezeTime, forKey: "freezeTime")
        }
        if hasPassword != nil {
            aCoder.encode(hasPassword, forKey: "hasPassword")
        }
        if freezeReason != nil {
            aCoder.encode(freezeReason, forKey: "freezeReason")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        enabled = aDecoder.decodeObject(forKey: "enabled") as? Bool
        userId = aDecoder.decodeObject(forKey: "userId") as? Int
        username = aDecoder.decodeObject(forKey: "username") as? String
        certificationType = aDecoder.decodeObject(forKey: "certificationType") as? Int
        isFreeze = aDecoder.decodeObject(forKey: "isFreeze") as? Bool
        username = aDecoder.decodeObject(forKey: "username") as? String
        realName = aDecoder.decodeObject(forKey: "realName") as? String
        
        linkMan = aDecoder.decodeObject(forKey: "usernlinkManame") as? String
        linkManMobile = aDecoder.decodeObject(forKey: "linkManMobile") as? String
        portraitUrl = aDecoder.decodeObject(forKey: "portraitUrl") as? String
        specialOperationGrade = aDecoder.decodeObject(forKey: "specialOperationGrade") as? Int
        vocationalQualificationGrade = aDecoder.decodeObject(forKey: "vocationalQualificationGrade") as? Int
        realName = aDecoder.decodeObject(forKey: "realName") as? String
        userAddress = aDecoder.decodeObject(forKey: "userAddress") as? String
        userMobile = aDecoder.decodeObject(forKey: "userMobile") as? String
        workYear = aDecoder.decodeObject(forKey: "workYear") as? String
        freezeReason = aDecoder.decodeObject(forKey: "freezeReason") as? String
        freezeTime = aDecoder.decodeObject(forKey: "freezeTime") as? Int
        hasPassword = aDecoder.decodeObject(forKey: "hasPassword") as? Bool
    }
    
    required init(fromJson json: JSON!) {
        if json.isEmpty{
            return
        }
        username = json["username"].stringValue
        realName = json["realName"].stringValue
        enabled = json["enabled"].boolValue
        userId = json["userId"].intValue
        username = json["username"].stringValue
        certificationType = json["certificationType"].intValue
        isFreeze = json["isFreeze"].boolValue
        linkMan = json["linkMan"].stringValue
        linkManMobile = json["linkManMobile"].stringValue
        portraitUrl = json["portraitUrl"].stringValue
        specialOperationGrade = json["specialOperationGrade"].intValue
        vocationalQualificationGrade = json["vocationalQualificationGrade"].intValue
        userAddress = json["userAddress"].stringValue
        userMobile = json["userMobile"].stringValue
        workYear = json["workYear"].stringValue
        freezeTime = json["freezeTime"].intValue
        hasPassword = json["hasPassword"].boolValue
        freezeReason = json["freezeReason"].stringValue
    }
    
    
    class func path() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        return documentPath! + "/user"
    }
    
    class func archiverUser(_ user: UserModel) {
        NSKeyedArchiver.archiveRootObject(user, toFile: path())
    }
    
    class func unarchiver() ->UserModel? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: path()) as? UserModel
    }
    
}
