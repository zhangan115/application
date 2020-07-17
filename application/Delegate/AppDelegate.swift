//
//  AppDelegate.swift
//  application
//
//  Created by sitech on 2020/4/28.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Realm
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        //集成个推与地图
        configureGeTui()
        initAMap()
        initRealm()
        if UserDefaults.standard.bool(forKey: kIsLogin) {
            let nav = PGBaseNavigationController.init(rootViewController: MainViewController())
            window?.rootViewController = nav
        }else {
            if UserDefaults.standard.bool(forKey: kIsGuide){
                let nav = PGBaseNavigationController.init(rootViewController: UserLoginViewController())
                window?.rootViewController = nav
            }else{
                window?.rootViewController = GuideViewController()
            }
        }
        return true
    }
    
    func initRealm(){
        /* Realm 数据库配置，用于数据库的迭代更新 */
        let path = RealmConfiguration.taskRealmPath()
        let config = Realm.Configuration(
            fileURL:path,
            // 设置新的架构版本。必须大于之前所使用的
            // （如果之前从未设置过架构版本，那么当前的架构版本为 0）
            schemaVersion: 3,
            // 设置模块，如果 Realm 的架构版本低于上面所定义的版本，
            // 那么这段代码就会自动调用
            migrationBlock: { migration, oldSchemaVersion in
                // 我们目前还未执行过迁移，因此 oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // 没有什么要做的！
                    // Realm 会自行检测新增和被移除的属性
                    // 然后会自动更新磁盘上的架构
                }
        })
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
        print("version is \(realm.configuration.schemaVersion)")
    }
    
}

