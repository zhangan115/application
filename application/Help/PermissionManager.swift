//
//  PermissionManager.swift
//  Evpro
//
//  Created by piggybear on 2017/12/2.
//  Copyright © 2017年 piggybear. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import Photos
import Speech

enum PermissionManagerType {
    case camera
    case photoLibrary
    case audio
    case speechRecognizer
}

class PermissionManager {
    typealias completion = (()->())
    
    static func permission(type: PermissionManagerType, completion: completion) {
        switch type {
        case .camera:
            cameraPermission(completion: completion)
            return
        case .photoLibrary:
            photoLibraryPermission(completion: completion)
            return
        case .audio:
            audioPermission(completion: completion)
        case .speechRecognizer:
            if #available(iOS 10.0, *) {
                speechRecognizerPermission(completion: completion)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    static func cameraPermission(completion: completion) {
        let status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        let isAuthorized: Bool = status == .authorized || status == .notDetermined
        if isAuthorized {
            completion()
        }else {
            alertController(type: .camera)
        }
    }
    
    static func photoLibraryPermission(completion: completion) {
        let isAuthorized: Bool = PHPhotoLibrary.authorizationStatus() == .authorized || PHPhotoLibrary.authorizationStatus() == .notDetermined
        if isAuthorized {
            completion()
        }else {
            alertController(type: .photoLibrary)
        }
    }
    
    static func audioPermission(completion: completion) {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        let isAuthorized: Bool = status == .authorized || status == .notDetermined
        if isAuthorized {
            completion()
        }else {
            alertController(type: .audio)
        }
    }
    
    @available(iOS 10.0, *)
    static func speechRecognizerPermission(completion: completion) {
        let status = SFSpeechRecognizer.authorizationStatus()
        let isAuthorized: Bool = status == .authorized || status == .notDetermined
        if isAuthorized {
            completion()
        }else {
            alertController(type: .speechRecognizer)
        }
    }
}

extension PermissionManager {
    fileprivate static func alertController(type: PermissionManagerType) {
        var message = ""
        switch type {
        case .camera:
            message = "请您前去打开相机权限在操作"
        case .photoLibrary:
            message = "请您前去打开照片权限在操作"
            if #available(iOS 11.0, *) {
                message = "请您将照片权限修改为【读取和写入】然后在操作"
            }
        case .audio:
            message = "请您前去打开麦克风权限在操作"
        case .speechRecognizer:
            message = "请您前去打开语音识别权限在操作"
        }
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: { _ in
            let url: URL = URL(string: UIApplication.openSettingsURLString)!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        alertController.addAction(okAction)
        NSObject().currentViewController().present(alertController, animated: false, completion: nil)
    }
}
