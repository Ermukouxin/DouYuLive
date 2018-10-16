//
//  NSDate-Extension.swift
//  DouYuLive
//
//  Created by ZXC on 2018/10/11.
//  Copyright © 2018年 ZXC. All rights reserved.
//

import Foundation

extension NSDate {

    // MARK: - 返回当前的时间戳
    class func getCurrentTime() -> String {
        let nowDate = NSDate()
        let interval = Int(nowDate.timeIntervalSince1970)
        return "\(interval)"
    }
}
