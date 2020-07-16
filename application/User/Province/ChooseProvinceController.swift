//
//  ChooseProvinceController.swift
//  application
//
//  Created by sitech on 2020/7/16.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChooseProvinceController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet var pickView1:UIPickerView!
    
    var provinceList:[Province] = []
    var callback:((String?)->())?
    var currentContent:String? = nil
    
    var text1:String = ""
    var text2:String = ""
    var text3:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickView1.delegate = self
        pickView1.dataSource = self
        let path = Bundle.main.path(forResource: "province.json", ofType: nil)
        if let jsonPath = path {
            do {
                let jsonStr = try String(contentsOfFile: jsonPath )
                let json = JSON(parseJSON: jsonStr).arrayValue
                
                if !json.isEmpty {
                    for item in json {
                        provinceList.append(Province(fromJson: item))
                    }
                }
            }catch {
                print(error)
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.provinceList.count
        }else if component == 1 {
            return self.provinceList[pickerView.selectedRow(inComponent: 0)].city.count
        }else if component == 2 {
            return self.provinceList[pickerView.selectedRow(inComponent: 0)].city[pickerView.selectedRow(inComponent: 1)].area.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            text1 = self.provinceList[row].name
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
        }else if component == 1 {
            text2 = self.provinceList[pickerView.selectedRow(inComponent: 0)].city[row].name
            pickerView.reloadComponent(2)
        }
    }
    
    //设置PickerView选项内容(delegate协议)
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return self.provinceList[row].name
        }else if component == 1 {
            return self.provinceList[pickerView.selectedRow(inComponent: 0)].city[row].name
        }else if component == 2 {
            return self.provinceList[pickerView.selectedRow(inComponent: 0)].city[pickerView.selectedRow(inComponent: 1)].area[row]
        }
        return String(row)+"-"+String(component)
    }
    //设置列宽
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return screenWidth / 3
    }
    //设置行高
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    @IBAction func cancel(){
        self.dismissVC(completion: nil)
    }
    
    @IBAction func sure(){
        text1 = self.provinceList[pickView1.selectedRow(inComponent: 0)].name
        text2 = self.provinceList[pickView1.selectedRow(inComponent: 0)].city[pickView1.selectedRow(inComponent: 1)].name
        text3 = self.provinceList[pickView1.selectedRow(inComponent: 0)].city[pickView1.selectedRow(inComponent: 1)].area[pickView1.selectedRow(inComponent: 2)]
        if ("北京市" == text1 || "上海市" == text1 || "天津市" == text1 || "重庆市" == text1 || "澳门" == text1 || "香港" == text1) {
            self.currentContent = text1 + " " + text3
        } else {
            self.currentContent = text1 + " " + text2 + " " + text3
        }
        self.callback?(currentContent)
        self.dismissVC(completion: nil)
    }
    
}
