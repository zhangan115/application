//
//  MainUserVerifyController.swift
//  application
//
//  Created by Anson on 2020/6/21.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class MainUserVerifyController: UIViewController {
    
    var currentVerifyType = 0
    
    lazy var bgView : UIView = {
        let view = UIView()
        self.view.addSubview(view)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
