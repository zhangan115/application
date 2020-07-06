//
//  WorkBeginController.swift
//  application
//
//  Created by Anson on 2020/7/6.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
class WorkBeginController: UIViewController {
    
    var workModel:WorkModel!
    var disposeBag = DisposeBag()
    
    lazy var noteLabel : UILabel = {
        let view = UILabel()
        view.textColor = UIColor(hexString: "#FF7013")
        view.font = UIFont.systemFont(ofSize: 13)
        view.text = "*注：为保障审核成功率，请按照规定上传照片；照片提交后，不可更改，请谨慎选择"
        self.view.addSubview(view)
        return view
    }()
    
    lazy var startButton:UIButton = {
        let view = UIButton()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        view.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        view.setTitleColor(UIColor(hexString: "#F6F6F6"), for: .disabled)
        view.setBackgroundColor(UIColor(hexString: "#FFCC00")!, forState: .normal)
        view.setBackgroundColor(UIColor(hexString: "#CCCCCC")!, forState: .disabled)
        view.isEnabled = false
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "开始前资料上传"
        if self.workModel.taskType == WorkType.WORK_TYPE_ROUT.rawValue {
            startButton.setTitle("开始巡检", for: .normal)
        }else{
            startButton.setTitle("开始作业", for: .normal)
        }
        startButton.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(44)
        }
    }
    
    @objc func startAction(){
        
    }
    
}
