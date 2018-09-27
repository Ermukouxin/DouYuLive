//
//  AppDelegate.swift
//  DouYuLive
//
//  Created by ZXC on 2018/9/27.
//  Copyright © 2018年 ZXC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 同意设置图标的选中颜色
        UITabBar.appearance().tintColor = UIColor.orange
        
        return true
    }
}

