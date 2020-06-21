//
//  NumVerifyView.swift
//  application
//
//  Created by Anson on 2020/6/21.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class NumVerifyView: UIView {
    
    lazy var bg1View : UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor(hexString: "#F5F4F1")
        self.addSubview(view)
        return view
    }()
    
    lazy var bg2View : UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 11
        self.bg1View.addSubview(view)
        return view
    }()
    
    lazy var label : UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15)
        self.bg2View.addSubview(view)
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bg1View.snp.updateConstraints{(make)in
            make.left.right.bottom.top.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        bg2View.snp.updateConstraints{(make)in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(22)
        }
        label.snp.updateConstraints{(make)in
             make.centerX.centerY.equalToSuperview()
        }
    }
    
    func setData(num:Int){
        label.text = num.toString
        if let user = UserModel.unarchiver() {
            if num == 1 {
                label.textColor = UIColor(hexString: "#454545")
                bg2View.backgroundColor = UIColor(hexString: "#FFCC00")
            }else if num == 2 {
                if user.certificationType! == 0 {
                    label.textColor = UIColor(hexString: "#333333")
                    bg2View.backgroundColor = UIColor(hexString: "#E1E1E1")
                    label.alpha = 0.32
                }else{
                    label.textColor = UIColor(hexString: "#454545")
                    bg2View.backgroundColor = UIColor(hexString: "#FFCC00")
                }
            }else if num == 3 {
                label.textColor = UIColor(hexString: "#333333")
                bg2View.backgroundColor = UIColor(hexString: "#E1E1E1")
                label.alpha = 0.32
            }
        }
    }
}
