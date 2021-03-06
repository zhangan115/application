//
//  CacheCleanTool.swift
//  application
//
//  Created by sitech on 2020/7/13.
//  Copyright © 2020 Sitop. All rights reserved.
//

import Foundation

class CacheCleanTool: NSObject {
    
    class func fileSizeOfCachingg(completionHandler:@escaping (_ size: String)->()) {
        print("1")
        //开启子线程
        DispatchQueue.global().async {
            print("6")
            // 取出cache文件夹目录 缓存文件都在这个目录下
            let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
            //缓存目录路径
            // 取出文件夹下所有文件数组
            let fileArr = FileManager.default.subpaths(atPath: cachePath!)
            //快速枚举出所有文件名 计算文件大小
            var size = 0
            for file in fileArr! {
                // 把文件名拼接到路径中
                let path = (cachePath! as NSString).appending("/\(file)")
                // 取出文件属性
                let floder = try! FileManager.default.attributesOfItem(atPath: path)
                // 用元组取出文件大小属性
                for (abc, bcd) in floder {
                    // 累加文件大小
                    if abc == FileAttributeKey.size {
                        size += (bcd as AnyObject).integerValue
                    }
                }
            }
            
            
            //回到主线程 执行闭包
            DispatchQueue.main.async(execute: {
                var str : String = ""
                var realSize : Int = size
                if realSize < 1024  {
                    str = str.appendingFormat("%dB", realSize)
                    str = "0M"
                }else if size > 1024  &&   size < 1024 *  1024  {
                    realSize = realSize / 1024
                    str = str.appendingFormat("%dKB", realSize)
                    str = "0M"
                }else if size > 1024 * 1024  &&   size < 1024 *  1024  * 1024  {
                    realSize = realSize / 1024 / 1024
                    str = str.appendingFormat("%dM", realSize)
                }
                completionHandler(str)
            })
        }
    }
    
    class  func clearCache() {
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        // 遍历删除
        for file in fileArr! {
            if file.contains("Snapshots") { continue}
            if file.contains("com.fix.task") { continue}
            let path = (cachePath! as NSString).appending("/\(file)")
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    
                }
            }
        }
    }
}
