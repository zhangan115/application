//
//  PGConstants.swift
//  edetection
//
//  Created by piggybear on 02/05/2017.
//  Copyright © 2017 piggybear. All rights reserved.
//

import Foundation
import UIKit

struct Config {
    #if DEBUG
    //http://172.16.40.240:8081
    static let baseURL: URL = URL(string:"http://172.16.40.240:8081")!
    #else
    static let baseURL: URL = URL(string:"http://114.215.94.141:8085")!
    #endif
    static let loginUrl: String = "login"
    
    static let APP_VERSION = 1
    
    static let url_useAgreement = "/static/html/useAgreement.html"
    static let url_basicKnowledge = "/static/html/basicKnowledge.html"
    static let url_becomeSharingElectrician = "/static/html/becomeSharingElectrician.html"
    static let url_serviceSpecification = "/static/html/serviceSpecification.html"
    static let url_safetyManual = "/static/html/safetyManual.html"
    
}
//颜色常量
struct ColorConstants {
    //背景色
    static let tableViewBackground = UIColor(hexString: "#F6F6F6")
}
//个推key
struct GtConfig {
    let appId:String = "dpjmTCJBp78M4Fy0E7uNK5"
    let appKey:String = "Y4PG6LMEJx6DhMrXf2QtW5"
    let appSecret:String = "llYuybQ9yfAtln7HjQhhh"
    static var clientId: String!
}

//虚线展示
func drawDashLine(lineView : UIView,lineLength : Int ,lineSpacing : Int,lineColor : UIColor){
    let shapeLayer = CAShapeLayer()
    shapeLayer.bounds = lineView.bounds
    shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
    shapeLayer.strokeColor = lineColor.cgColor
    shapeLayer.lineWidth = lineView.frame.size.height
    shapeLayer.lineJoin = CAShapeLayerLineJoin.round
    shapeLayer.lineDashPattern = [NSNumber(value: lineLength),NSNumber(value: lineSpacing)]
    let path = CGMutablePath()
    path.move(to: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: lineView.frame.size.width, y: 0))
    shapeLayer.path = path
    lineView.layer.addSublayer(shapeLayer)
}

//手机号码匹配
func isPhoneNumber(phoneNumber:String) -> Bool {
    if phoneNumber.count == 0 {
        return false
    }
    let mobile = "^(1[3-9])\\d{9}$"
    let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
    if regexMobile.evaluate(with: phoneNumber) == true {
        return true
    }else{
        return false
    }
}

// 密码匹配
func isPassWord(passWord:String) -> Bool{
    if passWord.count == 0 {
        return false
    }
    let mobile = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$"
    let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
    if regexMobile.evaluate(with: passWord) == true {
        return true
    }else{
        return false
    }
}

func checkIdentityCardNumber(_ number: String) -> Bool {
    //判断位数
    if number.count != 15 && number.count != 18 {
        return false
    }
    var carid = number
    
    var lSumQT = 0
    
    //加权因子
    let R = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
    
    //校验码
    let sChecker: [Int8] = [49,48,88, 57, 56, 55, 54, 53, 52, 51, 50]
    
    //将15位身份证号转换成18位
    let mString = NSMutableString.init(string: number)
    
    if number.count == 15 {
        mString.insert("19", at: 6)
        var p = 0
        let pid = mString.utf8String
        for i in 0...16 {
            let t = Int(pid![i])
            p += (t - 48) * R[i]
        }
        let o = p % 11
        let stringContent = NSString(format: "%c", sChecker[o])
        mString.insert(stringContent as String, at: mString.length)
        carid = mString as String
    }
    
    let cStartIndex = carid.startIndex
    let cEndIndex = carid.endIndex
    let index = carid.index(cStartIndex, offsetBy: 2)
    //判断地区码
    let sProvince = String(carid[cStartIndex..<index])
    if (!areaCodeAt(sProvince)) {
        return false
    }
    //判断年月日是否有效
    //年份
    let yStartIndex = carid.index(cStartIndex, offsetBy: 6)
    let yEndIndex = carid.index(yStartIndex, offsetBy: 4)
    let strYear = Int(carid[yStartIndex..<yEndIndex])
    
    //月份
    let mStartIndex = carid.index(yEndIndex, offsetBy: 0)
    let mEndIndex = carid.index(mStartIndex, offsetBy: 2)
    let strMonth = Int(carid[mStartIndex..<mEndIndex])
    
    //日
    let dStartIndex = carid.index(mEndIndex, offsetBy: 0)
    let dEndIndex = carid.index(dStartIndex, offsetBy: 2)
    let strDay = Int(carid[dStartIndex..<dEndIndex])
    
    let localZone = NSTimeZone.local
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    dateFormatter.timeZone = localZone
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let date = dateFormatter.date(from: "\(String(format: "%02d",strYear!))-\(String(format: "%02d",strMonth!))-\(String(format: "%02d",strDay!)) 12:01:01")
    
    if date == nil {
        return false
    }
    let paperId = carid.utf8CString
    //检验长度
    if 18 != carid.count {
        return false
    }
    //校验数字
    func isDigit(c: Int) -> Bool {
        return 0 <= c && c <= 9
    }
    for i in 0...18 {
        let id = Int(paperId[i])
        if isDigit(c: id) && !(88 == id || 120 == id) && 17 == i {
            return false
        }
    }
    //验证最末的校验码
    for i in 0...16 {
        let v = Int(paperId[i])
        lSumQT += (v - 48) * R[i]
    }
    if sChecker[lSumQT%11] != paperId[17] {
        return false
    }
    return true
}

func areaCodeAt(_ code: String) -> Bool {
    var dic: [String: String] = [:]
    dic["11"] = "北京"
    dic["12"] = "天津"
    dic["13"] = "河北"
    dic["14"] = "山西"
    dic["15"] = "内蒙古"
    dic["21"] = "辽宁"
    dic["22"] = "吉林"
    dic["23"] = "黑龙江"
    dic["31"] = "上海"
    dic["32"] = "江苏"
    dic["33"] = "浙江"
    dic["34"] = "安徽"
    dic["35"] = "福建"
    dic["36"] = "江西"
    dic["37"] = "山东"
    dic["41"] = "河南"
    dic["42"] = "湖北"
    dic["43"] = "湖南"
    dic["44"] = "广东"
    dic["45"] = "广西"
    dic["46"] = "海南"
    dic["50"] = "重庆"
    dic["51"] = "四川"
    dic["52"] = "贵州"
    dic["53"] = "云南"
    dic["54"] = "西藏"
    dic["61"] = "陕西"
    dic["62"] = "甘肃"
    dic["63"] = "青海"
    dic["64"] = "宁夏"
    dic["65"] = "新疆"
    dic["71"] = "台湾"
    dic["81"] = "香港"
    dic["82"] = "澳门"
    dic["91"] = "国外"
    if (dic[code] == nil) {
        return false
    }
    return true
}

// 是否为2-4位的汉字
func isChinese(sring:String) -> Bool{
    if sring.count == 0 {
        return false
    }
    let mobile = "[\u{4e00}-\u{9fa5}]{2,4}+$"
    let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
    if regexMobile.evaluate(with: sring) == true {
        return true
    }else{
        return false
    }
}

func callPhoneTelpro(phone : String){
    let  phoneUrlStr = "telprompt://"+phone
    if UIApplication.shared.canOpenURL(URL(string: phoneUrlStr)!){
        UIApplication.shared.openURL(URL(string: phoneUrlStr)!)
    }
}

func getTaskNeedSkill(_ model:WorkModel) -> String{
    let requiredSocLevel = model.requiredSocLevel
    let requiredEpqcLevel = model.requiredEpqcLevel
    var str = "无要求"
    if (model.taskType != WorkType.WORK_TYPE_BASE.hashValue){
        if (requiredSocLevel == nil && requiredEpqcLevel == nil){
            str = "技术电工"
        }else if (requiredSocLevel != 0 && requiredEpqcLevel == 0){
            str = (getSpecialString(level:requiredSocLevel!) ?? "")
        }else if (requiredSocLevel == 0 && requiredEpqcLevel != 0){
            str = (getVocationalString(level: requiredEpqcLevel!) ?? "")
        }else if (requiredSocLevel != 0 && requiredEpqcLevel != 0){
            str = (getSpecialString(level:requiredSocLevel!) ?? "") + "\n" + (getVocationalString(level: requiredEpqcLevel!) ?? "")
        }
    }
    return str
}

func getSpecialString(level: Int)-> String? {
    if (level == WorkGrade.SPECIAL_OPERATION_GRADE_LOW.rawValue) {
        return "特种作业证-低压"
    } else if (level == WorkGrade.SPECIAL_OPERATION_GRADE_HIGH.rawValue) {
        return "特种作业证-高压"
    }
    return nil
}

func getVocationalString(level: Int)-> String? {
    switch level {
    case WorkGrade.VOCATIONAL_QUALIFICATION_GRADE_FIFTH.rawValue:
        return "职业资格证-一级"
    case WorkGrade.VOCATIONAL_QUALIFICATION_GRADE_FOURTH.rawValue:
        return "职业资格证-二级"
    case WorkGrade.VOCATIONAL_QUALIFICATION_GRADE_THIRD.rawValue:
        return "职业资格证-三级"
    case WorkGrade.VOCATIONAL_QUALIFICATION_GRADE_SECOND.rawValue:
        return "职业资格证-四级"
    case WorkGrade.VOCATIONAL_QUALIFICATION_GRADE_FIRST.rawValue:
        return "职业资格证-五级"
    default:
        return nil
    }
}


func getDistance(_ workModel:WorkModel)-> String{
    let latitude =  UserDefaults.standard.double(forKey: KLocationLat)
    let longitude =  UserDefaults.standard.double(forKey: KLocationLon)
    let currentLocation = CLLocation(latitude: latitude, longitude: longitude)
    let latitude2 = workModel.taskLocationLatitude ?? 0
    let longitude2 = workModel.taskLocationLongitude ?? 0
    let abs = currentLocation.distance(from: CLLocation(latitude: latitude2, longitude: longitude2))/1000
    if abs < 3 {
        return "<3km"
    } else if abs < 6 && abs >= 3{
        return "<6km"
    }  else if abs < 9 && abs >= 6{
        return "<9km"
    }
    return ">9km"
}
