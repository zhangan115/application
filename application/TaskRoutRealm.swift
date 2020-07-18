//
//  TaskRoutRealm.swift
//  application
//
//  Created by sitech on 2020/7/8.
//  Copyright © 2020 Sitop. All rights reserved.
//

import Foundation
import RealmSwift

class TaskRoutRealm : Object {
    
    let taskId = RealmOptional<Int>()
    @objc dynamic var itemName: String? = nil
    @objc dynamic var itemValue: String? = nil
    
}

class TaskFinishRealm:Object{
    
    let taskId = RealmOptional<Int>()
    @objc dynamic var photoList: String? = nil
    @objc dynamic var fileNameList: String? = nil
    @objc dynamic var fileUrList: String? = nil
    @objc dynamic var note: String? = nil
    
    override static func primaryKey() -> String? {
        return "taskId"
    }
}

class TaskBeginRealm: Object {
    let taskId = RealmOptional<Int>()
    @objc dynamic var photoList: String? = nil
    override static func primaryKey() -> String? {
        return "taskId"
    }
}
