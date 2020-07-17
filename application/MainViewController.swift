//
//  ViewController.swift
//  application
//
//  Created by sitech on 2020/4/28.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import Toaster
import SwiftyJSON
class MainViewController: BaseHomeController {
    
    lazy var titleLayoutView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var titleLayoutLineView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#FAFAFA")
        self.titleLayoutView.addSubview(view)
        return view
    }()
    
    lazy var drawableIcon: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_icon_user"), for: .normal)
        button.addTarget(self, action: #selector(showDrawable), for: .touchUpInside)
        self.titleLayoutView.addSubview(button)
        return button
    }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = ""
        label.textColor = UIColor(hexString: "#333333")
        self.titleLayoutView.addSubview(label)
        return label
    }()
    
    lazy var workIcon: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_icon_work"), for: .normal)
        button.addTarget(self, action: #selector(showWork), for: .touchUpInside)
        self.titleLayoutView.addSubview(button)
        return button
    }()
    
    lazy var serviceBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_icon_service_big"), for: .normal)
        button.addTarget(self, action: #selector(showService), for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }()
    
    lazy var raibWorkBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_icon_grab_big"), for: .normal)
        button.addTarget(self, action: #selector(raibWork), for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }()
    
    lazy var locationBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_icon_position_big"), for: .normal)
        button.addTarget(self, action: #selector(location), for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }()
    
    lazy var refreshBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "home_icon_refresh_big"), for: .normal)
        button.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }()
    
    lazy var raibNowBtn: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(raibNow), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 22
        button.setTitle("立即抢单", for: .normal)
        button.setBackgroundColor(UIColor(hexString: "#FFCC00")!, forState: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        self.view.addSubview(button)
        return button
    }()
    //认证提示
    lazy var certificationView : UIView = {
        let view = UIView()
        self.view.addSubview(view)
        view.isHidden = true
        view.backgroundColor = UIColor.white
        return view
    }()
    lazy var certificationContentView : UIView = {
        let view = UIView()
        self.certificationView.addSubview(view)
        view.backgroundColor = UIColor(hexString: "#FFEACD")
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 2
        return view
    }()
    lazy var certificationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.text = "您还未进行实名认证，无法接单"
        label.textColor = UIColor(hexString: "#666666")
        self.certificationContentView.addSubview(label)
        return label
    }()
    lazy var veryfBtn: UIButton = {
        let button = UIButton()
        button.setTitle("去认证 >", for: .normal)
        button.setTitleColor(UIColor(hexString: "#FF7D00"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(veryf), for: .touchUpInside)
        self.certificationContentView.addSubview(button)
        return button
    }()
    //冻结提示
    lazy var freezyView : UIView = {
        let view = UIView()
        view.isHidden = true
        self.view.addSubview(view)
        view.backgroundColor = UIColor.white
        return view
    }()
    lazy var freezyContentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#FFEACD")
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 2
        self.freezyView.addSubview(view)
        return view
    }()
    lazy var freezyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.text = ""
        label.textColor = UIColor(hexString: "#666666")
        self.freezyContentView.addSubview(label)
        return label
    }()
    //地图
    lazy var mapView: MAMapView! = {
        let view = MAMapView()
        view.mapType = .standard
        view.showsCompass = false
        view.delegate = self
        self.view.insertSubview(view, at: 0)
        return view
    }()
    //工单数据
    var currentWorkModel : WorkModel? = nil
    
    lazy var bottomWorkView : BottomWorkView = {
        let view = BottomWorkView()
        view.tapClosure = {(index)in
            switch index {
            case 0:
                self.raibWork()
                break
            case 1:
                self.location()
                break
            case 2:
                self.refresh()
                break
            case 3:
                self.showService()
                break
            case 4:
                self.raibCurreWork()
                break
            default:
                return
            }
        }
        self.view.addSubview(view)
        return view
    }()
    
    var locationManager = AMapLocationManager()
    var isLocatioonRequest = false
    var currentLocation : CLLocation? = nil
    var annotations = [MAPointAnnotation]()
    var workModelList : [WorkModel] = []
    var isRequestAppVersion = false
    let disposeBag = DisposeBag()
    
    let search :AMapSearchAPI = AMapSearchAPI()
    var pathPolyLines:[CLLocationCoordinate2D]! = []
    var polyline : MAPolyline? = nil
    
    lazy var drawerView : MainDrawerUIView = {
        let view = MainDrawerUIView(frame: self.view.frame)
        view.isHidden = true
        if let user = UserModel.unarchiver() {
            view.setData(user)
        }
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        configLocationManager()
        setMap()
        requestUserData()
        requestUserVeryList()
        hideBottomView()
        search.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(bindCid), name: NSNotification.Name(rawValue: kUserCidNotifyKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(messageRefresh), name: NSNotification.Name(rawValue: kMessageNotifyKey), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func messageRefresh(){
        self.refresh()
        self.requestUserData()
    }
    
    //显示侧栏
    @objc func showDrawable(){
        drawerView.showLayout()
    }
    //显示工单列表
    @objc func showWork(){
        if self.currentLocation == nil {
            return
        }
        let controller = WorkViewController()
        controller.currentLocation = self.currentLocation
        self.pushVC(controller)
    }
    //抢单列表
    @objc func raibWork(){
        if self.currentLocation == nil {
            return
        }
        let controller = WorkRobController()
        controller.currentLocation = self.currentLocation
        self.pushVC(controller)
    }
    //客服
    @objc func showService(){
        let alertController = UIAlertController(title: kServicePhone, message:"是否拨打电话?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let sureAction = UIAlertAction(title: "拨打", style: .default, handler: {(_)->Void in
            callPhoneTelpro(phone: kServicePhone)
        })
        alertController.addAction(noAction)
        alertController.addAction(sureAction)
        self.present(alertController, animated: true, completion: nil)
    }
    // 抢当前工单
    @objc func raibCurreWork(){
        let userModel = UserModel.unarchiver()
        if userModel == nil{
            return
        }
        if userModel!.isFreeze ?? false {
            let controller = UserFreezyController()
            controller.modalPresentationStyle = .custom
            self.present(controller, animated: true, completion: {
                controller.initView()
            })
            return
        }
        if let model = self.currentWorkModel {
            if model.taskType == WorkType.WORK_TYPE_BASE.rawValue {
                if userModel!.certificationType == 0 {
                    showUserVerifyDialog(1)
                }else{
                    //去抢单
                    let controller = WorkDetailController()
                    controller.workModel = self.currentWorkModel
                    self.pushVC(controller)
                }
            }else {
                if userModel!.certificationType! < 1 {
                    showUserVerifyDialog(0)
                }else{
                    //去抢单
                    let controller = WorkDetailController()
                    controller.workModel = self.currentWorkModel
                    self.pushVC(controller)
                }
            }
        }
    }
    //位置
    @objc func location(){
        hideBottomView()
        requestLocation(false)
    }
    //刷新
    @objc func refresh(){
        hideBottomView()
        requestData()
        requestUserData()
    }
    //立即抢单
    @objc func raibNow(){
       let userModel = UserModel.unarchiver()
       if userModel == nil{
           return
       }
       if userModel!.isFreeze ?? false {
           let controller = UserFreezyController()
           controller.modalPresentationStyle = .custom
           self.present(controller, animated: true, completion: {
               controller.initView()
           })
           return
       }
        if workModelList.isEmpty {
            self.view.toast("附近暂无工单")
            return
        }
        self.currentWorkModel = workModelList.first
        if let model = self.currentWorkModel {
            if !self.annotations.isEmpty {
                self.mapView.selectAnnotation(self.annotations.first!, animated: true)
            }
            self.bottomWorkView.workDataView.setData(workData: model)
            self.bottomWorkView.isHidden = false
        }
    }
    //去认证
    @objc func veryf(){
        let controller = UserIdentityController()
        self.pushVC(controller)
    }
    
    private func showUserVerifyDialog(_ type:Int){
        let verifyDialog =  MainUserVerifyController()
        verifyDialog.modalPresentationStyle = .custom
        verifyDialog.callback = {(index) in
            if index == 1 {
                let controller = UserIdentityController()
                self.pushVC(controller)
            }else if index == 2 {
                let controller = UserElectricianController()
                self.pushVC(controller)
            }
        }
        verifyDialog.type = type
        self.present(verifyDialog, animated: true, completion:nil)
    }
    
    func hideBottomView(){
        if !self.bottomWorkView.isHidden {
            self.bottomWorkView.isHidden = true
        }
        if polyline != nil {
            mapView.remove(polyline)
        }
        self.currentWorkModel = nil
    }
    
    @objc func bindCid(){
        if UserDefaults.standard.bool(forKey: "bindUserCid") {
            return
        }
        if let clientId = UserDefaults.standard.string(forKey: "UserCid") {
            userProviderNoPlugin.request(.postCid(cid: "IOS:" + clientId)) { (result) in
                switch result {
                case .success(let data):
                    let json = try! JSON(data: data.data)
                    if json["errorCode"] == 0 {
                        UserDefaults.standard.set(true, forKey: "bindUserCid")
                    }
                case .failure(_): break
                }
            }
        }
    }
}
