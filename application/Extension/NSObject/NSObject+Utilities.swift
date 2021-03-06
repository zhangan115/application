//
//  NSObject+Utilities.swift
//  edetection
//
//  Created by piggybear on 02/05/2017.
//  Copyright © 2017 piggybear. All rights reserved.
//

import Foundation
import UIKit
import Moya

extension NSObject {
    public func currentViewController() -> UIViewController {
        let viewController = UIApplication.shared.keyWindow?.rootViewController
        return findBestViewController(viewController: viewController!)
    }
    
    //MARK: - private method
    private func findBestViewController(viewController: UIViewController) -> UIViewController {
        if let vc = viewController.presentedViewController {
            // Return presented view controller
            return findBestViewController(viewController: vc)
        }else if viewController.isKind(of: UISplitViewController.self) {
            // Return right hand side
            let svc = viewController as! UISplitViewController
            if svc.viewControllers.count > 0 {
                return findBestViewController(viewController: svc.viewControllers.last!)
            }else {
                return viewController
            }
        }else if viewController is UINavigationController {
            // Return top view
            let navigationController = viewController as! UINavigationController
            if navigationController.viewControllers.count > 0 {
                return findBestViewController(viewController: navigationController.topViewController!)
            }else {
                return viewController
            }
        }else if viewController.isKind(of: UITabBarController.self) {
            // Return visible view
            let tabBar = viewController as! UITabBarController
            if tabBar.viewControllers!.count > 0 {
                return findBestViewController(viewController: tabBar.selectedViewController!)
            }else {
                return viewController
            }
        }
        // Unknown view controller type, return last child view controller
        return viewController
    }
    
}
