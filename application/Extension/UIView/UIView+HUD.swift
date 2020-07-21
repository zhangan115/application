//
//  UIView+HUD.swift
//  edetection
//
//  Created by piggybear on 2017/7/4.
//  Copyright © 2017年 piggybear. All rights reserved.
//

import Foundation
import PKHUD
import NVActivityIndicatorView
import Toaster
import MBProgressHUD

extension MBProgressHUD {
    func showMessage(_ message: String) {
        self.mode = .text
        self.label.text = message
    }
    
    func hudUpdate(message: String, completion:@escaping ()->()) {
        self.label.text = message
        DispatchQueue.main.asyncAfter(deadline: 0.5, execute: {
            self.hide(animated: true)
            completion()
        })
    }
    
    class func customHud() -> MBProgressHUD {
        let view: UIView = UIApplication.shared.keyWindow!
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.removeFromSuperViewOnHide = true
        hud.contentColor = UIColor.white
        hud.label.font = UIFont.systemFont(ofSize: 14)
        hud.bezelView.color = UIColor.black
        hud.removeFromSuperViewOnHide = true
        for subView in hud.bezelView.subviews {
            if subView.className == "UIVisualEffectView" {
                subView.subviews.setAll({ (_, view) in
                    view.backgroundColor = UIColor.black
                })
            }
        }
        return hud
    }
}

extension UIView {
    //MARK: - public method
    public func showHUD(message: String) {
        let hud = MBProgressHUD.customHud()
        hud.mode = .text
        hud.label.text = message
    }
    
    func hiddenHUD() {
        let view: UIView = UIApplication.shared.keyWindow!
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    public func showAutoHUD(_ message: String, afterDelay: Double = 0.5) {
        let hud = MBProgressHUD.customHud()
        hud.mode = .text
        hud.label.text = message
        hud.hide(animated: true, afterDelay: afterDelay)
    }
    
    public func showHUD(_ message: String, completion:@escaping ()->()) {
        let hud = MBProgressHUD.customHud()
        hud.mode = .text
        hud.label.text = message
        DispatchQueue.main.asyncAfter(deadline: 0.5, execute: {
            hud.hide(animated: true)
            completion()
        })
    }
    
    public func showHUD(_ message: String, afterDelay: Double = 0.5 ,completion:@escaping ()->()) {
        let hud = MBProgressHUD.customHud()
        hud.mode = .text
        hud.label.text = message
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(floatLiteral: afterDelay), execute: {
            hud.hide(animated: true)
            completion()
        })
    }
    
    func toast(_ message: String, completion:@escaping ()->()) {
        let duration: TimeInterval = 0
        let toast = Toast(text: message, delay: 0, duration: duration)
        toast.view.backgroundColor = UIColor.black
        toast.view.textColor = UIColor.white
        toast.view.font = UIFont.systemFont(ofSize: 15)
        toast.view.bottomOffsetPortrait = 60
        toast.show()
        DispatchQueue.main.asyncAfter(deadline: 0.5, execute: {
            completion()
        })
    }
    
    func toast(_ message: String) {
        let duration: TimeInterval = 0.5
        let toast = Toast(text: message, delay: 0, duration: duration)
        toast.view.backgroundColor = UIColor.black
        toast.view.textColor = UIColor.white
        toast.view.font = UIFont.systemFont(ofSize: 15)
        toast.view.bottomOffsetPortrait = 60
        toast.show()
    }
    
    public func showPKHUD (message: String) {
        HUD.flash(.label(message), delay: 0.6) { _ in }
    }
    
    public func showActivityIndicatorView (offset: Bool = false) {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.tag = 1001
        self.addSubview(view)
        self.bringSubviewToFront(view)
        
        let width: CGFloat = 50
        let frame = CGRect(x: screenWidth / 2 - width / 2, y: offset ? screenHeight / 2 - width / 2 - 64 : screenHeight / 2 - width / 2, width: width, height: width)
        let activityIndicatorView = NVActivityIndicatorView(frame: frame, type: .ballRotateChase)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        let animationTypeLabel = UILabel(frame: frame)
        animationTypeLabel.text = "Loading..."
        animationTypeLabel.sizeToFit()
        animationTypeLabel.textColor = UIColor.white
        animationTypeLabel.center = CGPoint(x: activityIndicatorView.center.x, y: activityIndicatorView.center.y + 25 + 25)
        view.addSubview(animationTypeLabel)
    }
    
    public func hideActivityIndicatorView() {
        self.viewWithTag(1001)?.removeFromSuperview()
    }

}
