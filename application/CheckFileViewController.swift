//
//  CheckFileViewController.swift
//  application
//
//  Created by Anson on 2020/7/11.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit

class CheckFileViewController: PGBaseViewController {

    var fileName:String!
    var fileUrl:String!
      
      lazy var webView: UIWebView = {
          let view = UIWebView()
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
        taskProvider.request(.checkFile(fileUrl: Config.baseURL.absoluteString + self.fileUrl)){ result in
              switch result {
              case .success:
                let localLocation: URL = DefaultDownloadDir.appendingPathComponent(self.fileName)
                  self.showFile(url: localLocation)
              case let .failure(error):
                  print(error)
                  break
              }
          }
      }
      
      private func showFile(url:URL){
          self.webView.loadRequest(URLRequest.init(url: url))
      }

}
