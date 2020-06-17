//
//  AppDelegate.swift
//  application
//
//  Created by sitech on 2020/4/28.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        UIApplication.shared.applicationIconBadgeNumber = 0
        //集成个推与地图
        configureGeTui()
        initAMap()
        
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
    
}

