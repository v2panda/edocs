//
//  NewsDALManager.swift
//  Demo_LiuAGeiOS
//
//  Created by Panda on 16/7/5.
//  Copyright © 2016年 v2panda. All rights reserved.
//

import UIKit

/// DAL : data access layer 数据访问层
class NewsDALManager: NSObject {
    
    // swift单例
    static let shareManager = NewsDALManager()
    
    /// 过期时间间隔 从缓存开始计时，单位秒 7天
    private let timeInterval: NSTimeInterval = 86400 * 7
    
    /**
     在退出到后台的时候，根据缓存时间自动清除过期的缓存数据
     */
    func clearCacheData() {
        // 计算过期时间
        let overDate = NSDate(timeIntervalSinceNow: -timeInterval)
    
        // 记录时间格式 2016-06-13 02:29:37
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let overString = df.stringFromDate(overDate)
        
        // 生产sql语句
        let sql = "DELETE FROM \(NEWS_LIST_HOME_TOP) WHERE createTime < '\(overString)';" +
            "DELETE FROM \(NEWS_LIST_HOME_LIST) WHERE createTime < '\(overString)';" +
            "DELETE FROM \(NEWS_LIST_OTHER_TOP) WHERE createTime < '\(overString)';" +
            "DELETE FROM \(NEWS_LIST_OTHER_LIST) WHERE createTime < '\(overString)';" +
            "DELETE FROM \(NEWS_CONTENT) WHERE createTime < '\(overString)';"
        
        SQLiteManager.shareManager.dbQueue.inDatabase { (db) -> Void in
            if db.executeStatements(sql) {
                //                print("清除缓存数据成功")
            }
        }
        
    }
}

// MARK: - 资讯列表数据管理
extension NewsDALManager {
    /**
     清除资讯列表缓存
     
     - parameter classid: 要清除的分类id
     */
    func cleanCache(classid: Int) {
        var sql = ""
        if classid == 0 {
            sql = "DELETE FROM \(NEWS_LIST_HOME_TOP); DELETE FROM \(NEWS_LIST_HOME_LIST);"
        } else {
            sql = "DELETE FROM \(NEWS_LIST_OTHER_TOP) WHERE classid=\(classid); DELETE FROM \(NEWS_LIST_OTHER_LIST) WHERE classid=\(classid);"
        }
        
        SQLiteManager.shareManager.dbQueue.inDatabase { (db) in
            
            if db.executeStatements(sql) {
                // print("清空表成功 classid = \(classid)")
            } else {
                // print("清空表失败 classid = \(classid)")
            }
        }
    }
    
    
}
