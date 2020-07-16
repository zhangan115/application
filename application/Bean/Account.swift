//
//  Account.swift
//  application
//
//  Created by sitech on 2020/6/18.
//  Copyright © 2020 Sitop. All rights reserved.
//

import Foundation
import SwiftyJSON

class Account:Mappable{
    
    var accountAmount: String!
    var lastPaidTime: Int!
    var lastTakeTime: Int!
    var lockFromTime: Int!
    
    required init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        self.accountAmount = json["accountAmount"].stringValue
        self.lastPaidTime = json["lastPaidTime"].intValue
        self.lastTakeTime = json["lastTakeTime"].intValue
        self.lockFromTime = json["lockFromTime"].intValue
    }
}

class AccountLogList:Mappable{
    
    var list: [BillList]!
    var totalCount: Int!
    
    required init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        self.totalCount = json["totalCount"].intValue
        self.list = [BillList]()
        let taskList = json["list"].arrayValue
        if !taskList.isEmpty {
            for array in taskList {
                let value = BillList(fromJson: array)
                self.list.append(value)
            }
        }
    }
}

class BillList:Mappable{
    var billAmount: String!
    var billTime: Int!
    var billType: Int!
    var billName: String!
    var billNote: String!
    var billOverage: String!
    required init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        if let fee = json["billAmount"].float {
            self.billAmount = String(format: "%.2f",fee)
        }
        if let fee1 = json["billOverage"].float {
            self.billOverage = String(format: "%.2f",fee1)
        }
        self.billTime = json["billTime"].intValue
        self.billType = json["billType"].intValue
        self.billNote = json["billNote"].stringValue
        self.billName = json["billName"].stringValue
    }
}

class UserBillHeader {
    var headerTime: String!
    var billIn: Float = 0
    var billOut: Float = 0
    var list : [BillList]! = []
}

class Province : Mappable {
    
    var name: String!
    var city: [City]!
    
    required init(fromJson json: JSON!) {
        self.name = json["name"].stringValue
        self.city = [City]()
        let cityList = json["city"].arrayValue
        if !cityList.isEmpty {
            for item in cityList {
                city.append(City.init(fromJson: item))
            }
        }
    }
}

class City:Mappable {
    
    var name: String!
    var area: [String]!
    
    required init(fromJson json: JSON!) {
        self.name = json["name"].stringValue
        self.area = [String]()
        let areaList = json["area"].arrayValue
        if !areaList.isEmpty {
            for item in areaList {
                area.append(item.stringValue)
            }
        }
    }
}
