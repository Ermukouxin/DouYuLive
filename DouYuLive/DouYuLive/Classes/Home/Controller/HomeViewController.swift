//
//  HomeViewController.swift
//  DouYuLive
//
//  Created by ZXC on 2018/9/27.
//  Copyright © 2018年 ZXC. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置UI界面
        setUI()
    }
}

// MARK: - 设置UI界面
extension HomeViewController {
    private func setUI () {
        // 1，设置导航栏
        setNavigationBar()
    }
    
    // MARK: 设置导航栏
    private func setNavigationBar () {
        // 设置左边logo图标
        let size : CGSize = CGSize(width: 40, height: 40)
        
        // 使用类方法创建的UIBarButtonItem
        
        /*
         navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem(image: "logo", highImage: "logo", size: size)
        let historyItem = UIBarButtonItem.createBarButtonItem(image: "image_my_history", highImage: "Image_my_history_click", size: size)
        let searchItem  = UIBarButtonItem.createBarButtonItem(image: "btn_search", highImage: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem.createBarButtonItem(image: "Image_scan", highImage: "Image_scan_click", size: size)
        */
        
        // 使用类方法创建的UIBarButtonItem
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: "logo", highImage: "", size: size)
        let historyItem = UIBarButtonItem(image: "image_my_history", highImage: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(image: "btn_search", highImage: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(image: "Image_scan", highImage: "Image_scan_click", size: size)

        // 设置右边Items
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem]
    }
}