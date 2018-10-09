//
//  HomeViewController.swift
//  DouYuLive
//
//  Created by ZXC on 2018/9/27.
//  Copyright © 2018年 ZXC. All rights reserved.
//

import UIKit
// MARK: - 常量的定义
private let kTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {

    // MARK: - 懒加载属性
    private lazy var pageTitleView : PageTitleView = { [weak self] in
        let frame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titleView = PageTitleView(frame: frame, titlesArray: titles)
        titleView.delegate = self
        return titleView
    }()
    
    private lazy var pageContentView : PageContentView = { [weak self] in
        // 1,确定contentView的frame
        let contentH = kScreenH - kStatusBarH - kNavigationBarH - kTabBarH - kTitleViewH
        let frame : CGRect = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kTitleViewH , width: kScreenW, height: contentH)
       
        // 2,确定添加的子控制器
        var childVCs : [UIViewController] = [UIViewController]()
        childVCs.append(RecommendViewController()) // 添加第一个子控制器
        for _ in 0..<3 {
            let vc : UIViewController = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVCs.append(vc)
        }
        let pageContenView = PageContentView(frame: frame, childVCs: childVCs, parentViewController: self)
        pageContenView.delegate = self
    
        return pageContenView
    }()
    
    // MARK: - 系统的回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置UI界面
        setUI()
    }
}

// MARK: - 设置UI界面
extension HomeViewController {
    private func setUI () {
        // 0，不需要自动调整内边距
        automaticallyAdjustsScrollViewInsets = false
        
        // 1，设置导航栏
        setNavigationBar()
        
        // 2,添加PageTitleView
        view.addSubview(pageTitleView)
        
        // 3,添加PageContentView
        view.addSubview(pageContentView)
        
    }
    
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

// MARK: - 遵守pageTitleViewDelegate
extension HomeViewController : PageTitleViewDelegate {
    func pageTitleView(titleView: PageTitleView, selectIndex index: Int) {
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}

// MARK: - 遵守PageContentViewDelegate
extension HomeViewController : PageContentViewDelegate {
    func pageContentView(contentView: PageContentView, sourceIndex: Int, targetIndex: Int, scrollProgress: CGFloat) {
        pageTitleView.setTitleViewWithScrollProgress(scrollProgress: scrollProgress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
