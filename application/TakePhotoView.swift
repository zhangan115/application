//
//  TakePhotoView.swift
//  application
//
//  Created by Anson on 2020/7/6.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class TakePhotoView: UIView {

    lazy var titleLable:UILabel = {
        let view = UILabel()
        view.textColor = UIColor(hexString: "#454545")
        view.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(view)
        return view
    }()
    
    lazy var takePhotoButton :UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: ""), for: .normal)
        view.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        self.addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
         super.init(frame: frame)
     }
     
     override func layoutSubviews() {
         super.layoutSubviews()
        titleLable.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(12)
        }
        takePhotoButton.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(self.titleLable.snp.bottom).offset(8)
            make.width.height.equalTo(50)
        }
     }
     
     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    @objc func takePhoto(){
        
    }
}
