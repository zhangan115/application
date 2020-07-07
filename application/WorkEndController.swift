//
//  WorkEndController.swift
//  application
//
//  Created by Anson on 2020/7/6.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import RxSwift
class WorkEndController: PGBaseViewController {
    
    var workModel:WorkModel!
     var disposeBag = DisposeBag()
     var callback:((WorkModel)->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "完成后资料上传"
         self.view.backgroundColor = ColorConstants.tableViewBackground
    }
    

}
