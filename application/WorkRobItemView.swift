//
//  WorkRobItemView.swift
//  application
//
//  Created by sitech on 2020/6/23.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkRobItemView: UIView {
    
    var currentModel:WorkModel? = nil
    
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
        view.text = "高科集团西安高新区热力有限公司"
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
        view.text = "计划开始时间："
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor(hexString: "#454545")
        self.tiemLayoutView.addSubview(view)
        return view
    }()
    
    lazy var icon5View :UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named:"home_card_icon_time")
        self.tiemLayoutView.addSubview(view)
        return view
    }()
    
    lazy var textName5 :UILabel = {
        let view = UILabel()
        view.text = "计划结束时间："
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor(hexString: "#454545")
        self.tiemLayoutView.addSubview(view)
        return view
    }()
    
    lazy var raibWorkBtn: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(raibWork), for: .touchUpInside)
        button.setTitle("抢单", for: .normal)
        button.setTitleColor(UIColor(hexString: "#454545"), for: .normal)
        button.setBackgroundColor(UIColor(hexString: "#FFCC00")!, forState: .normal)
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 2
        self.tiemLayoutView.addSubview(button)
        return button
    }()
    
    func setData(workData:WorkModel){
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
        if workData.distance < 3 {
            textName7.text = "<3km"
        } else if workData.distance < 6 && workData.distance >= 3{
            textName7.text = "<6km"
        } else if workData.distance < 9 && workData.distance >= 6{
            textName7.text = "<9km"
        } else {
            textName7.text = ">9km"
        }
        let requiredSocLevel = workData.requiredSocLevel
        let requiredEpqcLevel = workData.requiredEpqcLevel
        var str = "资格要求：无要求"
        if (workData.taskType != WorkType.WORK_TYPE_BASE.hashValue){
            if (requiredSocLevel==nil && requiredEpqcLevel == nil){
                str = "资格要求：技术电工"
            }else if (requiredSocLevel != nil && requiredEpqcLevel == nil){
                str = "资格要求：" + (getSpecialString(level:requiredSocLevel!) ?? "")
            }else if (requiredSocLevel == nil && requiredEpqcLevel != nil){
                str = "资格要求：" + (getVocationalString(level: requiredEpqcLevel!) ?? "")
            }else{
                str = "资格要求：" + (getSpecialString(level:requiredSocLevel!) ?? "") + " " + (getVocationalString(level: requiredEpqcLevel!) ?? "")
            }
        }
        textName6.text = str
        textName3.text = workData.taskName
        textName4.text = "计划开始时间：" + dateString(millisecond: TimeInterval(workData.planStartTime), dateFormat: "yyyy-MM-dd HH:mm")
        textName5.text = "计划结束时间：" + dateString(millisecond: TimeInterval(workData.planEndTime), dateFormat: "yyyy-MM-dd HH:mm")
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
            make.top.equalToSuperview().offset(-2)
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
        icon3View.snp.updateConstraints{(make)in
            make.left.equalTo(self.equipmentView.snp.right).offset(5)
            make.height.width.equalTo(14)
            make.top.equalTo(self.icon6View.snp.bottom).offset(10)
        }
        textName3.snp.updateConstraints{(make)in
            make.left.equalTo(self.icon6View.snp.right).offset(4)
            make.centerY.equalTo(icon3View)
        }
        tiemLayoutView.snp.updateConstraints{(make)in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(70)
        }
        icon4View.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(16)
        }
        textName4.snp.updateConstraints{(make)in
            make.left.equalTo(self.icon4View.snp.right).offset(4)
            make.centerY.equalTo(icon4View)
        }
        icon5View.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-16)
        }
        textName5.snp.updateConstraints{(make)in
            make.left.equalTo(self.icon5View.snp.right).offset(4)
            make.centerY.equalTo(icon5View)
        }
        raibWorkBtn.snp.updateConstraints{(make)in
            make.right.equalToSuperview().offset(-12)
            make.width.equalTo(60)
            make.height.equalTo(32)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func raibWork(){
        
    }
    
}
