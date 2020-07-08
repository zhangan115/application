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
