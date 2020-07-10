//
//  WorkEndController.swift
//  application
//
//  Created by sitech on 2020/7/10.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
class WorkEndController: PGBaseViewController {
    
    var workModel:WorkModel!
    var disposeBag = DisposeBag()
    let MAX_STARWORDS_LENGTH = 256
    @IBOutlet var button:UIButton!
    @IBOutlet var textInput:PlaceholderTextView!
    @IBOutlet var textCount:UILabel!
    @IBOutlet var label1:UILabel!
    var stopReson:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "工单终止"
        self.view.backgroundColor = ColorConstants.tableViewBackground
        textInput.layer.masksToBounds = true
        textInput.layer.cornerRadius = 4
        textInput.placeholder = "请输入工单终止原因"
        textInput.placeholderColor = UIColor(hexString: "#BBBBBB")!
        textInput.placeholderFont = UIFont.systemFont(ofSize: 14)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4
        button.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        button.setTitleColor(UIColor(hexString: "#F6F6F6"), for: .disabled)
        button.setBackgroundColor(UIColor(hexString: "#FFCC00")!, forState: .normal)
        button.setBackgroundColor(UIColor(hexString: "#CCCCCC")!, forState: .disabled)
        button.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(textViewEditChanged(sender:)), name: UITextView.textDidChangeNotification, object: nil)
        if self.workModel.isTerminated {
            self.stopReson = self.workModel.terminateReason
        }
        if stopReson != nil && stopReson!.count > 0 {
            textInput.text = self.stopReson!
            textInput.isEditable = false
            self.button.isHidden = true
            textCount.isHidden = true
            label1.isHidden = true
        }
    }
    
    @IBAction func buttonAction(_ sender:UIButton){
        taskProvider.rxRequest(.terminateTask(taskId: workModel.taskId,terminateReason:textInput.text))
            .subscribe(onSuccess: { [weak self](json) in
                self?.view.showHUD("申请成功", completion: {
                    self?.popVC()
                })
            }) {[weak self] (_) in
                self?.view.toast("提交失败")
        }.disposed(by: self.disposeBag)
    }
    
    
    
    @objc func textViewEditChanged(sender:NSNotification) {
        let textVStr = textInput.text as NSString
        if (textVStr.length >= MAX_STARWORDS_LENGTH) {
            let str = textVStr.substring(to: MAX_STARWORDS_LENGTH)
            textInput.text = str
        }
        self.button.isEnabled = self.textInput.text.count > 0
        textCount.text = (MAX_STARWORDS_LENGTH - textInput.text.count).toString
    }
    
}
