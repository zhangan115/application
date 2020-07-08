//
//  RealmConfiguration.swift
//  application
//
//  Created by sitech on 2020/7/8.
//  Copyright © 2020 Sitop. All rights reserved.
//

import Foundation
import RealmSwift

class RealmConfiguration {
    
    static func taskRealmPath() -> URL {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path: String = documentPath + "/Realm/"
        let manager = FileManager.default
        let exist = manager.fileExists(atPath: path)
        if !exist {
            try! manager.createDirectory(at: URL(fileURLWithPath: path), withIntermediateDirectories: true,
                                         attributes: nil)
        }
        return URL(fileURLWithPath: path + "task.realm")
    }
    
}
