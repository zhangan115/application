//
//  WebViewController.swift
//  application
//
//  Created by sitech on 2020/6/15.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import SnapKit
class WebViewController: PGBaseViewController {
    
    lazy var webView : UIWebView = {
        let web = UIWebView()
        web.scalesPageToFit = true
        self.view.addSubview(web)
        return web
    }()
    
    lazy var buttonUiView : UIView={
        let view = UIView()
        view.backgroundColor = UIColor.white
        self.view.addSubview(view)
        return view
    }()
    
    lazy var verifyButton : UIButton = {
        let button = UIButton()
        button.setBackgroundColor(UIColor(hexString: "#FFCC00")!, forState: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(toUserIdentify), for: .touchUpInside)
        button.setTitle("成为电工", for: .normal)
        button.setTitleColor(UIColor(hexString: "#333333")!, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.buttonUiView.addSubview(button)
        return button
    }()
    
    var titleStr = ""
    var url = ""
    var showButton = false
    
    @objc func toUserIdentify(){
        let controller = UserIdentityController()
        self.pushVC(controller)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.titleStr
        let user = UserModel.unarchiver()
        if let user = user {
            if url == Config.url_basicKnowledge || url == Config.url_becomeSharingElectrician {
                if user.certificationType == 0 {
                    showButton = true
                }
            }
        }
        buttonUiView.snp.updateConstraints{(make)in
            make.left.right.bottom.equalToSuperview()
            if showButton {
                make.height.equalTo(60)
            }else{
               make.height.equalTo(0)
            }
        }
        verifyButton.snp.updateConstraints{(make)in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        webView.snp.updateConstraints{(make)in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(self.buttonUiView.snp.top)
        }
        let fullUrl = Config.baseURL.absoluteString + url
        let request = URLRequest(url: URL(string:fullUrl)!)
        webView.loadRequest(request)
    }
    
}
