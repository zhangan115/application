//
//  WorkProgressItemCell.swift
//  application
//
//  Created by sitech on 2020/7/7.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
import PGActionSheet
import RealmSwift
class WorkProgressItemCell: UITableViewCell {
    
    @IBOutlet var bgView1 : UIView! // 背景
    var workModel:WorkModel!
    var viewList:[TakePhotoView] = []
    var callback:((WorkModel)->())?
    var updateCallBack:(()->())?
    var addFileCallBack:((String)->())?
    var delectFileCallBack:((Int)->())?
    var subCallBack:(()->())?
    var fileList:[String] = []
    var fileUrlList : [String]  = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.white
        bgView1.layer.masksToBounds = true
        bgView1.layer.cornerRadius = 4
    }
    
    func setModel(workModel:WorkModel){
        self.workModel = workModel
        self.bgView1.removeSubviews()
        if let before = workModel.beforeStartFile {
            if before.nodePicList != nil && !before.nodePicList.isEmpty{
                self.viewList.removeAll()
                for (index,item) in before.nodePicList.enumerated() {
                    let view = TakePhotoView()
                    view.setData(picNote: item)
                    view.titleLable.text = item.picName
                    view.tag = index
                    view.canTakePhoto = false
                    self.viewList.append(view)
                }
                if !viewList.isEmpty {
                    self.bgView1.addSubviews(self.viewList)
                    for (index,view) in viewList.enumerated() {
                        view.frame = CGRect(x: 0, y: CGFloat(0 + index * 90), w: screenWidth, h: 90)
                    }
                }
            }
        }
    }
}
