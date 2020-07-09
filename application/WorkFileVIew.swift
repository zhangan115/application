//
//  WorkFileVIew.swift
//  application
//
//  Created by sitech on 2020/7/7.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class WorkFileVIew: UIView {
    
    lazy var icon : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "icon_word")
        self.addSubview(view)
        return view
    }()
    
    var callback:((WorkFileVIew)->())?
    
    lazy var label : UILabel = {
        let view = UILabel()
        view.textColor = UIColor(hexString: "#333333")
        view.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(view)
        return view
    }()
    
    lazy var delectButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "photo_icon_close"), for: .normal)
        button.addTarget(self, action: #selector(delectAction), for: .touchUpInside)
        self.addSubview(button)
        return button
    }()
    
    lazy var arrow : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "work_detail_icon_next")
        self.addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        icon.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(0)
            make.width.height.equalTo(27)
        }
        label.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.icon.snp.right).offset(8)
            make.right.equalTo(self.delectButton.snp.left).offset(-8)
        }
        arrow.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
        }
        delectButton.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.arrow.snp.left).offset(-12)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(name:String){
        label.text = name
    }
    
    @objc func delectAction(){
        print("===")
        callback?(self)
    }
    
}
