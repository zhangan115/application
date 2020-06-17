//
//  GuideViewController.swift
//  application
//
//  Created by sitech on 2020/6/11.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
import SnapKit

class GuideViewController: UIViewController {
    
    @IBOutlet weak var skipButton:UIButton!
    @IBOutlet weak var sureButton:UIButton!
    @IBOutlet weak var scrollView:UIScrollView!
    var image:UIImageView!
    @IBOutlet weak var uiView1:UIView!
    @IBOutlet weak var uiView2:UIView!
    @IBOutlet weak var uiView3:UIView!
    
    @IBOutlet weak var width1:NSLayoutConstraint!
    @IBOutlet weak var width2: NSLayoutConstraint!
    @IBOutlet weak var width3: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        sureButton.layer.masksToBounds = true
        sureButton.layer.cornerRadius = 4
        sureButton.isHidden = true
        let frame = self.view.bounds
        print(frame.size.width)
        width1.constant = frame.size.width
        width2.constant = frame.size.width
        width3.constant = frame.size.width
        image = UIImageView(image: UIImage(named: "carousel_img_1"))
        self.view.addSubview(image)
        image.snp.updateConstraints{(make)in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-53)
        }
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.contentOffset = CGPoint.zero
        scrollView.delegate = self
        //添加界面到ScrollView
        let image1 = UIImageView(image: UIImage(named: "guide_img1"))
        let label1_1 = UILabel()
        label1_1.text = "作业安心"
        label1_1.textColor = UIColor (hexString:"#333333")
        label1_1.font = UIFont.systemFont(ofSize: 25)
        let label1_2 = UILabel()
        label1_2.text = "学习培训，规范操作流程，保护人身安全"
        label1_2.textColor = UIColor (hexString:"#888888")
        label1_2.font = UIFont.systemFont(ofSize: 16)
        uiView1.addSubview(image1)
        uiView1.addSubview(label1_1)
        uiView1.addSubview(label1_2)
        image1.snp.updateConstraints{(make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        label1_1.snp.updateConstraints{(make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(image1.snp.bottom).offset(70)
        }
        label1_2.snp.updateConstraints{(make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(label1_1.snp.bottom).offset(10)
        }
        //view2
        let image2 = UIImageView(image: UIImage(named: "guide_img2"))
        let label2_1 = UILabel()
        label2_1.text = "选择随心"
        label2_1.textColor = UIColor (hexString:"#333333")
        label2_1.font = UIFont.systemFont(ofSize: 25)
        let label2_2 = UILabel()
        label2_2.text = "电气设备、充电运维，随你选择"
        label2_2.textColor = UIColor (hexString:"#888888")
        label2_2.font = UIFont.systemFont(ofSize: 16)
        uiView2.addSubview(image2)
        uiView2.addSubview(label2_1)
        uiView2.addSubview(label2_2)
        image2.snp.updateConstraints{(make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        label2_1.snp.updateConstraints{(make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(image2.snp.bottom).offset(70)
        }
        label2_2.snp.updateConstraints{(make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(label2_1.snp.bottom).offset(10)
        }
        //view3
        let image3 = UIImageView(image: UIImage(named: "guide_img3"))
        let label3_1 = UILabel()
        label3_1.text = "财务由心"
        label3_1.textColor = UIColor (hexString:"#333333")
        label3_1.font = UIFont.systemFont(ofSize: 25)
        let label3_2 = UILabel()
        label3_2.text = "工单完成越多，佣金越高"
        label3_2.textColor = UIColor (hexString:"#888888")
        label3_2.font = UIFont.systemFont(ofSize: 16)
        uiView3.addSubview(image3)
        uiView3.addSubview(label3_1)
        uiView3.addSubview(label3_2)
        image3.snp.updateConstraints{(make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        label3_1.snp.updateConstraints{(make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(image3.snp.bottom).offset(70)
        }
        label3_2.snp.updateConstraints{(make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(label3_1.snp.bottom).offset(10)
        }
        scrollView.delaysContentTouches = false
    }
    
    private func showLoginView(){
        UserDefaults.standard.set(true, forKey: kIsGuide)
        let nav = PGBaseNavigationController.init(rootViewController: UserLoginViewController())
        UIApplication.shared.keyWindow?.rootViewController = nav
    }
    
    @IBAction func showLogin(_ sender: UIButton){
        showLoginView()
    }
    
    @IBAction func skip(_ sender: UIButton){
        showLoginView()
    }
    
}

extension GuideViewController :UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let currentPage = Int(offset.x / view.bounds.width)
        skipButton.isHidden = (currentPage == 2)
        sureButton.isHidden = (currentPage != 2)
        if currentPage == 0 {
            image.image = UIImage(named: "carousel_img_1")
            image.isHidden = false
        }else if currentPage == 1 {
            image.image = UIImage(named: "carousel_img_2")
            image.isHidden = false
        }else{
            image.isHidden = true
        }
    }
}

class MyUIScrollView: UIScrollView {
    override func touchesShouldCancel(in view: UIView) -> Bool {
        return true
    }
}
