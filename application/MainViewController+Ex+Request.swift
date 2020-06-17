//
//  MainViewController+Ex+Request.swift
//  application
//
//  Created by sitech on 2020/6/15.
//  Copyright © 2020 Sitop. All rights reserved.
//

import Foundation
extension MainViewController {
    
    func requestData(){
        if self.currentLocation == nil {
            return
        }
        taskProviderNoPlugin.rxRequest(.getNearbyTask(longitude: self.currentLocation!.coordinate.longitude, latitude: self.currentLocation!.coordinate.latitude))
            .toListModel(type: WorkModel.self)
            .subscribe(onSuccess: {[weak self] (list) in
                self?.workListToShow(list: list)
            }) {[weak self](error) in
                self?.view.showAutoHUD("请求出错")
        }.disposed(by: disposeBag)
        requestAppVersion()
    }
    
    func workListToShow(list:[WorkModel]){
        self.currentWorkModel = list.first
        if let model = self.currentWorkModel {
            bottomWorkView.workDataView.setData(workData: model)
        }
        annotations.removeAll()
        self.workModelList.removeAll()
        self.workModelList = list
        for model in list {
            let anno = MAPointAnnotation()
            anno.coordinate = CLLocationCoordinate2D(latitude: model.taskLocationLatitude, longitude: model.taskLocationLongitude)
            annotations.append(anno)
        }
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
    }
    
    func requestUserData(){
        let user =  UserModel.unarchiver()
        if user == nil {
            UserDefaults.standard.set(false, forKey: kIsLogin)
            UIApplication.shared.keyWindow?.rootViewController = UserLoginViewController()
            return
        }
        userProviderNoPlugin.requestResult(.getUserDetail(userId: user!.userId!), success: {[weak self](json) in
            let userModel = UserModel.init(fromJson: json["data"])
            UserModel.archiverUser(userModel)
            self?.certificationView.isHidden = userModel.certificationType! > 0
            self?.freezyView.isHidden = !userModel.isFreeze!
            self?.requestUserVeryList()
        })
    }
    
    func requestUserVeryList(){
        userProviderNoPlugin.rxRequest(.getUserVerifyList(userId: UserModel.unarchiver()!.userId!, verifyType: nil))
            .toListModel(type: UserVerifyModel.self)
            .subscribe(onSuccess: {[weak self] (list) in
                if self != nil{
                    let model = list.last
                    if let model = model {
                        if model.verifyPassState != 3 && model.verifyPassState != 2 {
                            return
                        }
                        let saveId = UserDefaults.standard.integer(forKey: kUserVerifyId)
                        if model.verifyId > saveId {
                            UserDefaults.standard.set(model.verifyId, forKey: kUserVerifyId)
                            var title = ""
                            let message = model.verifyReason
                            let cancel = "忽略"
                            var sure = "确定"
                            if model.verifyPassState == 3 {
                                sure = "去重新认证"
                                if model.verifyType == 1 {
                                    title = "实名认证不通过"
                                }else{
                                    title = "电工认证不通过"
                                }
                            }else if model.verifyPassState == 2 {
                                if model.verifyType == 1 {
                                    title = "实名认证通过"
                                }else{
                                    title = "电工认证通过"
                                }
                            }
                            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                            let noAction = UIAlertAction(title: cancel, style: .cancel, handler: nil)
                            let sureAction = UIAlertAction(title: sure, style: .default, handler: {(_)->Void in
                                if model.verifyType == 1 {
                                    // 显示实名认证
                                    let controller = UserIdentityController()
                                    self?.pushVC(controller)
                                }else{
                                    // 显示电工认证
                                    let controller = UserElectricianController()
                                    self?.pushVC(controller)
                                }
                            })
                            alertController.addAction(noAction)
                            alertController.addAction(sureAction)
                            self?.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
            }) {[weak self](error) in
                self?.view.showAutoHUD("请求出错")
        }.disposed(by: disposeBag)
    }
    
    func requestAppVersion(){
        if isRequestAppVersion {
            return
        }
        let user =  UserModel.unarchiver()
        userProviderNoPlugin.rxRequest(.appVersion(userId: user!.userId!,version:Config.APP_VERSION,longitude:self.currentLocation!.coordinate.longitude,latitude: self.currentLocation!.coordinate.latitude)).subscribe().disposed(by: disposeBag)
    }
    
}
