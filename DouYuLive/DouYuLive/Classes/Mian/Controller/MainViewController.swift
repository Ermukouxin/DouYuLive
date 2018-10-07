//
//  MainViewController.swift
//  DouYuLive
//
//  Created by ZXC on 2018/9/27.
//  Copyright © 2018年 ZXC. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: 添加子控制器
        addChildVC(storyboardName: "Home")
        addChildVC(storyboardName: "Live")
        addChildVC(storyboardName: "Follow")
        addChildVC(storyboardName: "Profile")
    }

    func addChildVC(storyboardName : String) {
        // 通过storyboard创建控制器
        let childVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController()!
        // 添加子控制器到标签栏控制器中
        addChildViewController(childVC)
    }
}
