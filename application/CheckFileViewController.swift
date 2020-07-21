//
//  CheckFileViewController.swift
//  application
//
//  Created by Anson on 2020/7/11.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import WebKit
class CheckFileViewController: PGBaseViewController {

    var fileName:String!
    var fileUrl:String!
      
      lazy var webView: WKWebView = {
          let view = WKWebView()
          view.backgroundColor = UIColor.clear
          self.view.addSubview(view)
          return view
      }()
      
      override func viewDidLoad() {
          super.viewDidLoad()
          self.title = self.fileName
          self.view.addSubview(webView)
          self.webView.snp.updateConstraints{(make) in
              make.left.right.top.bottom.equalToSuperview()
          }
        let url = Config.baseURL.absoluteString + self.fileUrl
        showFile(url: URL.init(string: url)!)
      }
      
      private func showFile(url:URL){
          self.webView.load(URLRequest(url: url))
      }

}
