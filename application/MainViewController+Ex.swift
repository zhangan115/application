//
//  File.swift
//  application
//
//  Created by sitech on 2020/6/12.
//  Copyright © 2020 Sitop. All rights reserved.
//

import Foundation

extension MainViewController {
    
    func initView(){
        self.view.addSubview(titleLayoutView)
        titleLayoutView.snp.updateConstraints{(make)in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(CF_StatusBarHeight)
            make.height.equalTo(44)
        }
        titleLayoutLineView.snp.updateConstraints{(make)in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        drawableIcon.snp.updateConstraints{(make)in
            make.left.equalTo(13)
            make.centerY.equalToSuperview()
        }
        cityLabel.snp.updateConstraints{(make)in
            make.centerY.centerX.equalToSuperview()
        }
        workIcon.snp.updateConstraints{(make)in
            make.right.equalTo(-13)
            make.centerY.equalToSuperview()
        }
        serviceBtn.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(8)
            make.bottom.equalTo(-78-TabbarSafeBottomMargin)
        }
        refreshBtn.snp.updateConstraints{(make)in
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalTo(-78-TabbarSafeBottomMargin)
        }
        locationBtn.snp.updateConstraints{(make)in
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalTo(refreshBtn.snp.top).offset(-6)
        }
        raibWorkBtn.snp.updateConstraints{(make)in
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalTo(locationBtn.snp.top).offset(-12)
        }
        raibNowBtn.snp.updateConstraints{(make)in
            make.bottom.equalToSuperview().offset(-18-TabbarSafeBottomMargin)
            make.left.equalTo(45)
            make.right.equalTo(-45)
            make.height.equalTo(44)
        }
        mapView.snp.updateConstraints{(make)in
            make.top.equalTo(self.titleLayoutView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        certificationView.snp.updateConstraints{(make)in
            make.top.equalTo(self.titleLayoutView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        certificationContentView.snp.updateConstraints{(make)in
            make.top.equalToSuperview().offset(2)
            make.left.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-13)
            make.height.equalTo(34)
        }
        certificationLabel.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        veryfBtn.snp.updateConstraints{(make)in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        freezyView.snp.updateConstraints{(make)in
            make.top.equalTo(self.titleLayoutView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        freezyContentView.snp.updateConstraints{(make)in
            make.top.equalToSuperview().offset(2)
            make.left.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-13)
            make.height.equalTo(34)
        }
        freezyLabel.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        bottomWorkView.snp.updateConstraints{(make)in
            make.left.right.equalToSuperview()
            make.height.equalTo(226)
            make.bottom.equalToSuperview().offset(-18-TabbarSafeBottomMargin)
        }
    }
    
    func mapView(_ mapView: MAMapView!, didSingleTappedAt coordinate: CLLocationCoordinate2D) {
        hideBottomView()
    }
}

extension MainViewController:MAMapViewDelegate,AMapLocationManagerDelegate{
    
    func configLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.locationTimeout = 2
        locationManager.reGeocodeTimeout = 2
        requestLocation()
    }
    
    func setMap(){
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        let r = MAUserLocationRepresentation()
        r.showsAccuracyRing = false
        r.showsHeadingIndicator = true
        mapView.update(r)
    }
    
    func requestLocation(_ needRefresh : Bool = true){
        if isLocatioonRequest {
            return
        }
        isLocatioonRequest = true
        locationManager.requestLocation(withReGeocode: true, completionBlock: {
            [weak self] (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            if let error = error {
                let error = error as NSError
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    return
                }else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    return
                }
            }
            if let location = location {
                self?.mapView.centerCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                self?.mapView.setZoomLevel(16, animated: true)
            }
            self?.currentLocation = location
            if let reGeocode = reGeocode {
                self?.cityLabel.text = reGeocode.city
                let currentArea = reGeocode.province + " " + reGeocode.city + " " + reGeocode.district
                print(currentArea)
                UserDefaults.standard.set(currentArea, forKey: kUserLocation)
            }
            self?.isLocatioonRequest = false
            if (self?.currentLocation) != nil{
                if needRefresh {
                    self?.requestData()
                }
            }
        })
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, doRequireLocationAuth locationManager: CLLocationManager!) {
        
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAUserLocation.self){
            return nil
        }else if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: CustomAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! CustomAnnotationView?
            if annotationView == nil {
                annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            //设置中心点偏移，使得标注底部中间点成为经纬度对应点
            annotationView?.canShowCallout = false
            annotationView?.isDraggable = true
            annotationView?.centerOffset = CGPoint(x: 0, y: -18)
            let idx = annotations.firstIndex(of: annotation as! MAPointAnnotation)
            if idx != nil {
                let model  = self.workModelList[idx!]
                annotationView?.currentLocation = self.currentLocation!
                annotationView?.workModel = model
                if model.taskType == WorkType.WORK_TYPE_BASE.rawValue{
                    annotationView?.image = UIImage(named: "home_icon_basis")
                }else if model.taskType == WorkType.WORK_TYPE_ROUT.rawValue{
                    annotationView?.image = UIImage(named: "home_icon_inspection")
                }else{
                    annotationView?.image = UIImage(named: "home_icon_skill")
                }
            }
            return annotationView!
        }
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        if view.isKind(of: CustomAnnotationView.self) {
            let customView = view as? CustomAnnotationView
            if customView != nil {
                let model = customView!.workModel
                self.currentWorkModel = model
                self.bottomWorkView.workDataView.setData(workData: model!)
                self.bottomWorkView.isHidden = false
                self.routeSearch(workModel: self.currentWorkModel!)
            }
        }
    }
    
    func mapView(_ mapView: MAMapView!, didDeselect view: MAAnnotationView!) {
        
    }
    
}


// MARK: - 隐藏navigationBar
extension MainViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if setupClass() {
            self.navigationController?.navigationBar.isHidden = true
        }else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if setupClass() {
            self.navigationController?.navigationBar.isHidden = true
        }else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupClass() ->Bool {
        let controller = self.currentViewController()
        if controller.isKind(of: WebViewController.self) ||
            controller.isKind(of: WorkViewController.self) ||
            controller.isKind(of: UserIdentityController.self) ||
            controller.isKind(of: UserElectricianController.self){
            return true
        }
        return false
    }
}
