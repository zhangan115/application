//
//  VerifyModel.swift
//  application
//
//  Created by sitech on 2020/6/15.
//  Copyright © 2020 Sitop. All rights reserved.
//

import Foundation
import SwiftyJSON
class UserVerifyModel: Mappable {
    
    required init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        self.idCard = json["idCard"].stringValue
        self.idCardBackPic = json["idCardBackPic"].stringValue
        self.idCardPositivePic = json["idCardPositivePic"].stringValue
        self.idCardUserPic = json["idCardUserPic"].stringValue
        self.verifyReason = json["verifyReason"].stringValue
        self.vocationalQualificationPic = json["vocationalQualificationPic"].stringValue
        self.specialOperationPic = json["specialOperationPic"].stringValue
        self.realName = json["realName"].stringValue
        self.verifiedUserId = json["verifiedUserId"].intValue
        self.verifyId = json["verifyId"].intValue
        self.verifyPassState = json["verifyPassState"].intValue
        self.verifyType = json["verifyType"].intValue
    }
    
    var idCard: String!
    var idCardBackPic: String!
    var idCardPositivePic: String!
    var idCardUserPic: String!
    var verifyReason: String!
    var vocationalQualificationPic : String!
    var specialOperationPic: String!
    var realName: String!
    var verifiedUserId: Int!
    var verifyId: Int!
    var verifyPassState: Int!
    var verifyType: Int!
}
