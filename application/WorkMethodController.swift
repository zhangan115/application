//
//  WorkMethodController.swift
//  application
//
//  Created by sitech on 2020/7/10.
//  Copyright © 2020 Sitop. All rights reserved.
//

import UIKit
private var methodCell = "MethodCell"

class WorkMethodController: BaseTableViewController {
    
    var stringList = [
        ["充电枪","（基础）"],["充电枪","（技术）"],["电源控制器或继电器","（基础）"],["门禁行程开关","（基础）"],
        ["急停按钮","（技术）"],["绝缘系统","（技术）"],["浪涌保护器","（技术）"],["触摸屏","（技术）"],
        ["充电桩或车辆系统故障","（技术）"],["BMS（车辆端）","（技术）"],["读卡器","（技术）"],
        ["漏电保护器","（技术）"],["电源控制模块","（技术）"],["电度表","（技术）"],["BMS（充电桩端）","（技术）"],
        ["TCU模块","（技术）"],["软件系统","（技术）"]
    ]
    
    var qAList = [
        ["枪未插到位；","重新把枪插到位；","车辆问题；","去4S店检查车辆；"],
        ["信号网络不稳定，解锁失败；","交流桩车端锁枪：a、客户重新熄火锁车、试充、停止充电； b、联系4S店解决；","用户车辆问题；",
         "1、（交流桩车端锁枪都是车子的枪座电子锁锁枪，桩不控制锁枪）；\n" +
            "2、交流桩桩端锁枪：a、客户重新插回车端的枪，桩端的枪插到位，熄火、扫描充电、1分钟后正常停止，解锁成功； b、打开桩门，向上拉枪座上细线，方可解锁；\n" +
            "3、直流桩锁枪：每把直流枪的把手位置都有装置（顶针或拉线）解锁；\n" +
            "4、通用方法：按下紧急停止按钮，约5秒后解除紧急停止，尝试拔除充电枪；"],
        ["枪没有插到位；","重新把枪插到位；","在充电过程中，有人按下手柄上的按钮；",
         "正常停止充电后，再按手柄按钮把枪；其次加强监管，防止充电中有人有意按下；",
         "余额不足，停止充电；","充电前，保持余额充足；"],
        ["门未关好；","重新关好门，锁上；","微动行程开关线未插好或损坏；","检查微动行程开关的线是否插对，弹片状态是否正常；"],
        ["充电桩正常情况下被人为按下急停按钮，且按钮按下后一直没有恢复；","1、顺时针旋转急停按钮恢复正常；\n" +
            "2、替换法测试急停是否损坏，注意急停按钮接线带有220V电压，操作时务必断电！"],
        ["充电输出回路对地绝缘损坏；","重启充电机屏和车辆：现场潮湿可能会引起绝缘降低，如有条件打开机柜门通风；",
         "绝缘检测模块损坏或者误报；","检查充电机柜和充电桩中直流输出回路的绝缘情况，是否有明显接地点；检查绝缘检测模块是否损坏；"],
        ["接触器前端避雷器出现告警；","1、避雷器插接不到位，用力往里按压一下避雷器；\n" +
            "2、检查避雷器安装接触触点；查看玻璃窗口：“绿色”为正常；“红色”为异常，更换避雷器；"],
        ["TCU损坏；","TCU损坏，更换TCU；","TCU与显示屏之间TVI连接线松动；","重新拧紧TCU与显示屏之间TVI连接线；",
         "显示屏损坏；","显示屏损坏：更换显示屏；"],
        ["系统故障，系统延时或死机；","1、按下急停按钮，大约5秒钟后，再将急停按钮弹起；\n" +
            "2、若显示屏依然毫无反应，打开前门，断开空气开关，断电重启；"],
        ["BMS通讯故障；","1、充电过程中，充电桩与车辆的电池管理系统（BMS）是不断相互传递信息的，通信速率达到ms级别；\n" +
            "2、充电过程中，电池的状态受到车辆自身电池管理系统（BMS）监视，一旦异常，就会将信息传递到充电桩；\n" +
            "3、所以出现以上异常，基本可以判定为车辆自身问题，需要充电人员记下车牌号码备案记录；\n" +
            "4、此类情况，一般可以通过重启车辆或者搁置一段时间之后就可以继续充电了；"],
        ["读卡器不能识别卡片；","1、检查读卡器PCU之间的连接线是否正常连接；\n" +
            "2、如果连接正常，仍然无法识别卡片，则更换读卡器模块；"],
        ["充电桩内部塑壳断路器断开（充电桩内部过热导致的跳闸）；","合上开关，重启设备，如未能解决，则需要更换模块或主板；"],
        ["TCU与充电桩控制器之间的CAN总线接线松动；",
         "万用表检查TCU与充电控制器间CAN通讯线路是否连接异常，匹配电阻是否连接可靠，通信线屏蔽层是否有效接地；",
         "CAN总线抗干扰能力不佳或总线匹配电阻有问题；","替换法测试，若TCU损坏则进行更换；"],
        ["TCU与电表接线松动；","查看电表左上角是否有“电话”标识，若无，则说明电表未和TCU通讯成功，检查线路情况；",
         "电表故障；","替换法测试，若电表故障则需更换；"],
        ["电动汽车BMS系统故障；","多试充电几次；","车辆未获取充电桩提供的辅助电源；",
         "是否插好充电连接线缆、通讯线是否松动，屏蔽线是否接地，辅助电源是否故障，辅助电源接线是否松动；",
         "充电连接线未连接到位或通讯线松动；","通讯协议是否一致，不一致需要客户去4S店升级BMS；",
         "充电机和电动汽车通信协议不匹配；","仍无法充电反馈厂家现场解决；"],
        ["交流进线开关未合闸或者（42KW交流桩）急停被按，交流进线开关跳闸；","急停按钮顺时针旋转（处于弹出的状态），重新合上交流进线开关；","700/30-T型开关电源关闭或损坏；","打开700/30-T型开关电源的开关；若损坏，更换电源；","交流进线开关下端无电；","进线开关下端无电：检查低压配电箱或配电房，开关是否跳闸；"],
        ["SIM卡异常；","SIM卡是否锁卡或未激活：解卡或者激活、或更换SIM卡；","SIM卡与TCU接触不良；","重新取出SIM卡弄平整，再插入TCU；","APP、后台异常；","联系后台查询APP后台状态；","TCU损坏；","TCU损坏：更换TCU；","桩设备编码和档案不正确；","重新整理档案，设置设备编码；","站点信号太弱；","更换SIM卡供应商或站点安装信号放大器；"]
    ]
    
    override func viewDidLoad() {
        self.isLoadMore = false
        self.isRefresh = false
        super.viewDidLoad()
        self.title = "处理办法"
        self.tableView = UITableView.init(frame: self.view.frame, style: .grouped)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = ColorConstants.tableViewBackground
        self.tableView.sectionHeaderHeight = 0.01
        self.tableView.sectionFooterHeight = 0.01
        self.tableView.register(UINib(nibName: methodCell, bundle: nil), forCellReuseIdentifier: methodCell)
        initData()
    }
    
    private var dataList:[WorkMethod] = []
    
    private func initData(){
        for (index1,item1) in stringList.enumerated() {
            let bean = WorkMethod()
            bean.headerTitle = item1[0]
            bean.headerContent = item1[1]
            var qABeanList : [QAContent] = []
            for(index2,item2) in qAList[index1].enumerated() {
                let bean1 = QAContent()
                if index2 % 2 == 0 {
                    bean1.qA = "Q:"
                }else{
                    bean1.qA = "A:"
                }
                bean1.content = item2
                qABeanList.append(bean1)
            }
            bean.contentList = qABeanList
            dataList.append(bean)
        }
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList[section].contentList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: methodCell) as! MethodCell
        cell.label1.text = self.dataList[indexPath.section].contentList[indexPath.row].qA
        cell.label2.text = self.dataList[indexPath.section].contentList[indexPath.row].content
        return cell
    }
    
    override  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let identifier = "header"
        var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? WorkMethodHeaderView
        if view == nil {
            view = WorkMethodHeaderView(reuseIdentifier: identifier)
            let backgroundView = UIView()
            backgroundView.backgroundColor = ColorConstants.tableViewBackground
            view?.backgroundView = backgroundView
        }
        view?.setModel(isFirst: section == 0, model: self.dataList[section])
        return view
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        }
        return 38
    }
    
    
}
