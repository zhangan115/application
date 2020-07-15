//
//  WorkListItemView.swift
//  application
//
//  Created by sitech on 2020/6/22.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import MapKit

class WorkListItemView: UIView {
    
    lazy var contentLayoutView : UIView = {
        let layerView = UIView()
        // fillCode
        let bgLayer1 = CALayer()
        bgLayer1.frame = layerView.bounds
        bgLayer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        layerView.layer.addSublayer(bgLayer1)
        // shadowCode
        layerView.layer.shadowColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.16).cgColor
        layerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        layerView.layer.shadowOpacity = 1
        layerView.layer.shadowRadius = 4
        layerView.backgroundColor = UIColor.white
        layerView.layer.masksToBounds = true
        layerView.layer.cornerRadius = 4
        self.insertSubview(layerView, at: 0)
        return layerView
    }()
    
    lazy var iconView :UIImageView = {
        let view = UIImageView()
        self.addSubview(view)
        return view
    }()
    
    lazy var equipmentView :UIImageView = {
        let view = UIImageView()
        contentLayoutView.addSubview(view)
        return view
    }()
    
    lazy var icon1View :UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named:"home_card_icon_yuan")
        self.contentLayoutView.addSubview(view)
        return view
    }()
    
    lazy var textName1 :UILabel = {
        let view = UILabel()
        view.text = "工单费用："
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor(hexString: "#454545")
        self.contentLayoutView.addSubview(view)
        return view
    }()
    
    lazy var money :UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = UIFont.systemFont(ofSize: 20)
        view.textColor = UIColor(hexString: "#333333")
        self.contentLayoutView.addSubview(view)
        return view
    }()
    
    lazy var icon2View :UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named:"home_card_icon_location")
        self.contentLayoutView.addSubview(view)
        return view
    }()
    lazy var textName2 :UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor(hexString: "#333333")
        self.contentLayoutView.addSubview(view)
        return view
    }()
    
    lazy var icon7View :UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named:"list_card_icon_distance")
        self.contentLayoutView.addSubview(view)
        return view
    }()
    
    lazy var textName7 :UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor(hexString: "#454545")
        self.contentLayoutView.addSubview(view)
        return view
    }()
    
    lazy var icon6View :UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named:"info_circle_medal")
        self.contentLayoutView.addSubview(view)
        return view
    }()
    
    lazy var textName6 :UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor(hexString: "#454545")
        self.contentLayoutView.addSubview(view)
        return view
    }()
    
    lazy var textName8 :UILabel = {
        let view = UILabel()
        view.text = ""
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor(hexString: "#454545")
        self.contentLayoutView.addSubview(view)
        return view
    }()
    
    lazy var icon3View :UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named:"home_card_icon_info")
        self.contentLayoutView.addSubview(view)
        return view
    }()
    lazy var textName3 :UILabel = {
        let view = UILabel()
        view.text = "1#充电桩故障修理"
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor(hexString: "#454545")
        self.contentLayoutView.addSubview(view)
        return view
    }()
    
    lazy var tiemLayoutView : UIView = {
        let layerView = UIView()
        layerView.backgroundColor = UIColor(hexString: "#F7F9FF")
        self.contentLayoutView.addSubview(layerView)
        return layerView
    }()
    
    lazy var icon4View :UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named:"home_card_icon_time")
        self.tiemLayoutView.addSubview(view)
        return view
    }()
    
    lazy var textName4 :UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = UIFont.systemFont(ofSize: 13)
        view.textColor = UIColor(hexString: "#454545")
        self.tiemLayoutView.addSubview(view)
        return view
    }()
    
    lazy var bottomLabel1 :UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = UIFont.systemFont(ofSize: 14,weight: .medium)
        view.textColor = UIColor(hexString: "#FF5252")
        view.isHidden = true
        self.tiemLayoutView.addSubview(view)
        return view
    }()
    
    lazy var bottomLabel2 :UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = UIFont.systemFont(ofSize: 13,weight: .medium)
        view.textColor = UIColor(hexString: "#333333")
        view.isHidden = true
        self.tiemLayoutView.addSubview(view)
        return view
    }()
    lazy var bottomLabel3 :UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = UIFont.systemFont(ofSize: 22,weight: .medium)
        view.textColor = UIColor(hexString: "#FF2020")
        view.isHidden = true
        self.tiemLayoutView.addSubview(view)
        return view
    }()
    
    lazy var raibWorkBtn: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(raibWork), for: .touchUpInside)
        button.setTitle("", for: .normal)
        button.setTitleColor(UIColor(hexString: "#454545"), for: .normal)
        button.setBackgroundColor(UIColor(hexString: "#FFCC00")!, forState: .normal)
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 2
        self.tiemLayoutView.addSubview(button)
        return button
    }()
    
    var currentRequestType = 3
    var workData:WorkModel!
    func setData(workData:WorkModel,requestType:Int){
        self.workData = workData
        self.currentRequestType = requestType
        if workData.taskType == 1 {
            iconView.image = UIImage(named: "home_card_img_yellow")
        }else if workData.taskType == 2 {
            iconView.image = UIImage(named: "home_card_img_blue")
        }else {
            iconView.image = UIImage(named: "home_card_img_red")
        }
        equipmentView.image = UIImage(named: "home_card_img1")
        money.text = "￥" + workData.taskFee
        textName2.text = workData.taskLocation
        textName6.text = "资格要求："
        textName8.text = getTaskNeedSkill(workData)
        if workData.distance < 3 {
            textName7.text = "<3km"
        } else if workData.distance < 6 && workData.distance >= 3{
            textName7.text = "<6km"
        } else if workData.distance < 9 && workData.distance >= 6{
            textName7.text = "<9km"
        } else {
            textName7.text = ">9km"
        }
        
        textName3.text = workData.taskContent
        if requestType == 3 {
            icon4View.image = UIImage(named: "home_card_icon_time")
            raibWorkBtn.isHidden = false
            bottomLabel3.isHidden = true
            bottomLabel2.isHidden = true
            raibWorkBtn.setTitle("导航前往", for: .normal)
            
            let currentDate = (Date().timeIntervalSince1970 * 1000).toInt
            let planStartTime = workData.planStartTime!
            if currentDate > planStartTime {//逾期
                bottomLabel1.isHidden = true
                textName4.text = "工单已逾期，请立即前往作业！"
                textName4.textColor = UIColor(hexString:"#FF5252")
            }else{//没有逾期
                bottomLabel1.isHidden = false
                let time = planStartTime - currentDate - 8 * 60 * 60 * 1000
                textName4.text = "距离开始还剩"
                textName4.textColor = UIColor(hexString:"#454545")
                if time > 3600 * 1000 * 24 {
                    bottomLabel1.text = dateString(millisecond: TimeInterval(time), dateFormat: "dd天HH小时mm分ss秒")
                }else {
                    bottomLabel1.text = dateString(millisecond: TimeInterval(time), dateFormat: "HH小时mm分ss秒")
                }
            }
        }else if requestType == 4 {
            icon4View.image = UIImage(named: "home_card_icon_time")
            raibWorkBtn.isHidden = false
            bottomLabel3.isHidden = true
            bottomLabel2.isHidden = false
            raibWorkBtn.setTitle("资料上传", for: .normal)
            textName4.text = "作业开始时间"
            bottomLabel2.text = dateString(millisecond: TimeInterval(workData.actualStartTime ?? 0), dateFormat: "yyyy-MM-dd HH:mm:ss")
        }else if requestType == 5 {
            icon4View.image = UIImage(named: "home_card_icon_time")
            raibWorkBtn.isHidden = true
            bottomLabel3.isHidden = true
            textName4.text = "客服验收中，请等待..."
            textName4.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        }else {
            icon4View.image = UIImage(named: "home_card_icon_yuan")
            raibWorkBtn.isHidden = true
            textName4.text = "工单收入"
            bottomLabel1.isHidden = true
            bottomLabel2.isHidden = true
            bottomLabel3.isHidden = false
            bottomLabel3.text = "￥" + workData.actualFee
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentLayoutView.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-2)
            make.top.equalToSuperview().offset(2)
        }
        iconView.snp.updateConstraints{(make)in
            make.right.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(0)
            make.height.width.equalTo(40)
        }
        equipmentView.snp.updateConstraints{(make)in
            make.left.top.equalToSuperview().offset(12)
            make.height.width.equalTo(70)
        }
        icon1View.snp.updateConstraints{(make)in
            make.left.equalTo(self.equipmentView.snp.right).offset(5)
            make.height.width.equalTo(14)
            make.top.equalToSuperview().offset(18)
        }
        textName1.snp.updateConstraints{(make)in
            make.left.equalTo(self.icon1View.snp.right).offset(4)
            make.centerY.equalTo(self.icon1View)
        }
        money.snp.updateConstraints{(make)in
            make.left.equalTo(self.textName1.snp.right)
            make.bottom.equalTo(self.textName1)
        }
        icon2View.snp.updateConstraints{(make)in
            make.left.equalTo(self.equipmentView.snp.right).offset(5)
            make.height.width.equalTo(14)
            make.top.equalTo(self.icon1View.snp.bottom).offset(10)
        }
        textName2.snp.updateConstraints{(make)in
            make.left.equalTo(self.icon2View.snp.right).offset(4)
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalTo(icon2View)
        }
        icon7View.snp.updateConstraints{(make)in
            make.left.equalTo(self.equipmentView.snp.right).offset(5)
            make.height.width.equalTo(14)
            make.top.equalTo(self.icon2View.snp.bottom).offset(10)
        }
        textName7.snp.updateConstraints{(make)in
            make.left.equalTo(self.icon2View.snp.right).offset(4)
            make.centerY.equalTo(icon7View)
        }
        icon6View.snp.updateConstraints{(make)in
            make.left.equalTo(self.equipmentView.snp.right).offset(5)
            make.height.width.equalTo(14)
            make.top.equalTo(self.icon7View.snp.bottom).offset(10)
        }
        textName6.snp.updateConstraints{(make)in
            make.left.equalTo(self.icon7View.snp.right).offset(4)
            make.centerY.equalTo(icon6View)
        }
        textName8.snp.updateConstraints{(make)in
            make.left.equalTo(self.textName6.snp.right)
            make.top.equalTo(self.textName6.snp.top)
            make.right.equalToSuperview().offset(-12)
        }
        icon3View.snp.updateConstraints{(make)in
            make.left.equalTo(self.equipmentView.snp.right).offset(5)
            make.height.width.equalTo(14)
            make.top.equalTo(self.textName8.snp.bottom).offset(10)
        }
        textName3.snp.updateConstraints{(make)in
            make.left.equalTo(self.icon6View.snp.right).offset(4)
            make.centerY.equalTo(icon3View)
            make.right.equalToSuperview().offset(-12)
        }
        tiemLayoutView.snp.updateConstraints{(make)in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(46)
        }
        icon4View.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        textName4.snp.updateConstraints{(make)in
            make.left.equalTo(self.icon4View.snp.right).offset(4)
            make.centerY.equalToSuperview()
        }
        bottomLabel1.snp.updateConstraints { (make) in
            make.left.equalTo(self.textName4.snp.right).offset(0)
            make.centerY.equalToSuperview()
        }
        bottomLabel2.snp.updateConstraints { (make) in
            make.left.equalTo(self.textName4.snp.right).offset(0)
            make.centerY.equalToSuperview()
        }
        bottomLabel3.snp.updateConstraints { (make) in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
        raibWorkBtn.snp.updateConstraints{(make)in
            make.right.equalToSuperview().offset(-12)
            make.width.equalTo(70)
            make.height.equalTo(32)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var callback:((Int)->())?
    
    @objc func raibWork(){
        if self.workData.taskState == WorkState.WORK_BEGIN.rawValue {
            goToSystemMap()
        }else if self.workData.taskState == WorkState.WORK_PROGRESS.rawValue  {
            let controller = WorkFinishController()
            controller.workModel = self.workData
            controller.callback = {
                let detailController = WorkDetailController()
                detailController.workModel = self.workData
                self.currentViewController().pushVC(detailController)
            }
            currentViewController().pushVC(controller)
        }else{
            callback?(self.currentRequestType)
        }
    }
    
    func go2Map() {
        let annotation:MAAnnotation?
        let toLocation = CLLocationCoordinate2D(latitude: self.workData.taskLocationLatitude, longitude: self.workData.taskLocationLongitude)
    
        //======其他地图都没的话就直接用系统地图========
        if !UIApplication.shared.canOpenURL(URL.init(string: "baidumap://")!) && !UIApplication.shared.canOpenURL(URL.init(string: "iosamap://")!) {
            goToSystemMap()
            return
        }
        let alertController = UIAlertController(title: "选择导航地图", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
            
        }
        //==================系统地图============
        let appleAction = UIAlertAction(title: "系统地图", style: .default){ (action) in
            self.goToSystemMap()
        }
        //=================百度地图=============
        if UIApplication.shared.canOpenURL(URL.init(string: "baidumap://")!) {//判断是否安装了地图
            let baiduAction = UIAlertAction(title: "百度地图", style: .default){ (action) in
                //origin={{我的位置}} ，目的地随便写
                let urlString = "baidumap://map/direction?origin={{我的位置}}&destination=latlng:\(self.workData.taskLocationLatitude),\(self.workData.taskLocationLongitude)|name=\(String(describing: self.workData.taskLocation))&mode=driving&coord_type=gcj02"
                let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                UIApplication.shared.openURL(URL.init(string: escapedString!)!)
            }
            alertController.addAction(baiduAction)
        }
        //高德地图
        if UIApplication.shared.canOpenURL(URL.init(string: "iosamap://")!) {
            let gaodeAction = UIAlertAction(title: "高德地图", style: .default){ (action) in
                let urlString = "iosamap://navi?sourceApplication=金牌电工&backScheme=youappscheme&lat=\(self.workData.taskLocationLatitude)&lon=\(self.workData.taskLocationLongitude)&dev=0&style=2"
                let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                UIApplication.shared.openURL(URL.init(string: escapedString!)!)
            }
            alertController.addAction(gaodeAction)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(appleAction)
        self.currentViewController().present(alertController, animated: true, completion: nil)
        
    }
    
    func goToSystemMap(){
        let toLocation1 = CLLocationCoordinate2D(latitude: self.workData.taskLocationLatitude, longitude: self.workData.taskLocationLongitude)
        let currentLocation = MKMapItem.forCurrentLocation()
        let toLocation = MKMapItem.init(placemark: MKPlacemark.init(coordinate: toLocation1, addressDictionary: nil))
        MKMapItem.openMaps(with: [currentLocation, toLocation],launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey:true])
    }
    
}
