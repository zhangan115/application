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
        view.backgroundColor = UIColor(hexString: "#F5F4F1")
        self.addSubview(view)
        return view
    }()
    
    lazy var bg2View : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#E1E1E1")
        self.addSubview(view)
        return view
    }()
    
    lazy var label : UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(view)
        return view
    }()
    
    
    
    func setData(num:Int){
        
    }
    
}
